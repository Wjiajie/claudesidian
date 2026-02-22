---
parent: "[[nanobot-docs]]"
slug: nanobot-08-channel-adapters
title: Channel 适配器实现：让 AI 连接世界
authors: [jiajiewu]
tags: [软件架构, Nanobot, Channels]
date: 2026-02-05
description: 深入讲解 Nanobot Channel 层的设计模式，通过 Telgram、Discord、WhatsApp 和飞书四个实战案例，演示如何将不同平台的 API 适配为统一的消息格式。
draft: false
---

# Channel 适配器实现：让 AI 连接世界

> **系列导读**：在上一篇《消息总线与事件系统》中，我们构建了 nanobot 的通信骨干。现在，我们要把这个骨干连接到真实世界——Telegram、Discord、WhatsApp 和飞书。这就是 **Channel Adapter（渠道适配器）** 的工作。


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

1. 理解适配器模式在 nanobot 中的应用
2. 掌握 `BaseChannel` 抽象基类的设计
3. 学习如何实现 WebSocket 长连接（Discord/飞书）和 Long Polling（Telegram）
4. 了解如何处理消息去重和跨线程上下文

---

## 🔌 适配器模式：像插头转换器一样工作

每个聊天平台的 API 都不同：
- **Telegram**：基于 HTTP Long Polling 或 Webhook，消息格式是 JSON
- **Discord**：基于 WebSocket Gateway，需要处理心跳（Heartbeat）
- **WhatsApp**：基于 Baileys 协议，通过 Node.js Bridge 转发
- **飞书**：基于 HTTP 回调或 WebSocket 长连接，消息结构极其复杂

Channel Adapter 的作用就是把这些千奇百怪的接口，统统转换成 nanobot 的标准接口：
- **输入**：`External Event` -> `InboundMessage`
- **输出**：`OutboundMessage` -> `Platform API Call`

---

## 🏗️ BaseChannel：所有渠道的基石

我们定义了一个抽象基类 `BaseChannel`，规范了所有 Channel 的行为。

```python
# channels/base.py
class BaseChannel(ABC):
    """Abstract base class for all channels."""

    def __init__(self, bus: MessageBus, config: dict):
        self.bus = bus
        self.config = config
        self.channel_name = config.get("name", "unknown")
        self.enabled = config.get("enabled", False)
        # 允许的用户/群组 ID 列表
        self.allow_from = config.get("allowFrom", [])

    @abstractmethod
    async def start(self) -> None:
        """Start the channel (connect, poll, etc.)."""
        pass

    @abstractmethod
    async def stop(self) -> None:
        """Stop the channel."""
        pass

    async def _handle_inbound(self, msg: InboundMessage) -> None:
        """Helper to publish inbound messages to the bus."""
        # 1. 权限检查
        if self.allow_from and msg.sender_id not in self.allow_from:
            logger.warning(f"Blocked message from unauthorized user: {msg.sender_id}")
            return

        # 2. 发布到总线
        await self.bus.publish_inbound(msg)

    async def _consume_outbound(self) -> None:
        """Loop to consume outbound messages from the bus."""
        queue = self.bus.subscribe()
        while True:
            msg = await queue.get()
            if msg.channel == self.channel_name:
                try:
                    await self.send_message(msg)
                except Exception as e:
                    logger.error(f"Error sending message to {self.channel_name}: {e}")

    @abstractmethod
    async def send_message(self, msg: OutboundMessage) -> None:
        """Send a message to the external platform."""
        pass
```

**设计亮点**：
- **统一权限控制**：基类处理 `allow_from` 检查，子类无需关心
- **统一出站消费**：基类实现了 `_consume_outbound` 循环，子类只需实现 `send_message`
- **生命周期管理**：强制子类实现 `start` 和 `stop`

---

## 📱 Case 1: Telegram Channel (Long Polling)

Telegram 的实现相对简单，使用 `python-telegram-bot` 库。

```python
# channels/telegram.py
class TelegramChannel(BaseChannel):
    def __init__(self, bus, config):
        super().__init__(bus, config)
        self.token = config["token"]
        self.app = ApplicationBuilder().token(self.token).build()

    async def start(self):
        # 注册消息处理器
        self.app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, self._on_message))
        
        # 启动 Polling（非阻塞）
        await self.app.initialize()
        await self.app.start()
        asyncio.create_task(self.app.updater.start_polling())
        
        # 启动出站消费者
        asyncio.create_task(self._consume_outbound())

    async def _on_message(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Handle incoming Telegram messages."""
        if not update.message or not update.message.text:
            return

        # 转换为 InboundMessage
        msg = InboundMessage(
            channel="telegram",
            sender_id=str(update.effective_user.id),
            chat_id=str(update.effective_chat.id),
            content=update.message.text,
            metadata={"username": update.effective_user.username}
        )
        await self._handle_inbound(msg)

    async def send_message(self, msg: OutboundMessage):
        """Send message back to Telegram."""
        await self.app.bot.send_message(
            chat_id=msg.chat_id,
            text=msg.content,
            parse_mode="Markdown"  # 支持 Markdown 格式
        )
```

长期轮询（Long Polling）的好处是不需要公网 IP，适合本地部署。

---

## 🎮 Case 2: Discord Channel (WebSocket)

Discord 必须通过 WebSocket 保持连接。这里的实现稍微复杂一点。

```python
# channels/discord.py
class DiscordChannel(BaseChannel):
    async def start(self):
        self.ws = await websockets.connect(self.gateway_url)
        
        # 启动心跳任务
        asyncio.create_task(self._heartbeat())
        
        # 启动接收循环
        asyncio.create_task(self._receive_loop())
        
        # 启动出站消费者
        asyncio.create_task(self._consume_outbound())
        
        # 发送 Identify 包（登录）
        await self._identify()

    async def _receive_loop(self):
        async for raw_msg in self.ws:
            event = json.loads(raw_msg)
            
            # 处理消息创建事件
            if event["t"] == "MESSAGE_CREATE":
                data = event["d"]
                if data["author"]["bot"]:  # 忽略机器人消息
                    continue

                msg = InboundMessage(
                    channel="discord",
                    sender_id=data["author"]["id"],
                    chat_id=data["channel_id"],
                    content=data["content"]
                )
                await self._handle_inbound(msg)
```

Discord 的难点在于维护 WebSocket 连接状态（重连、Resume），nanobot 处理了这些底层细节。

---

## 💬 Case 3: WhatsApp (Bridge模式)

WhatsApp 没有官方 Bot API（或非常昂贵），我们使用开源的 Baileys 库作为 Bridge。即 nanobot 通过 WebSocket 连接到一个运行 Baileys 的 Node.js 服务。

```python
# channels/whatsapp.py
class WhatsAppChannel(BaseChannel):
    async def start(self):
        self.ws = await websockets.connect(self.bridge_url)
        asyncio.create_task(self._receive_bridge_events())

    async def _receive_bridge_events(self):
        async for message in self.ws:
            event = json.loads(message)
            if event["type"] == "message":
                # 从 Bridge 收到消息
                msg = InboundMessage(
                    channel="whatsapp",
                    sender_id=event["from"],
                    chat_id=event["chatId"],
                    content=event["text"]
                )
                await self._handle_inbound(msg)
```

这种"套娃"设计（Python -> WebSocket -> Node.js -> WhatsApp）展示了适配器模式的威力：无论底层多复杂，Agent 看到的永远是统一的接口。

---

## 🏢 Case 4: 飞书 (企业级复杂性)

飞书（Lark）的 API 设计非常完善，但也最为复杂。它支持 webhook 和 WebSocket 两种模式。为了方便本地开发，nanobot 选用了飞书的 WebSocket 长连接模式（无需公网回调地址）。

```python
# channels/feishu.py
class FeishuChannel(BaseChannel):
    def __init__(self, bus: MessageBus, config: dict):
        super().__init__(bus, config)
        self.app_id = config.get("appId")
        self.app_secret = config.get("appSecret")
        # 使用 lark-oapi SDK
        self.client = lark.Client.builder() \
            .app_id(self.app_id) \
            .app_secret(self.app_secret) \
            .build()

    async def start(self):
        # 初始化 WebSocket 客户端
        self.ws_client = lark.ws.Client(
            self.app_id, 
            self.app_secret,
            event_handler=self._handle_event,
            log_level=lark.LogLevel.INFO
        )
        await self.ws_client.start()
        asyncio.create_task(self._consume_outbound())

    def _handle_event(self, event_data):
        """Callback for Feishu SDK events."""
        # 飞书 SDK 是同步回调，需要转为异步
        asyncio.run_coroutine_threadsafe(
            self._process_feishu_event(event_data), 
            self._loop
        )

    async def send_message(self, msg: OutboundMessage):
        # 飞书发送消息 API
        body = {
            "msg_type": "text",
            "content": json.dumps({"text": msg.content})
        }
        resp = await self.client.im.message.create(
            params={"receive_id_type": "chat_id"},
            body={
                "receive_id": msg.chat_id,
                **body
            }
        )
```

飞书的挑战在于其 SDK 设计主要面向同步 Web 服务，将其适配到异步 Agent 架构中需要一些技巧（如 `run_coroutine_threadsafe`）。

---

## ⚖️ 设计模式总结

通过这四个案例，我们可以看到 Adapter 模式的核心思想：

1.  **屏蔽差异**：上层逻辑（Agent）不需要知道下层（Telegram/Discord）的任何细节。
2.  **依赖倒置**：Channel 依赖于 Agent 定义的接口（InboundMessage），而不是 Agent 依赖 Channel 的 API。
3.  **单一职责**：每个 Channel 类只负责对应平台的协议转换，不包含任何业务逻辑。

---

## 📝 小结

Channel 适配器是 nanobot 的感官，让它能够"听"和"说"。

- ✅ **BaseChannel**：提供了统一的生命周期和消息处理骨架
- ✅ **多协议支持**：成功适配了 HTTP Polling, WebSocket Gateway, Bridge Proxy 等多种模式
- ✅ **企业级接入**：通过 SDK 集成了飞书等复杂平台

至此，我们的 nanobot 已经拥有了大脑（Agent）、双手（Tools）、神经（Bus）和感官（Channels）。

下一篇，我们将探讨如何让它拥有**记忆**——会话管理与记忆系统。

---

> **下一篇预告**：[《会话管理与记忆系统：让 AI 记住你是谁》](./2026-02-06-nanobot-09-session-memory.md)
>
> 我们将深入 `session/` 和 `memory/` 模块，解析 nanobot 如何实现短时对话记忆和长时知识存储。

---

*本文是 nanobot 深度解析系列的第 8 篇，共 11 篇。*

