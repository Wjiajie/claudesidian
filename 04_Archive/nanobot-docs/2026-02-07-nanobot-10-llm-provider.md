---
parent: "[[nanobot-docs]]"
slug: nanobot-10-llm-provider
title: LLMServiceAdapter与模型接入：打造 AI 的"通用翻译官"
authors: [jiajiewu]
tags: [软件架构, Nanobot, LLM]
date: 2026-02-07
description: 详解 Nanobot 的各类 LLM 服务接入方案，涵盖 OpenAI 兼容接口封装、多模型路由策略以及流式响应处理机制。
draft: false
---

# LLM 服务适配与模型接入：打造 AI 的"通用翻译官"

> **系列导读**：在上一篇，我们解决了记忆持久化的问题。现在，我们来到整个系统的"心脏"——大语言模型（LLM）。OpenAI, Anthropic, Gemini, DeepSeek, Groq... 新模型层出不穷，API 各有千秋。nanobot 如何从容应对？答案就是 **Provider 层**。


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

1. 理解抽象层（Adapter Pattern）在 LLM 接入中的必要性
2. 掌握 `LLMProvider` 接口设计
3. 学习如何利用 `litellm` 简化多模型调用
4. 实现一个具体的 Model Adapter（以 LiteLLM 为例）

---

## 🔌 为什么需要 Provider 层？

**直接调用的痛苦**：
- OpenAI 用 `client.chat.completions.create`
- Anthropic 用 `client.messages.create`
- Google 用 `genai.GenerativeModel`
- 本地 Ollama 用 `requests.post`

如果你的 Agent 逻辑里充满了 `if model == "gpt-4": ... elif model == "claude-3": ...`，这简直是维护噩梦。

**nanobot 的解法**：
定义一个统一的 `LLMProvider` 接口，所有的 Agent 逻辑只针对这个接口编程。

---

## 🏗️ LLMProvider：定义通用契约

我们并不关心后台是哪个公司的模型，我们只关心：
1.  **输入**：Message List (User/System) + Tools Definition
2.  **输出**：Text Content + Tool Calls

```python
# provider/base.py
@dataclass
class ChatResponse:
    content: str | None
    tool_calls: list[ToolCallRequest] | None

    @property
    def has_tool_calls(self) -> bool:
        return bool(self.tool_calls)

class LLMProvider(ABC):
    """Abstract base class for LLM providers."""

    @abstractmethod
    async def chat(
        self,
        messages: list[dict],
        tools: list[dict] | None = None,
        model: str | None = None,
        **kwargs
    ) -> ChatResponse:
        """
        Send a chat completion request.
        
        Args:
            messages: List of message dicts (role, content)
            tools: List of tool definitions (OpenAI format)
            model: Model identifier
        """
        pass

    @abstractmethod
    def get_default_model(self) -> str:
        """Get the default model ID."""
        pass
```

**设计亮点**：
- **核心抽象**：`chat` 方法涵盖了所有对话需求。
- **标准化响应**：`ChatResponse` 屏蔽了不同 SDK 返回对象的差异。
- **工具支持**：`tools` 参数已经是所有现代 LLM 的标配。

---

## 🚀 LiteLLMProvider：站在巨人的肩膀上

虽然我们可以为每个厂商写一个 Provider 实现（如 `OpenAIProvider`, `AnthropicProvider`），但维护成本太高。

nanobot 选择使用 [LiteLLM](https://github.com/BerriAI/litellm) 库。LiteLLM 本身就是一个超级适配器，它统一了 100+ 模型厂商的 API 为 OpenAI 格式。

```python
# provider/litellm_provider.py
from litellm import acompletion

class LiteLLMProvider(LLMProvider):
    def __init__(self, config: dict):
        self.config = config
        self.default_model = config.get("default_model", "gpt-4o")
        # 设置 API Keys (litellm 会自动从环境变量读取，这里也可以手动设置)
        if "openai_api_key" in config:
            os.environ["OPENAI_API_KEY"] = config["openai_api_key"]
        # ... 其他 key

    async def chat(
        self,
        messages: list[dict],
        tools: list[dict] | None = None,
        model: str | None = None,
        **kwargs
    ) -> ChatResponse:
        target_model = model or self.default_model

        try:
            # 1. 调用 LiteLLM
            response = await acompletion(
                model=target_model,
                messages=messages,
                tools=tools,
                temperature=kwargs.get("temperature", 0.7),
            )
            
            # 2. 提取结果
            choice = response.choices[0]
            message = choice.message
            
            # 3. 转换为 ChatResponse
            tool_calls = []
            if message.tool_calls:
                for tc in message.tool_calls:
                    tool_calls.append(ToolCallRequest(
                        id=tc.id,
                        name=tc.function.name,
                        arguments=json.loads(tc.function.arguments)
                    ))
            
            return ChatResponse(
                content=message.content,
                tool_calls=tool_calls if tool_calls else None
            )

        except Exception as e:
            logger.error(f"LLM Error: {e}")
            raise
```

**LiteLLM 的优势**：
- **即插即用**：只需修改模型名称（如 `gpt-4` -> `claude-3-opus-20240229`），代码完全不用变。
- **成本控制**：内置了 Token 计算和预算管理。
- **容错重试**：自动处理 API Rate Limit 问题。

---

## 🔀 GroqProvider：极速体验

虽然 LiteLLM 很好，但有时为了极致性能（如 Groq 的 LPU 推理），直接对接原生 SDK 也是必要的。nanobot 实现了专门的 `GroqProvider` 用于语音转文字等任务。

```python
# provider/groq_provider.py
class GroqProvider(LLMProvider):
    def __init__(self, api_key: str):
        self.client = AsyncGroq(api_key=api_key)

    async def chat(self, ...):
        # Groq 的 SDK 与 OpenAI 几乎一致
        resp = await self.client.chat.completions.create(...)
        # ...
```

---

## 🧩 配置即路由

用户可以在 `config.json` 中灵活配置模型：

```json
{
  "llm": {
    "provider": "litellm",
    "default_model": "gpt-4o",
    "api_keys": {
      "OPENAI_API_KEY": "sk-...",
      "ANTHROPIC_API_KEY": "sk-ant-..."
    }
  }
}
```

甚至可以为不同任务指定不同模型：
- **聊天**：`claude-3-5-sonnet` (聪明、自然)
- **工具调用**：`gpt-4o` (精准、鲁棒)
- **快速问答**：`llama3-70b` (通过 Groq，速度快)

AgentLoop 在调用 `provider.chat(model=...)` 时，可以根据任务动态传入 model 参数。

---

## 📝 小结

nanobot 的 Provider 层设计体现了"依赖倒置"原则：

- ✅ **LLMProvider**：可以看作是 nanobot 定义的"模型标准"。
- ✅ **LiteLLM**：是实现这个标准的"超级工人"。
- ✅ **配置化**：让切换模型像换台一样简单。

现在，我们有了大脑（Agent）、双手（Tools）、神经（Bus）、感官（Channels）、记忆（Session）和智慧源泉（LLM）。

那么，这一切是如何组合在一起，形成一个完整的生态系统的呢？在这个系列长跑的最后一篇，我们将展望未来。

---

> **下一篇预告**：[《未来展望与生态建设：通往 AGI 的星辰大海》](./2026-02-08-nanobot-11-future-outlook.md)
>
> 我们将讨论 nanobot 未来的发展方向：多模态、分布式 Agent 协作、Plugin 市场。

---

*本文是 nanobot 深度解析系列的第 10 篇，共 11 篇。*

