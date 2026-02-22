---
parent: "[[nanobot-docs]]"
slug: nanobot-04-architecture
title: 架构总览与模块划分：Nanobot 的内功心法
authors: [jiajiewu]
tags: [软件架构, Nanobot]
date: 2026-02-01
description: 深入解析 Nanobot 的四层架构：Channel 层（多渠道适配）、MessageBus（异步消息总线）、AgentLoop（核心推理循环）和 LLMProvider（模型抽象）。揭示其解耦设计与数据流转机制。
draft: false
---

# 架构总览与模块划分：nanobot 的内功心法

> **系列导读**：在前三篇文章中，我们了解了 nanobot 的设计哲学、完成了安装配置、并学会了接入多个聊天渠道。现在是时候打开引擎盖，看看这台"极简机器"是如何运转的了。本文将带你从宏观视角审视 nanobot 的整体架构——先见森林，再见树木。


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

1. 理解 nanobot 的四层架构设计
2. 掌握核心数据流：消息是如何从用户流向 AI 再返回的
3. 认识各个模块的职责边界
4. 理解设计原则：为什么这样设计？

## 🏛️ 四层架构：像邮局一样工作

### 费曼式解释：AI 助手就是一个智能邮局

让我用一个生活化的类比来解释 nanobot 的架构。

想象一个**智能邮局**：

1. **收发室（Channels）**：接收来自不同渠道的信件（Telegram、Discord、微信...）
2. **分拣中心（MessageBus）**：统一格式，排队处理
3. **处理大厅（AgentLoop）**：智能分析信件内容，决定如何处理
4. **外部顾问（Provider）**：需要专业意见时，咨询 AI 专家

```
┌─────────────────────────────────────────────────────────────────┐
│                        nanobot 架构全景                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐           │
│   │Telegram │  │ Discord │  │WhatsApp │  │  飞书   │  ← 渠道层  │
│   └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘           │
│        │            │            │            │                 │
│        └────────────┴─────┬──────┴────────────┘                 │
│                           ▼                                     │
│                  ┌─────────────────┐                            │
│                  │   MessageBus    │  ← 消息总线层               │
│                  │  (异步队列)      │                            │
│                  └────────┬────────┘                            │
│                           ▼                                     │
│                  ┌─────────────────┐                            │
│                  │   AgentLoop     │  ← 核心引擎层               │
│                  │  ┌───────────┐  │                            │
│                  │  │ Context   │  │                            │
│                  │  │ Tools     │  │                            │
│                  │  │ Sessions  │  │                            │
│                  │  └───────────┘  │                            │
│                  └────────┬────────┘                            │
│                           ▼                                     │
│                  ┌─────────────────┐                            │
│                  │   LLMProvider   │  ← 模型抽象层               │
│                  │  (LiteLLM)      │                            │
│                  └─────────────────┘                            │
│                           ▼                                     │
│              ┌─────────────────────────┐                        │
│              │  Claude / GPT / DeepSeek │  ← 外部 AI 服务        │
│              └─────────────────────────┘                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 为什么是四层？

这种分层设计遵循了**关注点分离**原则：

| 层级 | 职责 | 变化频率 |
|------|------|----------|
| **渠道层** | 处理不同平台的通信协议 | 新平台时变化 |
| **消息总线层** | 统一消息格式，异步解耦 | 很少变化 |
| **核心引擎层** | AI 推理、工具调用、会话管理 | 功能增强时变化 |
| **模型抽象层** | 适配不同 LLM 提供商 | 新模型时变化 |

每一层只关心自己的事，互不干扰。这就是 nanobot 能保持 3400 行代码的秘密之一。

---

## 📁 源码目录结构

让我们看看实际的代码是如何组织的：

```
nanobot/
├── __init__.py          # 包入口，版本号
├── __main__.py          # 入口点：python -m nanobot
│
├── agent/               # 🧠 核心引擎（约 800 行）
│   ├── loop.py          #    AgentLoop - 主循环
│   ├── context.py       #    ContextBuilder - 提示词构建
│   ├── memory.py        #    MemoryStore - 长期记忆
│   ├── skills.py        #    SkillsLoader - 技能加载
│   ├── subagent.py      #    SubagentManager - 子代理
│   └── tools/           #    工具集合
│       ├── base.py      #        Tool 基类
│       ├── registry.py  #        ToolRegistry - 工具注册表
│       ├── filesystem.py#        文件操作工具
│       ├── shell.py     #        命令执行工具
│       ├── web.py       #        网络工具
│       ├── message.py   #        消息发送工具
│       ├── spawn.py     #        子代理生成工具
│       └── cron.py      #        定时任务工具
│
├── bus/                 # 🚌 消息总线（约 80 行）
│   ├── events.py        #    InboundMessage, OutboundMessage
│   └── queue.py         #    MessageBus - 异步队列
│
├── channels/            # 📱 渠道实现（约 600 行）
│   ├── base.py          #    BaseChannel 抽象类
│   ├── manager.py       #    ChannelManager - 渠道管理器
│   ├── telegram.py      #    Telegram 实现
│   ├── discord.py       #    Discord 实现
│   ├── whatsapp.py      #    WhatsApp 实现
│   └── feishu.py        #    飞书实现
│
├── providers/           # 🤖 LLM 提供商（约 200 行）
│   ├── base.py          #    LLMProvider 抽象类
│   ├── litellm_provider.py  # LiteLLM 统一适配
│   └── transcription.py #    语音转文字
│
├── config/              # ⚙️ 配置管理（约 200 行）
│   ├── schema.py        #    Pydantic 配置模型
│   └── loader.py        #    配置加载器
│
├── session/             # 💬 会话管理（约 100 行）
│   └── manager.py       #    SessionManager - 对话历史
│
├── cron/                # ⏰ 定时任务（约 300 行）
│   ├── types.py         #    CronJob, CronSchedule 类型
│   └── service.py       #    CronService - 调度服务
│
├── heartbeat/           # 💓 主动唤醒（约 100 行）
│   └── service.py       #    HeartbeatService
│
├── cli/                 # 🖥️ 命令行接口（约 400 行）
│   └── commands.py      #    Typer 命令定义
│
├── skills/              # 🎯 技能系统（目录）
│   └── ...              #    可扩展技能
│
└── utils/               # 🔧 工具函数
    └── helpers.py       #    通用辅助函数
```

### 代码量统计

| 模块 | 行数 | 占比 | 职责 |
|------|------|------|------|
| agent/ | ~800 | 24% | 核心推理引擎 |
| channels/ | ~600 | 18% | 多渠道通信 |
| cli/ | ~400 | 12% | 命令行界面 |
| cron/ | ~300 | 9% | 定时任务 |
| providers/ | ~200 | 6% | LLM 适配 |
| config/ | ~200 | 6% | 配置管理 |
| 其他 | ~800 | 25% | 工具、会话等 |
| **总计** | **~3400** | 100% | |

---

## 🔄 核心数据流：消息的旅程

让我们跟踪一条消息，看看它如何穿越整个系统。

### 场景：用户在 Telegram 发送 "今天天气怎么样？"

```
                    用户发送消息
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│ 1. TelegramChannel.start()                                   │
│    监听到消息，调用 _handle_message()                          │
│    创建 InboundMessage {                                     │
│      channel: "telegram",                                    │
│      sender_id: "123456789",                                 │
│      chat_id: "123456789",                                   │
│      content: "今天天气怎么样？"                               │
│    }                                                         │
└───────────────────────────┬──────────────────────────────────┘
                            │ await bus.publish_inbound(msg)
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. MessageBus.inbound 队列                                   │
│    消息进入异步队列等待处理                                    │
└───────────────────────────┬──────────────────────────────────┘
                            │ msg = await bus.consume_inbound()
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 3. AgentLoop._process_message()                              │
│    a) 获取/创建会话: sessions.get_or_create("telegram:123")  │
│    b) 构建上下文: context.build_messages(history, message)   │
│    c) 进入推理循环...                                         │
└───────────────────────────┬──────────────────────────────────┘
                            │
          ┌─────────────────┴─────────────────┐
          │         推理循环 (最多 20 次)        │
          │                                    │
          │  ┌────────────────────────────┐   │
          │  │ provider.chat(messages)    │   │
          │  │ → 调用 LLM API             │   │
          │  └─────────────┬──────────────┘   │
          │                │                  │
          │                ▼                  │
          │  ┌────────────────────────────┐   │
          │  │ LLM 返回:                  │   │
          │  │ "我需要搜索天气信息"        │   │
          │  │ tool_calls: [web_search]   │   │
          │  └─────────────┬──────────────┘   │
          │                │                  │
          │                ▼                  │
          │  ┌────────────────────────────┐   │
          │  │ tools.execute("web_search")│   │
          │  │ → 调用 Brave Search API    │   │
          │  │ → 返回搜索结果             │   │
          │  └─────────────┬──────────────┘   │
          │                │                  │
          │                ▼                  │
          │  ┌────────────────────────────┐   │
          │  │ 再次调用 LLM               │   │
          │  │ → 整合搜索结果             │   │
          │  │ → 生成最终回复             │   │
          │  └────────────────────────────┘   │
          │                                    │
          └─────────────────┬─────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. 保存会话历史                                               │
│    session.add_message("user", "今天天气怎么样？")            │
│    session.add_message("assistant", "北京今天晴，25°C...")   │
└───────────────────────────┬──────────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 5. 创建 OutboundMessage 并发布                                │
│    OutboundMessage {                                         │
│      channel: "telegram",                                    │
│      chat_id: "123456789",                                   │
│      content: "北京今天晴，气温 25°C，适合出门..."           │
│    }                                                         │
│    await bus.publish_outbound(response)                      │
└───────────────────────────┬──────────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 6. ChannelManager._dispatch_outbound()                       │
│    从 outbound 队列取出消息                                   │
│    根据 channel 字段路由到 TelegramChannel                    │
│    调用 channel.send(msg)                                    │
└───────────────────────────┬──────────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 7. TelegramChannel.send()                                    │
│    调用 Telegram Bot API 发送消息给用户                       │
└──────────────────────────────────────────────────────────────┘
                            │
                            ▼
                    用户收到回复 ✅
```

### 关键设计点

1. **异步解耦**：MessageBus 使用 `asyncio.Queue`，Channel 和 Agent 完全解耦
2. **迭代循环**：AgentLoop 支持多轮工具调用，最多 20 次迭代
3. **会话持久化**：每次对话都保存到本地，支持上下文记忆
4. **统一路由**：OutboundMessage 通过 `channel` 字段自动路由

---

## 🧩 模块详解

### 1. 消息总线（bus/）

消息总线是整个系统的"神经中枢"，虽然只有 80 行代码，但承担着关键的解耦作用。

```python
# bus/events.py - 消息定义
@dataclass
class InboundMessage:
    """来自用户的消息"""
    channel: str      # 来源渠道：telegram, discord, whatsapp, feishu
    sender_id: str    # 发送者 ID
    chat_id: str      # 会话 ID
    content: str      # 消息内容
    timestamp: datetime
    media: list[str]  # 媒体附件（图片路径等）

    @property
    def session_key(self) -> str:
        """会话唯一标识"""
        return f"{self.channel}:{self.chat_id}"

@dataclass
class OutboundMessage:
    """发送给用户的消息"""
    channel: str      # 目标渠道
    chat_id: str      # 目标会话
    content: str      # 消息内容
    reply_to: str | None  # 回复的消息 ID
    media: list[str]  # 媒体附件
```

```python
# bus/queue.py - 消息队列
class MessageBus:
    def __init__(self):
        self.inbound: asyncio.Queue[InboundMessage] = asyncio.Queue()
        self.outbound: asyncio.Queue[OutboundMessage] = asyncio.Queue()

    async def publish_inbound(self, msg: InboundMessage) -> None:
        """渠道调用：发布用户消息"""
        await self.inbound.put(msg)

    async def consume_inbound(self) -> InboundMessage:
        """Agent 调用：获取待处理消息"""
        return await self.inbound.get()

    async def publish_outbound(self, msg: OutboundMessage) -> None:
        """Agent 调用：发布回复消息"""
        await self.outbound.put(msg)
```

**设计亮点**：
- 使用标准库 `asyncio.Queue`，无需外部依赖
- 双队列设计（inbound/outbound）清晰分离请求和响应
- `session_key` 属性自动生成会话标识

### 2. 渠道层（channels/）

每个渠道都继承自 `BaseChannel`，实现统一的接口。

```python
# channels/base.py - 渠道基类
class BaseChannel(ABC):
    name: str = "base"

    def __init__(self, config: Any, bus: MessageBus):
        self.config = config
        self.bus = bus
        self._running = False

    @abstractmethod
    async def start(self) -> None:
        """启动渠道，开始监听消息"""
        pass

    @abstractmethod
    async def stop(self) -> None:
        """停止渠道"""
        pass

    @abstractmethod
    async def send(self, msg: OutboundMessage) -> None:
        """发送消息到渠道"""
        pass

    def is_allowed(self, sender_id: str) -> bool:
        """检查发送者是否在白名单中"""
        allow_list = getattr(self.config, "allow_from", [])
        if not allow_list:
            return True  # 无白名单则允许所有人
        return str(sender_id) in allow_list

    async def _handle_message(self, sender_id, chat_id, content, media=None):
        """统一的消息处理入口"""
        if not self.is_allowed(sender_id):
            logger.warning(f"Access denied for {sender_id}")
            return

        msg = InboundMessage(
            channel=self.name,
            sender_id=str(sender_id),
            chat_id=str(chat_id),
            content=content,
            media=media or []
        )
        await self.bus.publish_inbound(msg)
```

**设计亮点**：
- 抽象基类定义清晰的接口契约
- 白名单逻辑在基类中统一实现
- `_handle_message` 方法简化子类实现

### 3. 核心引擎（agent/）

这是 nanobot 的"大脑"，负责与 LLM 交互并执行工具调用。

```python
# agent/loop.py - 核心循环（简化版）
class AgentLoop:
    def __init__(self, bus, provider, workspace, ...):
        self.bus = bus
        self.provider = provider
        self.workspace = workspace

        self.context = ContextBuilder(workspace)
        self.sessions = SessionManager(workspace)
        self.tools = ToolRegistry()

        self._register_default_tools()

    async def _process_message(self, msg: InboundMessage) -> OutboundMessage:
        # 1. 获取会话
        session = self.sessions.get_or_create(msg.session_key)

        # 2. 构建消息列表
        messages = self.context.build_messages(
            history=session.get_history(),
            current_message=msg.content
        )

        # 3. 推理循环
        iteration = 0
        while iteration < self.max_iterations:
            iteration += 1

            # 调用 LLM
            response = await self.provider.chat(
                messages=messages,
                tools=self.tools.get_definitions()
            )

            # 处理工具调用
            if response.has_tool_calls:
                for tool_call in response.tool_calls:
                    result = await self.tools.execute(
                        tool_call.name,
                        tool_call.arguments
                    )
                    messages = self.context.add_tool_result(
                        messages, tool_call.id, tool_call.name, result
                    )
            else:
                # 无工具调用，结束循环
                break

        # 4. 保存会话
        session.add_message("user", msg.content)
        session.add_message("assistant", response.content)

        return OutboundMessage(
            channel=msg.channel,
            chat_id=msg.chat_id,
            content=response.content
        )
```

**设计亮点**：
- 迭代循环支持多轮工具调用（最多 20 次）
- 工具调用结果自动追加到消息历史
- 会话管理与推理逻辑分离

### 4. 模型抽象层（providers/）

通过 LiteLLM 实现"一个接口，支持所有模型"。

```python
# providers/base.py - 提供商基类
class LLMProvider(ABC):
    @abstractmethod
    async def chat(
        self,
        messages: list[dict],
        tools: list[dict] | None = None,
        model: str | None = None,
    ) -> LLMResponse:
        """发送聊天请求"""
        pass

    @abstractmethod
    def get_default_model(self) -> str:
        """获取默认模型"""
        pass

@dataclass
class LLMResponse:
    content: str | None
    tool_calls: list[ToolCallRequest]
    finish_reason: str = "stop"

    @property
    def has_tool_calls(self) -> bool:
        return len(self.tool_calls) > 0
```

```python
# providers/litellm_provider.py - 统一适配器（简化版）
class LiteLLMProvider(LLMProvider):
    async def chat(self, messages, tools=None, model=None):
        response = await litellm.acompletion(
            model=model or self.default_model,
            messages=messages,
            tools=tools,
            api_key=self.api_key,
            api_base=self.api_base,
        )

        # 解析工具调用
        tool_calls = []
        if response.choices[0].message.tool_calls:
            for tc in response.choices[0].message.tool_calls:
                tool_calls.append(ToolCallRequest(
                    id=tc.id,
                    name=tc.function.name,
                    arguments=json.loads(tc.function.arguments)
                ))

        return LLMResponse(
            content=response.choices[0].message.content,
            tool_calls=tool_calls
        )
```

**设计亮点**：
- LiteLLM 自动适配 20+ 种 LLM 提供商
- 统一的 `LLMResponse` 数据结构
- 工具调用自动解析

---

## 🎨 设计原则

nanobot 的架构体现了几个重要的设计原则：

### 1. 单一职责原则（SRP）

每个模块只做一件事：

| 模块 | 唯一职责 |
|------|----------|
| MessageBus | 消息队列 |
| BaseChannel | 平台通信 |
| AgentLoop | AI 推理 |
| ToolRegistry | 工具管理 |
| SessionManager | 对话历史 |

### 2. 依赖倒置原则（DIP）

高层模块不依赖低层模块，都依赖抽象：

```
AgentLoop ──depends on──▶ LLMProvider (抽象)
                                │
                    ┌───────────┼───────────┐
                    ▼           ▼           ▼
            LiteLLMProvider  OpenAI...  Anthropic...
```

### 3. 开闭原则（OCP）

对扩展开放，对修改关闭：

- 添加新渠道：继承 `BaseChannel`，无需修改现有代码
- 添加新工具：继承 `Tool`，注册到 `ToolRegistry`
- 添加新模型：配置文件中添加 API Key 即可

### 4. 组合优于继承

nanobot 偏好组合：

```python
class AgentLoop:
    def __init__(self, bus, provider, workspace, ...):
        self.bus = bus                    # 组合 MessageBus
        self.provider = provider          # 组合 LLMProvider
        self.context = ContextBuilder()   # 组合 ContextBuilder
        self.sessions = SessionManager()  # 组合 SessionManager
        self.tools = ToolRegistry()       # 组合 ToolRegistry
```

---

## 🔗 模块协作图

最后，让我们看看所有模块是如何协作的：

```
┌─────────────────────────────────────────────────────────────────────┐
│                           CLI (commands.py)                         │
│                    nanobot gateway / nanobot agent                  │
└───────────────────────────────┬─────────────────────────────────────┘
                                │ 初始化并启动
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         Config (schema.py)                          │
│                    加载 ~/.nanobot/config.json                      │
└───────────────────────────────┬─────────────────────────────────────┘
                                │ 配置各组件
        ┌───────────────────────┼───────────────────────┐
        ▼                       ▼                       ▼
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│  MessageBus   │      │  AgentLoop    │      │ChannelManager │
│   (queue.py)  │◀────▶│  (loop.py)    │◀────▶│ (manager.py)  │
└───────────────┘      └───────┬───────┘      └───────┬───────┘
                                │                      │
        ┌──────────────────────┼──────────────────────┼──────────┐
        ▼                      ▼                      ▼          ▼
┌───────────────┐      ┌───────────────┐      ┌─────────┐ ┌─────────┐
│ContextBuilder │      │ ToolRegistry  │      │Telegram │ │ Discord │
│ (context.py)  │      │ (registry.py) │      │Channel  │ │ Channel │
└───────────────┘      └───────────────┘      └─────────┘ └─────────┘
        │                      │
        ▼                      ▼
┌───────────────┐      ┌───────────────┐
│  MemoryStore  │      │  各种 Tools   │
│  SkillsLoader │      │ file/shell/..│
611: └───────────────┘      └───────────────┘
                                │
                                ▼
                      ┌───────────────┐
                      │ LLMProvider   │
                      │ (LiteLLM)     │
                      └───────────────┘
```

---

## 📝 小结

在这篇文章中，我们：

- ✅ 理解了 nanobot 的**四层架构**：渠道层 → 消息总线层 → 核心引擎层 → 模型抽象层
- ✅ 跟踪了一条消息的**完整旅程**：从用户发送到收到回复
- ✅ 认识了各个模块的**职责边界**：bus、channels、agent、providers
- ✅ 理解了**设计原则**：SRP、DIP、OCP、组合优于继承

这种清晰的分层设计，让 nanobot 在保持极简的同时，也具备了良好的可扩展性。

---

> **下一篇预告**：[《Agent 核心引擎解析：loop.py 和 context.py 深度解读》](./2026-02-02-nanobot-05-agent-core.md)
>
> 我们将深入 agent 模块，解析 AgentLoop 的推理循环是如何工作的、ContextBuilder 如何构建系统提示词、以及工具调用的完整流程。这是理解 nanobot "智能"的关键。

---

*本文是 nanobot 深度解析系列的第 4 篇，共 11 篇。*

