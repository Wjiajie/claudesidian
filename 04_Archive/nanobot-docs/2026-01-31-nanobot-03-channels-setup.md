---
parent: "[[nanobot-docs]]"
slug: nanobot-03-channels-setup
title: 多渠道接入配置详解：连接 Telegram, Discord, WhatsApp 与飞书
authors: [jiajiewu]
tags: [软件架构, Nanobot]
date: 2026-01-31
description: 详细介绍如何将 Nanobot 接入主流聊天平台。包括 Telegram Bot 创建、Discord 开发者应用配置、WhatsApp 桥接设置以及飞书机器人权限配置。
draft: false
---

# 多渠道接入配置详解：让 nanobot 无处不在

> **系列导读**：在上一篇文章中，我们完成了 nanobot 的基础安装和配置，实现了命令行对话。但真正的 AI 助手应该能在你常用的聊天工具中随时待命——Telegram、Discord、WhatsApp、飞书……本文将手把手教你配置每个渠道，让 nanobot 真正"无处不在"。


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

1. 理解 nanobot 的多渠道架构设计
2. 配置 Telegram Bot 并开始对话
3. 配置 Discord Bot 实现服务器集成
4. 配置 WhatsApp 连接（通过 Bridge）
5. 配置飞书机器人（企业级方案）
6. 掌握权限控制和安全配置

## 📐 架构概览：渠道是如何工作的？

在深入配置之前，让我们先理解 nanobot 的渠道架构。

### 费曼式解释：渠道就像"翻译官"

想象你是一位多语言客服中心的经理：

- **用户**从不同国家打来电话（Telegram、Discord、WhatsApp...）
- **翻译官**（Channel）接听电话，把用户的话翻译成统一的"内部语言"
- **客服代表**（Agent）用内部语言处理问题
- **翻译官**再把回复翻译回用户的语言

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Telegram   │────▶│             │────▶│             │
├─────────────┤     │   Message   │     │    Agent    │
│   Discord   │────▶│     Bus     │────▶│    Loop     │
├─────────────┤     │             │     │             │
│  WhatsApp   │────▶│  (统一格式)  │────▶│  (AI 处理)  │
├─────────────┤     │             │     │             │
│    飞书     │────▶│             │────▶│             │
└─────────────┘     └─────────────┘     └─────────────┘
      ▲                                        │
      └────────────────────────────────────────┘
                    (回复消息)
```

这种设计的好处是：
- **解耦**：添加新渠道不需要修改 Agent 代码
- **统一**：所有渠道共享相同的 AI 能力
- **灵活**：每个渠道可以有自己的配置和权限

### 启动网关

配置好渠道后，需要启动网关来运行所有渠道：

```bash
nanobot gateway
```

这个命令会：
1. 加载配置文件中所有 `enabled: true` 的渠道
2. 连接到各个聊天平台
3. 开始监听和响应消息

---

## 📱 Telegram 配置

Telegram 是最推荐的渠道——配置简单、功能完整、无需公网 IP。

### 第一步：创建 Bot

1. 在 Telegram 中搜索 `@BotFather`（官方机器人管理员）
2. 发送 `/newbot` 命令
3. 按提示输入：
   - Bot 名称（显示名）：如 `My Nanobot`
   - Bot 用户名（唯一标识）：如 `my_nanobot_bot`（必须以 `_bot` 结尾）
4. 获得 Bot Token（格式如 `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`）

> **安全提示**：Bot Token 相当于密码，不要泄露给他人！

### 第二步：获取你的 User ID

为了设置白名单，你需要知道自己的 Telegram User ID：

1. 在 Telegram 中搜索 `@userinfobot`
2. 发送任意消息
3. 它会回复你的 User ID（纯数字，如 `123456789`）

### 第三步：配置 nanobot

编辑 `~/.nanobot/config.json`：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "123456789:ABCdefGHIjklMNOpqrsTUVwxyz",
      "allowFrom": ["123456789"]
    }
  }
}
```

| 配置项 | 说明 | 示例 |
|--------|------|------|
| `enabled` | 是否启用此渠道 | `true` |
| `token` | BotFather 给的 Token | `"123456789:ABC..."` |
| `allowFrom` | 允许使用的用户 ID 列表 | `["123456789", "987654321"]` |
| `proxy` | 代理地址（可选） | `"http://127.0.0.1:7890"` |

### 第四步：启动并测试

```bash
nanobot gateway
```

你应该看到类似输出：

```
INFO     Starting Telegram bot (polling mode)...
INFO     Telegram bot @my_nanobot_bot connected
```

现在去 Telegram 中找到你的 Bot，发送 `/start`，然后开始对话！

### 高级配置

#### 使用代理

如果你的网络无法直接访问 Telegram，可以配置代理：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowFrom": ["YOUR_USER_ID"],
      "proxy": "http://127.0.0.1:7890"
    }
  }
}
```

支持的代理类型：
- HTTP 代理：`http://host:port`
- SOCKS5 代理：`socks5://host:port`

#### 允许多个用户

```json
{
  "allowFrom": ["123456789", "987654321", "alice_username"]
}
```

你可以混合使用 User ID 和用户名。

### Telegram 特色功能

nanobot 的 Telegram 渠道支持：

| 功能 | 说明 |
|------|------|
| **文本消息** | 基本对话 |
| **图片** | 发送图片，AI 可以"看到"并分析 |
| **语音消息** | 自动转文字（需配置 Groq API） |
| **文件** | 上传文件供 AI 处理 |
| **Markdown 渲染** | 回复自动转换为 Telegram 格式 |

#### 启用语音转文字

语音转文字需要 Groq API（免费且快速）：

```json
{
  "providers": {
    "groq": {
      "apiKey": "gsk_xxx"
    }
  }
}
```

获取 Groq API Key：[console.groq.com](https://console.groq.com)

---

## 🎮 Discord 配置

Discord 渠道适合社区场景，可以在服务器中运行 AI 助手。

### 第一步：创建 Discord Application

1. 访问 [Discord Developer Portal](https://discord.com/developers/applications)
2. 点击 "New Application"
3. 输入应用名称（如 `Nanobot`）
4. 进入 "Bot" 页面
5. 点击 "Add Bot"
6. 在 "TOKEN" 区域点击 "Reset Token" 获取 Bot Token

### 第二步：配置 Bot 权限

在 Bot 页面，启用以下 "Privileged Gateway Intents"：

- ✅ **MESSAGE CONTENT INTENT**（读取消息内容，必须！）
- ✅ **SERVER MEMBERS INTENT**（可选，用于获取成员信息）

### 第三步：邀请 Bot 到服务器

1. 进入 "OAuth2" → "URL Generator"
2. 在 "SCOPES" 中勾选 `bot`
3. 在 "BOT PERMISSIONS" 中勾选：
   - Send Messages
   - Read Message History
   - Add Reactions
4. 复制生成的 URL，在浏览器中打开
5. 选择你的服务器，授权

### 第四步：获取你的 User ID

1. 在 Discord 设置中启用 "开发者模式"（用户设置 → 高级）
2. 右键点击你的用户名
3. 选择 "复制 ID"

### 第五步：配置 nanobot

```json
{
  "channels": {
    "discord": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowFrom": ["YOUR_USER_ID"]
    }
  }
}
```

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| `enabled` | 是否启用 | `false` |
| `token` | Bot Token | - |
| `allowFrom` | 允许的用户 ID 列表 | `[]`（允许所有人） |
| `gatewayUrl` | Gateway 地址 | `wss://gateway.discord.gg/...` |
| `intents` | 权限位掩码 | `37377` |

### 第六步：启动并测试

```bash
nanobot gateway
```

输出：

```
INFO     Connecting to Discord gateway...
INFO     Discord gateway READY
```

在 Discord 服务器中 @你的 Bot 或私信它即可对话。

### Discord 技术细节

nanobot 使用 **WebSocket Gateway** 直连 Discord，而非 HTTP Webhook：

- **优点**：实时响应、无需公网 IP、自动重连
- **Intents**：默认值 `37377` 包含：
  - `GUILDS` (1) - 服务器信息
  - `GUILD_MESSAGES` (512) - 服务器消息
  - `DIRECT_MESSAGES` (4096) - 私信
  - `MESSAGE_CONTENT` (32768) - 消息内容

如果需要自定义权限，可以修改 `intents` 值。

---

## 💬 WhatsApp 配置

WhatsApp 渠道需要一个 Node.js Bridge 作为中间层，因为 WhatsApp 没有官方 Bot API。

### 架构说明

```
WhatsApp <--> Node.js Bridge <--> nanobot
              (Baileys)        (WebSocket)
```

- **Baileys**：一个开源的 WhatsApp Web 协议实现
- **Bridge**：将 WhatsApp 消息转换为 WebSocket 协议

### 第一步：设置 Bridge

在 `bridges/whatsapp/` 目录下有一个预置的 Bridge：

```bash
cd bridges/whatsapp
npm install
npm start
```

首次运行时，你需要扫描 QR 码来登录 WhatsApp。

### 第二步：配置 nanobot

```json
{
  "channels": {
    "whatsapp": {
      "enabled": true,
      "bridgeUrl": "ws://localhost:3001",
      "allowFrom": ["8613812345678"]
    }
  }
}
```

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| `enabled` | 是否启用 | `false` |
| `bridgeUrl` | Bridge WebSocket 地址 | `ws://localhost:3001` |
| `allowFrom` | 允许的手机号列表 | `[]` |

### 第三步：启动

先启动 Bridge，再启动 nanobot：

```bash
# 终端 1：启动 Bridge
cd bridges/whatsapp && npm start

# 终端 2：启动 nanobot
nanobot gateway
```

### 注意事项

- **手机必须联网**：WhatsApp Web 需要手机在线
- **Session 持久化**：Bridge 会保存登录状态在 `auth_info/` 目录
- **限制**：WhatsApp 官方不鼓励自动化，使用需谨慎

---

## 🐦 飞书配置

飞书（Lark）是企业级场景的首选，支持 WebSocket 长连接，无需公网 IP。

### 第一步：创建飞书应用

1. 访问 [飞书开放平台](https://open.feishu.cn/app)
2. 点击 "创建企业自建应用"
3. 填写应用信息：
   - 应用名称：如 `Nanobot`
   - 应用描述：AI 助手
4. 获取 App ID 和 App Secret（在 "凭证与基础信息" 中）

### 第二步：配置机器人能力

1. 进入 "添加应用能力" → 添加 "机器人"
2. 在 "事件与回调" 中：
   - 添加事件：`im.message.receive_v1`（接收消息）
   - 订阅方式：选择 **长连接**（WebSocket）

### 第三步：配置权限

在 "权限管理" 中添加：

| 权限 | 用途 |
|------|------|
| `im:message` | 获取与发送单聊消息 |
| `im:message:send_as_bot` | 以应用身份发送消息 |
| `im:chat` | 获取群组信息 |
| `im:message.reactions:write` | 添加消息表情（用于"已读"反馈） |

### 第四步：发布应用

1. 在 "版本管理与发布" 中创建版本
2. 申请上线（企业内部应用通常自动通过）

### 第五步：获取用户 Open ID

要设置白名单，需要获取用户的 Open ID：

1. 让目标用户给机器人发送一条消息
2. 查看 nanobot 日志，会显示 `sender_id=ou_xxx`
3. 这个 `ou_xxx` 就是用户的 Open ID

### 第六步：配置 nanobot

```json
{
  "channels": {
    "feishu": {
      "enabled": true,
      "appId": "cli_xxx",
      "appSecret": "xxx",
      "encryptKey": "",
      "verificationToken": "",
      "allowFrom": ["ou_xxx"]
    }
  }
}
```

| 配置项 | 说明 | 必填 |
|--------|------|------|
| `enabled` | 是否启用 | 是 |
| `appId` | 应用 ID | 是 |
| `appSecret` | 应用密钥 | 是 |
| `encryptKey` | 加密密钥 | 否（长连接模式不需要） |
| `verificationToken` | 验证令牌 | 否（长连接模式不需要） |
| `allowFrom` | 允许的 Open ID 列表 | 否 |

### 第七步：启动并测试

```bash
nanobot gateway
```

输出：

```
INFO     Feishu bot started with WebSocket long connection
INFO     No public IP required - using WebSocket to receive events
```

在飞书中搜索你的机器人，开始对话！

### 飞书特色功能

| 功能 | 说明 |
|------|------|
| **长连接** | 无需公网 IP，穿透企业防火墙 |
| **消息反应** | 自动添加 👍 表示"已收到" |
| **群聊支持** | 支持私聊和群聊场景 |
| **富文本** | 支持文本、图片等消息类型 |

---

## 🔒 安全配置最佳实践

### 1. 始终使用白名单

不配置 `allowFrom` 意味着任何人都可以使用你的 Bot，这会：
- 消耗你的 API 配额
- 可能被滥用

**推荐做法**：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "...",
      "allowFrom": ["your_user_id", "trusted_friend_id"]
    }
  }
}
```

### 2. 保护敏感配置

不要将 `config.json` 提交到版本控制：

```bash
echo "config.json" >> .gitignore
```

或使用环境变量：

```bash
export NANOBOT_CHANNELS__TELEGRAM__TOKEN="your_token"
```

### 3. 限制工具权限

如果你担心 AI 误操作系统文件：

```json
{
  "tools": {
    "restrictToWorkspace": true
  }
}
```

### 4. 监控使用日志

定期检查 nanobot 日志，关注：
- 被拒绝的访问尝试（`Access denied for sender ...`）
- 异常的消息模式

---

## 🔧 常见问题

### Q: Telegram Bot 无响应

**检查清单**：
1. Token 是否正确？
2. Bot 是否被 `/start` 激活？
3. 你的 User ID 是否在 `allowFrom` 列表中？
4. 网络是否能访问 Telegram？（尝试配置代理）

### Q: Discord Bot 显示离线

**检查清单**：
1. Token 是否正确且未过期？
2. 是否启用了 MESSAGE CONTENT INTENT？
3. Bot 是否已被邀请到服务器？

### Q: 飞书事件收不到

**检查清单**：
1. 是否选择了"长连接"订阅方式？
2. `im.message.receive_v1` 事件是否已添加？
3. 应用是否已发布上线？
4. 用户是否有权限使用该应用？

### Q: WhatsApp Bridge 断开

**可能原因**：
- 手机 WhatsApp 离线
- Session 过期，需要重新扫码
- 网络不稳定

**解决方案**：
1. 确保手机 WhatsApp 在线
2. 删除 `auth_info/` 目录，重新扫码

### Q: 如何同时启用多个渠道？

只需在配置中启用多个渠道：

```json
{
  "channels": {
    "telegram": { "enabled": true, "token": "...", "allowFrom": [...] },
    "discord": { "enabled": true, "token": "...", "allowFrom": [...] },
    "feishu": { "enabled": true, "appId": "...", "appSecret": "...", "allowFrom": [...] }
  }
}
```

`nanobot gateway` 会同时启动所有启用的渠道。

---

## 📊 渠道对比

| 特性 | Telegram | Discord | WhatsApp | 飞书 |
|------|----------|---------|----------|------|
| 配置难度 | ⭐ 简单 | ⭐⭐ 中等 | ⭐⭐⭐ 复杂 | ⭐⭐ 中等 |
| 需要公网 IP | 否 | 否 | 否 | 否 |
| 官方 API | ✅ | ✅ | ❌ | ✅ |
| 语音转文字 | ✅ | ❌ | ⚠️ 有限 | ❌ |
| 图片理解 | ✅ | ✅ | ⚠️ 有限 | ⚠️ 有限 |
| 企业场景 | ⚠️ | ⚠️ | ⚠️ | ✅ |
| 个人场景 | ✅ | ✅ | ✅ | ⚠️ |

**推荐选择**：
- **个人用户**：Telegram（最简单、功能最全）
- **社区/游戏**：Discord（原生支持服务器）
- **企业办公**：飞书（合规、长连接稳定）
- **特殊需求**：WhatsApp（需要自行维护 Bridge）

---

## 📝 小结

在这篇文章中，我们完成了：

- ✅ 理解 nanobot 的多渠道架构设计
- ✅ 配置 Telegram Bot（获取 Token、设置白名单）
- ✅ 配置 Discord Bot（创建应用、设置权限、邀请到服务器）
- ✅ 配置 WhatsApp（通过 Bridge 连接）
- ✅ 配置飞书机器人（长连接模式、企业应用）
- ✅ 掌握安全配置最佳实践

现在你的 AI 助手已经可以在多个平台上待命了！但你可能会好奇：这些渠道是如何工作的？消息是怎样流转的？Agent 是如何处理请求的？

---

> **下一篇预告**：[《架构总览与模块划分：nanobot 的内功心法》](./2026-02-01-nanobot-04-architecture.md)
>
> 我们将从宏观视角审视 nanobot 的整体架构，理解各个模块的职责和它们之间的协作关系。这是深入理解代码的基础——先见森林，再见树木。

---

*本文是 nanobot 深度解析系列的第 3 篇，共 11 篇。*

