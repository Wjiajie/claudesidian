---
parent: "[[nanobot-docs]]"
slug: nanobot-09-session-memory
title: 会话管理与记忆系统：让 nanobot 拥有"记忆"
authors: [jiajiewu]
tags: [软件架构, Nanobot, Session]
date: 2026-02-06
description: 揭秘 Nanobot 的记忆系统实现，包括会话上下文管理、长短期记忆存储策略以及 JSONL 格式的会话持久化机制。
draft: false
---

# 会话管理与记忆系统：让 nanobot 拥有"记忆"

> **系列导读**：在上一篇，我们解决了 nanobot 与世界的连接问题。但一个真正的智能助手，不仅要能"听"和"说"，还要能"记住"。如果你告诉它你的名字，第二天它却忘了，那体验简直糟糕透顶。本篇将深入探讨 nanobot 的记忆系统。


<!-- truncate -->

> **Nanobot 系列导航**
>
> 01. [项目概览与设计哲学：为什么我们需要另一个 Bot 框架？](./2026-01-29-nanobot-01-overview.md)
> 02. [安装配置完全指南：五分钟搭建你的 AI 助手](./2026-01-30-nanobot-02-installation.md)
> 03. [多渠道接入配置详解：连接 Telegram, Discord, WhatsApp 与飞书](./2026-01-31-nanobot-03-channels-setup.md)
> 04. [架构总览与模块划分：Nanobot 的内功心法](./2026-02-01-nanobot-04-architecture.md)
> 05. [Agent 核心引擎解析：nanobot 的智慧中枢](./2026-02-02-nanobot-05-agent-core.md)
> 06. [工具系统设计与实现：让 AI 拥有"双手"](./2026-02-03-nanobot-06-tools-system.md)
> 07. [消息总线与事件系统：nanobot 的"神经网络"](./2026-02-04-nanobot-07-message-bus.md)
> 08. [Channel 适配器实现：让 AI 连接世界](./2026-02-05-nanobot-08-channel-adapters.md)
> 09. [会话管理与记忆系统：让 nanobot 拥有"记忆"](./2026-02-06-nanobot-09-session-memory.md)
> 10. [LLMServiceAdapter与模型接入：打造 AI 的"通用翻译官"](./2026-02-07-nanobot-10-llm-provider.md)
> 11. [未来展望与生态建设：通往 AGI 的星辰大海](./2026-02-08-nanobot-11-future-outlook.md)


---

## 🎯 本文目标

读完这篇文章，你将能够：

1. 理解 Session 与 Memory 的区别
2. 掌握基于 JSONL 的高效会话存储方案
3. 学习简单的长短期记忆实现策略
4. 了解 ContextBuilder 如何组装记忆

---

## 🧠 记忆的分层：短期 vs 长期

nanobot 的记忆系统分为两层：

1.  **Session（会话/短期记忆）**：
    - **范围**：当前聊天窗口（如 Telegram 的某个 Chat ID）
    - **内容**：最近的 N 轮对话历史
    - **作用**：让 AI 理解上下文（比如"它"指代上文提到的什么）
    - **生命周期**：随会话持续，但送给 LLM 时会截断

2.  **Memory（长期记忆）**：
    - **范围**：全局（Agent 级别）
    - **内容**：用户偏好、重要事实、总结
    - **作用**：跨会话、跨平台地记住信息
    - **生命周期**：永久存储

---

## 💬 SessionManager：会话的守门人

每个用户或群组的对话都是一个 `Session`。

### Session 模型

```python
# session/manager.py
@dataclass
class Session:
    """A conversation session."""

    key: str                    # 唯一标识 (channel:chat_id)
    messages: list[dict]        # 消息列表
    created_at: datetime
    updated_at: datetime
    metadata: dict              # 额外信息 (如最后一次 Tool Call)

    def add_message(self, role: str, content: str, **kwargs) -> None:
        """Add a message to the session."""
        msg = {
            "role": role,
            "content": content,
            "timestamp": datetime.now().isoformat(),
            **kwargs
        }
        self.messages.append(msg)
        self.updated_at = datetime.now()

    def get_history(self, max_messages: int = 50) -> list[dict]:
        """Get context window for LLM."""
        # 只返回最近的 N 条消息，防止 Context Window 溢出
        recent = self.messages[-max_messages:]
        return [{"role": m["role"], "content": m["content"]} for m in recent]
```

### JSONL 存储设计

为什么选择 JSONL (JSON Lines) 而不是 SQLite 或单个 JSON 文件？

```json
{"_type": "metadata", "created_at": "...", "updated_at": "..."}
{"role": "user", "content": "你好", "timestamp": "..."}
{"role": "assistant", "content": "你好！", "timestamp": "..."}
```

**理由**：
1.  **Append-Only**：写入性能极高，每次只需在文件末尾追加一行。
2.  **容错性**：即使程序崩溃，已写入的行依然有效，不会导致整个文件损坏。
3.  **流式读取**：读取大文件时不需要一次性加载到内存，可以逐行处理。
4.  **Git 友好**：文本格式，方便版本控制和 Diff。

```python
# session/manager.py
    def save(self, session: Session) -> None:
        path = self._get_session_path(session.key)
        
        # 简单实现：全量重写（生产环境可优化为增量追加）
        with open(path, "w", encoding="utf-8") as f:
            # 写元数据
            meta = {
                "_type": "metadata",
                "created_at": session.created_at.isoformat(),
                "updated_at": session.updated_at.isoformat(),
                "metadata": session.metadata
            }
            f.write(json.dumps(meta) + "\n")
            
            # 写消息
            for msg in session.messages:
                f.write(json.dumps(msg) + "\n")
```

---

## 📝 MemoryStore：简单的长期记忆

相比于复杂的向量数据库（RAG），nanobot 采用了更简单直观的 Markdown 文件作为记忆存储。

**设计理念**：
- 对于个人助手，数据量并不大（几 MB 文本）。
- LLM 的 Context Window 越来越大（128k+）。
- 既然能把整个记忆放进 Context，为什么还要引入复杂的向量检索？

```python
# agent/memory.py
class MemoryStore:
    """Simple file-based memory store."""

    def __init__(self, workspace: Path):
        self.memory_file = workspace / "memory" / "MEMORY.md"

    def read(self) -> str:
        if self.memory_file.exists():
            return self.memory_file.read_text(encoding="utf-8")
        return ""

    def append(self, text: str) -> None:
        """Append new memory."""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
        entry = f"\n- [{timestamp}] {text}"
        
        if self.memory_file.exists():
            content = self.memory_file.read_text()
            self.memory_file.write_text(content + entry)
        else:
            self.memory_file.write_text(f"# Memory\n{entry}")
```

AI 被指示在需要记住重要信息时，通过工具（如 `write_file` 或专门的 `remember` 工具）向 `MEMORY.md` 写入内容。

---

## 🧩 上下文组装：ContextBuilder

ContextBuilder 是连接 Session、Memory 和 LLM 的桥梁。它的任务是将这些零散的信息拼装成一个完整的 Prompt。

```python
# agent/context.py
    def build_messages(self, history: list, current_msg: str, ...) -> list:
        messages = []

        # 1. System Prompt (包含长期记忆)
        system_prompt = self._build_system_prompt()
        # 将 MEMORY.md 的内容注入 System Prompt
        memory_content = self.memory.read()
        if memory_content:
             system_prompt += f"\n\n## Long-term Memory\n{memory_content}"
        
        messages.append({"role": "system", "content": system_prompt})

        # 2. History (短期记忆)
        # Session 中的对话历史
        messages.extend(history)

        # 3. Current Message
        messages.append({"role": "user", "content": current_msg})

        return messages
```

### Prompt 结构示例

```markdown
# System
You are nanobot...

## Long-term Memory
- [2024-01-01] User name is Jiajie.
- [2024-01-02] User prefers Python over Java.

---
# History
User: High quality coffee beans?
Assistant: Arabica is good.

# Current
User: Where to buy them?
```

这样，即使在新的 Session 中，AI 也能通过 System Prompt 中的 Long-term Memory 知道用户的偏好。

---

## 🚀 未来演进：RAG 与向量数据库

虽然当前的文件方案简单有效，但随着记忆量的增长，Context Window 终将被填满。未来的演进方向是 **RAG (Retrieval-Augmented Generation)**：

1.  **Embedding**：将每条记忆转化为向量。
2.  **Vector DB**：存储向量（如 ChromaDB, Qdrant）。
3.  **Retrieval**：根据用户 query 检索最相关的 Top-K 条记忆。
4.  **Inject**：只将相关的记忆注入 Prompt。

nanobot 目前的架构已经预留了 `MemoryStore` 接口，未来可以用 RAG 实现无缝替换，而无需修改上层逻辑。

---

## 📝 小结

nanobot 的记忆系统设计通过区分 Session 和 Memory，在保持简单的同时实现了强大的上下文能力。

- ✅ **Session**：基于 JSONL 的高效、健壮的短期对话存储
- ✅ **Memory**：基于 Markdown 的直观长期记忆
- ✅ **ContextBuilder**：动态组装记忆，最大化利用 LLM 的 Context Window

有了记忆，nanobot 就不再是一个冷冰冰的问答机器，而是一个能够积累经验、了解你的伙伴。

下一篇，我们将讨论 nanobot 的大脑——LLM 服务适配。

---

> **下一篇预告**：[《LLM 服务适配与模型接入：打造 AI 的"通用翻译官"》](./2026-02-07-nanobot-10-llm-provider.md)
>
> 我们将学习如何封装 `LLMProvider`，统一 OpenAI, Anthropic, Gemini, Groq 等不同模型的调用接口。

---

*本文是 nanobot 深度解析系列的第 9 篇，共 11 篇。*

