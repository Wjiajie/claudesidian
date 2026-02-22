---
parent: "[[nanobot-docs]]"
slug: nanobot-05-agent-core
title: Agent 核心引擎解析：nanobot 的智慧中枢
authors: [jiajiewu]
tags: [软件架构, Nanobot, Agent]
date: 2026-02-02
description: 深入解析 Nanobot 的核心引擎 AgentLoop，探讨其消息处理机制、上下文构建逻辑、工具调用流程以及会话管理系统的实现细节。
draft: false
---

# Agent 核心引擎解析：nanobot 的智慧中枢

> **系列导读**：在上一篇《架构总览与模块划分》中，我们从宏观视角认识了 nanobot 的四层架构。现在，让我们深入核心引擎层——`agent/` 模块，揭开 nanobot "智能"的神秘面纱。这里是 AI 助手真正"思考"的地方。

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

1. 理解 AgentLoop 的运行机制——消息是如何被处理的
2. 掌握 ContextBuilder 的上下文构建逻辑——AI 看到的"世界"是什么样的
3. 了解会话管理和记忆系统——AI 如何"记住"你
4. 理解工具调用的执行流程——AI 如何"动手"做事

---

## 🧠 费曼式解释：Agent 就是一个超级秘书

在深入代码之前，让我们用一个生活化的类比来理解 Agent 的工作原理。

想象你雇了一个**超级秘书**：

1. **接收任务**：老板（用户）发来一条消息
2. **准备材料**：秘书翻阅以往的对话记录、查看备忘录、准备相关技能说明
3. **请教专家**：把整理好的材料交给智囊团（LLM）分析
4. **执行行动**：如果智囊团说"需要查个资料"，秘书就去查
5. **汇报结果**：把查到的资料反馈给智囊团，继续讨论
6. **最终回复**：得到满意答案后，回复老板

这就是 AgentLoop 的核心工作流程。让我们看看代码是如何实现的。

---

## 📁 Agent 模块结构

```
nanobot/agent/
├── loop.py          # 🔄 AgentLoop - 核心处理循环
├── context.py       # 📝 ContextBuilder - 上下文构建器
├── memory.py        # 🧠 MemoryStore - 长期记忆
├── skills.py        # 🎯 SkillsLoader - 技能加载器
├── subagent.py      # 👥 SubagentManager - 子代理管理
└── tools/           # 🔧 工具集合
    ├── base.py      #     Tool 基类
    ├── registry.py  #     ToolRegistry - 工具注册表
    └── ...          #     各种具体工具
```

---

## 🔄 AgentLoop：核心处理循环

AgentLoop 是 nanobot 的心脏，负责接收消息、调用 LLM、执行工具、返回结果。

### 初始化：组装零部件

```python
# agent/loop.py
class AgentLoop:
    """
    The agent loop is the core processing engine.

    It:
    1. Receives messages from the bus
    2. Builds context with history, memory, skills
    3. Calls the LLM
    4. Executes tool calls
    5. Sends responses back
    """

    def __init__(
        self,
        bus: MessageBus,
        provider: LLMProvider,
        workspace: Path,
        model: str | None = None,
        max_iterations: int = 20,
        brave_api_key: str | None = None,
        exec_config: "ExecToolConfig | None" = None,
        cron_service: "CronService | None" = None,
        restrict_to_workspace: bool = False,
    ):
        self.bus = bus                          # 消息总线
        self.provider = provider                # LLM 提供商
        self.workspace = workspace              # 工作目录
        self.model = model or provider.get_default_model()
        self.max_iterations = max_iterations    # 最大迭代次数

        # 核心组件
        self.context = ContextBuilder(workspace)  # 上下文构建器
        self.sessions = SessionManager(workspace) # 会话管理器
        self.tools = ToolRegistry()               # 工具注册表
        self.subagents = SubagentManager(...)     # 子代理管理器

        self._running = False
        self._register_default_tools()  # 注册默认工具
```

**设计亮点**：
- **组合模式**：AgentLoop 组合了多个专职组件，每个组件负责一个明确的职责
- **配置灵活**：通过参数控制最大迭代次数、工作空间限制等
- **延迟初始化**：`_register_default_tools()` 在构造函数中调用，确保工具就绪

### 主循环：永不停歇的消息处理

```python
async def run(self) -> None:
    """Run the agent loop, processing messages from the bus."""
    self._running = True
    logger.info("Agent loop started")

    while self._running:
        try:
            # 等待下一条消息（1秒超时）
            msg = await asyncio.wait_for(
                self.bus.consume_inbound(),
                timeout=1.0
            )

            # 处理消息
            try:
                response = await self._process_message(msg)
                if response:
                    await self.bus.publish_outbound(response)
            except Exception as e:
                logger.error(f"Error processing message: {e}")
                # 发送错误响应
                await self.bus.publish_outbound(OutboundMessage(
                    channel=msg.channel,
                    chat_id=msg.chat_id,
                    content=f"Sorry, I encountered an error: {str(e)}"
                ))
        except asyncio.TimeoutError:
            continue  # 超时后继续循环
```

**关键设计**：
- **非阻塞轮询**：使用 1 秒超时避免永久阻塞，允许优雅停止
- **错误隔离**：单条消息处理失败不会影响整个循环
- **友好错误回复**：出错时向用户发送错误信息

### 消息处理：推理循环的核心

这是 AgentLoop 最重要的方法，让我们逐步拆解：

```python
async def _process_message(self, msg: InboundMessage) -> OutboundMessage | None:
    """Process a single inbound message."""

    # 1️⃣ 处理系统消息（子代理回调）
    if msg.channel == "system":
        return await self._process_system_message(msg)

    logger.info(f"Processing message from {msg.channel}:{msg.sender_id}")

    # 2️⃣ 获取或创建会话
    session = self.sessions.get_or_create(msg.session_key)

    # 3️⃣ 更新工具上下文（让工具知道当前的 channel 和 chat_id）
    message_tool = self.tools.get("message")
    if isinstance(message_tool, MessageTool):
        message_tool.set_context(msg.channel, msg.chat_id)

    spawn_tool = self.tools.get("spawn")
    if isinstance(spawn_tool, SpawnTool):
        spawn_tool.set_context(msg.channel, msg.chat_id)

    cron_tool = self.tools.get("cron")
    if isinstance(cron_tool, CronTool):
        cron_tool.set_context(msg.channel, msg.chat_id)

    # 4️⃣ 构建初始消息列表
    messages = self.context.build_messages(
        history=session.get_history(),
        current_message=msg.content,
        media=msg.media if msg.media else None,
        channel=msg.channel,
        chat_id=msg.chat_id,
    )

    # 5️⃣ 推理循环
    iteration = 0
    final_content = None

    while iteration < self.max_iterations:
        iteration += 1

        # 调用 LLM
        response = await self.provider.chat(
            messages=messages,
            tools=self.tools.get_definitions(),
            model=self.model
        )

        # 处理工具调用
        if response.has_tool_calls:
            # 添加助手消息（包含工具调用）
            tool_call_dicts = [
                {
                    "id": tc.id,
                    "type": "function",
                    "function": {
                        "name": tc.name,
                        "arguments": json.dumps(tc.arguments)
                    }
                }
                for tc in response.tool_calls
            ]
            messages = self.context.add_assistant_message(
                messages, response.content, tool_call_dicts
            )

            # 执行每个工具调用
            for tool_call in response.tool_calls:
                logger.debug(f"Executing tool: {tool_call.name}")
                result = await self.tools.execute(tool_call.name, tool_call.arguments)
                messages = self.context.add_tool_result(
                    messages, tool_call.id, tool_call.name, result
                )
        else:
            # 无工具调用，结束循环
            final_content = response.content
            break

    # 6️⃣ 保存会话历史
    if final_content is None:
        final_content = "I've completed processing but have no response to give."

    session.add_message("user", msg.content)
    session.add_message("assistant", final_content)
    self.sessions.save(session)

    # 7️⃣ 返回响应
    return OutboundMessage(
        channel=msg.channel,
        chat_id=msg.chat_id,
        content=final_content
    )
```

### 推理循环流程图

```
┌─────────────────────────────────────────────────────────────────┐
│                        _process_message()                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐                                               │
│  │ 1. 获取会话   │  session = sessions.get_or_create(key)       │
│  └──────┬───────┘                                               │
│         │                                                        │
│         ▼                                                        │
│  ┌──────────────┐                                               │
│  │ 2. 构建消息   │  messages = context.build_messages(...)      │
│  └──────┬───────┘                                               │
│         │                                                        │
│         ▼                                                        │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                   3. 推理循环                            │    │
│  │  ┌─────────────────────────────────────────────────┐    │    │
│  │  │                                                 │    │    │
│  │  │  ┌────────────────┐                            │    │    │
│  │  │  │ 调用 LLM       │  provider.chat(messages)   │    │    │
│  │  │  └───────┬────────┘                            │    │    │
│  │  │          │                                     │    │    │
│  │  │          ▼                                     │    │    │
│  │  │  ┌────────────────┐    Yes    ┌─────────────┐ │    │    │
│  │  │  │ 有工具调用？    │─────────▶│ 执行工具    │ │    │    │
│  │  │  └───────┬────────┘          │ 追加结果    │ │    │    │
│  │  │          │ No                 └──────┬──────┘ │    │    │
│  │  │          │                           │        │    │    │
│  │  │          ▼                           │        │    │    │
│  │  │  ┌────────────────┐                  │        │    │    │
│  │  │  │ 结束循环       │◀─────────────────┘        │    │    │
│  │  │  │ 获取最终回复   │      (继续下一轮)         │    │    │
│  │  │  └────────────────┘                           │    │    │
│  │  │                                                │    │    │
│  │  └────────────────────────────────────────────────┘    │    │
│  │                    最多 20 次迭代                       │    │
│  └─────────────────────────────────────────────────────────┘    │
│         │                                                        │
│         ▼                                                        │
│  ┌──────────────┐                                               │
│  │ 4. 保存会话   │  session.add_message(...); sessions.save()   │
│  └──────┬───────┘                                               │
│         │                                                        │
│         ▼                                                        │
│  ┌──────────────┐                                               │
│  │ 5. 返回响应   │  OutboundMessage(channel, chat_id, content)  │
│  └──────────────┘                                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 为什么限制 20 次迭代？

```python
max_iterations: int = 20
```

这是一个**安全阀**设计：

1. **防止无限循环**：如果 LLM 一直返回工具调用，可能陷入死循环
2. **控制成本**：每次 LLM 调用都消耗 API 额度
3. **保证响应时间**：用户不会等待太久

实际使用中，大多数对话在 1-5 次迭代内完成：

| 场景 | 迭代次数 |
|------|----------|
| 简单问答 | 1 次 |
| 搜索+回答 | 2 次 |
| 读取文件+分析 | 2-3 次 |
| 复杂任务（多步操作） | 3-10 次 |

---

## 📝 ContextBuilder：构建 AI 的"世界观"

ContextBuilder 负责组装发送给 LLM 的完整上下文。这就像在给 AI 准备"考试材料"——材料越完整，AI 的回答越好。

### 核心职责

```python
# agent/context.py
class ContextBuilder:
    """
    Builds the context (system prompt + messages) for the agent.

    Assembles bootstrap files, memory, skills, and conversation history
    into a coherent prompt for the LLM.
    """

    BOOTSTRAP_FILES = ["AGENTS.md", "SOUL.md", "USER.md", "TOOLS.md", "IDENTITY.md"]

    def __init__(self, workspace: Path):
        self.workspace = workspace
        self.memory = MemoryStore(workspace)    # 记忆存储
        self.skills = SkillsLoader(workspace)   # 技能加载器
```

### 系统提示词的构建

系统提示词是 AI 的"身份证"和"操作手册"，决定了 AI 的行为方式：

```python
def build_system_prompt(self, skill_names: list[str] | None = None) -> str:
    """Build the system prompt from bootstrap files, memory, and skills."""
    parts = []

    # 1️⃣ 核心身份
    parts.append(self._get_identity())

    # 2️⃣ 引导文件（用户自定义的指令）
    bootstrap = self._load_bootstrap_files()
    if bootstrap:
        parts.append(bootstrap)

    # 3️⃣ 记忆上下文
    memory = self.memory.get_memory_context()
    if memory:
        parts.append(f"# Memory\n\n{memory}")

    # 4️⃣ 始终加载的技能
    always_skills = self.skills.get_always_skills()
    if always_skills:
        always_content = self.skills.load_skills_for_context(always_skills)
        if always_content:
            parts.append(f"# Active Skills\n\n{always_content}")

    # 5️⃣ 可用技能列表（按需加载）
    skills_summary = self.skills.build_skills_summary()
    if skills_summary:
        parts.append(f"""# Skills

The following skills extend your capabilities. To use a skill, read its SKILL.md file using the read_file tool.
Skills with available="false" need dependencies installed first.

{skills_summary}""")

    return "\n\n---\n\n".join(parts)
```

### 核心身份：AI 的"自我介绍"

```python
def _get_identity(self) -> str:
    """Get the core identity section."""
    from datetime import datetime
    now = datetime.now().strftime("%Y-%m-%d %H:%M (%A)")
    workspace_path = str(self.workspace.expanduser().resolve())
    system = platform.system()
    runtime = f"{'macOS' if system == 'Darwin' else system} {platform.machine()}"

    return f"""# nanobot 🐈

You are nanobot, a helpful AI assistant. You have access to tools that allow you to:
- Read, write, and edit files
- Execute shell commands
- Search the web and fetch web pages
- Send messages to users on chat channels
- Spawn subagents for complex background tasks

## Current Time
{now}

## Runtime
{runtime}

## Workspace
Your workspace is at: {workspace_path}
- Memory files: {workspace_path}/memory/MEMORY.md
- Daily notes: {workspace_path}/memory/YYYY-MM-DD.md
- Custom skills: {workspace_path}/skills/{{skill-name}}/SKILL.md

IMPORTANT: When responding to direct questions or conversations, reply directly with your text response.
Only use the 'message' tool when you need to send a message to a specific chat channel.
For normal conversation, just respond with text - do not call the message tool.

Always be helpful, accurate, and concise. When using tools, explain what you're doing.
When remembering something, write to {workspace_path}/memory/MEMORY.md"""
```

**设计亮点**：
- **动态信息**：当前时间、运行环境、工作目录都是实时生成的
- **明确指令**：告诉 AI 什么时候用工具，什么时候直接回复
- **路径指引**：指明记忆和技能文件的存放位置

### 消息列表的构建

```python
def build_messages(
    self,
    history: list[dict[str, Any]],
    current_message: str,
    skill_names: list[str] | None = None,
    media: list[str] | None = None,
    channel: str | None = None,
    chat_id: str | None = None,
) -> list[dict[str, Any]]:
    """Build the complete message list for an LLM call."""
    messages = []

    # 1️⃣ 系统提示词
    system_prompt = self.build_system_prompt(skill_names)
    if channel and chat_id:
        system_prompt += f"\n\n## Current Session\nChannel: {channel}\nChat ID: {chat_id}"
    messages.append({"role": "system", "content": system_prompt})

    # 2️⃣ 历史对话
    messages.extend(history)

    # 3️⃣ 当前用户消息（可能包含图片）
    user_content = self._build_user_content(current_message, media)
    messages.append({"role": "user", "content": user_content})

    return messages
```

### 消息格式示意

发送给 LLM 的消息列表看起来像这样：

```json
[
  {
    "role": "system",
    "content": "# nanobot 🐈\n\nYou are nanobot, a helpful AI assistant..."
  },
  {
    "role": "user",
    "content": "帮我查一下明天的天气"
  },
  {
    "role": "assistant",
    "content": null,
    "tool_calls": [
      {
        "id": "call_abc123",
        "type": "function",
        "function": {
          "name": "web_search",
          "arguments": "{\"query\": \"北京明天天气预报\"}"
        }
      }
    ]
  },
  {
    "role": "tool",
    "tool_call_id": "call_abc123",
    "name": "web_search",
    "content": "北京明天晴，气温 15-25°C..."
  },
  {
    "role": "assistant",
    "content": "根据搜索结果，北京明天天气晴朗，气温在 15-25°C 之间，非常适合户外活动！"
  }
]
```

### 工具结果的追加

当工具执行完成后，需要把结果追加到消息列表：

```python
def add_tool_result(
    self,
    messages: list[dict[str, Any]],
    tool_call_id: str,
    tool_name: str,
    result: str
) -> list[dict[str, Any]]:
    """Add a tool result to the message list."""
    messages.append({
        "role": "tool",
        "tool_call_id": tool_call_id,
        "name": tool_name,
        "content": result
    })
    return messages

def add_assistant_message(
    self,
    messages: list[dict[str, Any]],
    content: str | None,
    tool_calls: list[dict[str, Any]] | None = None
) -> list[dict[str, Any]]:
    """Add an assistant message to the message list."""
    msg: dict[str, Any] = {"role": "assistant", "content": content or ""}

    if tool_calls:
        msg["tool_calls"] = tool_calls

    messages.append(msg)
    return messages
```

### 步骤 3：执行工具

```python
for tool_call in response.tool_calls:
    result = await self.tools.execute(tool_call.name, tool_call.arguments)
    messages = self.context.add_tool_result(
        messages, tool_call.id, tool_call.name, result
    )
```

### 步骤 4：继续下一轮

带着工具结果，再次调用 LLM，直到 LLM 不再请求工具调用。

```
┌──────────────────────────────────────────────────────────────────┐
│                      工具调用执行流程                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  用户: "帮我搜索一下今天的新闻"                                    │
│         │                                                        │
│         ▼                                                        │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ 第 1 轮 LLM 调用                                         │    │
│  │ 输入: [system, user: "帮我搜索一下今天的新闻"]            │    │
│  │ 输出: tool_calls: [web_search(query="今日新闻")]         │    │
│  └───────────────────────────┬─────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ 执行 web_search 工具                                     │    │
│  │ 结果: "1. 重大科技突破... 2. 经济新政..."                 │    │
│  └───────────────────────────┬─────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ 第 2 轮 LLM 调用                                         │    │
│  │ 输入: [system, user, assistant(tool_calls), tool(结果)]  │    │
│  │ 输出: "今天的主要新闻有：1. 重大科技突破..."             │    │
│  │       （无 tool_calls，结束循环）                         │    │
│  └───────────────────────────┬─────────────────────────────┘    │
│                              │                                   │
│                              ▼                                   │
│  返回最终回复给用户                                              │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🔌 直接处理模式

除了通过 MessageBus 处理消息，AgentLoop 还提供了直接处理模式，用于 CLI 和定时任务：

```python
async def process_direct(
    self,
    content: str,
    session_key: str = "cli:direct",
    channel: str = "cli",
    chat_id: str = "direct",
) -> str:
    """Process a message directly (for CLI or cron usage)."""
    msg = InboundMessage(
        channel=channel,
        sender_id="user",
        chat_id=chat_id,
        content=content
    )

    response = await self._process_message(msg)
    return response.content if response else ""
```

这让命令行用户可以直接与 AI 对话，无需启动完整的消息总线。

---

## 📝 小结

在这篇文章中，我们深入解析了 nanobot 的核心引擎：

- ✅ **AgentLoop**：消息处理的主循环，包含推理迭代逻辑
- ✅ **ContextBuilder**：构建发送给 LLM 的完整上下文（身份 + 记忆 + 技能 + 历史）
- ✅ **SessionManager**：管理对话历史，支持持久化存储
- ✅ **MemoryStore**：长期记忆和每日笔记系统
- ✅ **SkillsLoader**：渐进式技能加载机制
- ✅ **工具调用流程**：从请求到执行到结果追加的完整链路

核心引擎的设计体现了"简单但不简陋"的理念——用最少的代码实现完整的 AI Agent 功能。

---

> **下一篇预告**：[《工具系统设计与实现：Tool 抽象和工具注册机制》](./2026-02-03-nanobot-06-tools-system.md)
>
> 我们将深入 `agent/tools/` 目录，看看 nanobot 是如何设计工具抽象、如何注册和执行工具的。工具是 AI Agent 的"手"，让 AI 能够真正"动手"做事。

---

*本文是 nanobot 深度解析系列的第 5 篇，共 11 篇。*

