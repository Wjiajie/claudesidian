---
parent: "[[nanobot-docs]]"
slug: nanobot-02-installation
title: 安装配置完全指南：五分钟搭建你的 AI 助手
authors: [jiajiewu]
tags: [软件架构, Nanobot]
date: 2026-01-30
description: 从零开始搭建 Nanobot 的完整指南。涵盖环境准备、安装步骤 (PyPI/Source)、配置文件详解以及如何获取必要的 API Key (OpenRouter, Brave Search)。
draft: false
---

# 安装配置完全指南：从零开始的 nanobot 之旅

> **系列导读**：在上一篇文章中，我们认识了 nanobot——一个仅用 3400 行代码实现的超轻量级 AI 助手。现在，让我们卷起袖子，一步步把它跑起来！本文将从环境准备到第一次成功对话，手把手带你完成整个配置过程。

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

1. 成功安装 nanobot
2. 理解配置文件的结构和每个选项的含义
3. 获取并配置必需的 API Key
4. 完成第一次与 AI 助手的对话
5. （可选）配置本地模型运行

## 📋 环境要求

在开始之前，请确保你的系统满足以下条件：

| 要求 | 说明 |
|------|------|
| **Python** | 3.11 或更高版本 |
| **操作系统** | Windows / macOS / Linux |
| **网络** | 能够访问 API 服务（或使用本地模型） |
| **存储空间** | 约 100MB（不含模型） |

### 检查 Python 版本

```bash
python --version
# 或
python3 --version
```

如果版本低于 3.11，请先升级 Python。

## 📦 安装 nanobot

nanobot 提供三种安装方式，根据你的需求选择：

### 方式一：PyPI 安装（推荐新手）

最简单的方式，一行命令搞定：

```bash
pip install nanobot-ai
```

> **注意**：包名是 `nanobot-ai`，不是 `nanobot`（后者是另一个项目）。

### 方式二：uv 安装（推荐高效用户）

如果你使用 [uv](https://github.com/astral-sh/uv)（一个极速 Python 包管理器）：

```bash
uv tool install nanobot-ai
```

uv 的优势是速度快、依赖隔离好。

### 方式三：源码安装（推荐开发者）

想要最新功能或参与开发？从源码安装：

```bash
git clone https://github.com/HKUDS/nanobot.git
cd nanobot
pip install -e .
```

`-e` 参数表示"可编辑模式"，修改代码后无需重新安装。

### 验证安装

安装完成后，运行：

```bash
nanobot --version
```

你应该看到类似 `🐈 nanobot v0.1.x` 的输出。

## 🚀 初始化配置

### 一键初始化

nanobot 提供了一个便捷的初始化命令：

```bash
nanobot onboard
```

这个命令会做三件事：

1. **创建配置文件**：`~/.nanobot/config.json`
2. **创建工作空间**：`~/.nanobot/workspace/`
3. **生成模板文件**：AGENTS.md、SOUL.md、USER.md 等

### 费曼式解释：什么是"工作空间"？

想象你有一个私人办公室：

- **config.json** 是你的"入职表"——记录了你的身份信息（API Key）、联系方式（渠道配置）等
- **workspace** 是你的"办公桌"——AI 助手在这里阅读文件、写文件、记笔记

工作空间里的几个重要文件：

| 文件 | 用途 |
|------|------|
| `AGENTS.md` | AI 的行为指南（类似工作手册） |
| `SOUL.md` | AI 的性格设定（它是谁？） |
| `USER.md` | 你的信息（偏好、习惯等） |
| `memory/MEMORY.md` | 长期记忆（跨会话记住的事） |

## ⚙️ 配置文件详解

配置文件位于 `~/.nanobot/config.json`，让我们逐层解析它的结构。

### 完整配置结构

```json
{
  "providers": { ... },    // LLM 提供商配置
  "agents": { ... },       // Agent 行为配置
  "channels": { ... },     // 聊天渠道配置
  "tools": { ... },        // 工具配置
  "gateway": { ... }       // 网关/服务器配置
}
```

### 1. providers：LLM 提供商

这是最核心的配置——告诉 nanobot 如何连接大语言模型。

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-xxx"
    }
  }
}
```

支持的提供商：

| 提供商 | 配置键 | 用途 | 获取 API Key |
|--------|--------|------|--------------|
| OpenRouter | `openrouter` | 统一入口，支持所有模型（推荐） | [openrouter.ai/keys](https://openrouter.ai/keys) |
| Anthropic | `anthropic` | Claude 直连 | [console.anthropic.com](https://console.anthropic.com) |
| OpenAI | `openai` | GPT 直连 | [platform.openai.com](https://platform.openai.com) |
| DeepSeek | `deepseek` | DeepSeek 直连 | [platform.deepseek.com](https://platform.deepseek.com) |
| Gemini | `gemini` | Google Gemini | [aistudio.google.com](https://aistudio.google.com) |
| Groq | `groq` | 极速推理 + 语音转写 | [console.groq.com](https://console.groq.com) |
| Moonshot | `moonshot` | Kimi/Moonshot | 月之暗面官网 |
| vLLM | `vllm` | 本地模型 | 无需 Key |

#### 为什么推荐 OpenRouter？

OpenRouter 是一个"LLM 聚合平台"，一个 API Key 可以访问：

- Claude (Anthropic)
- GPT-4 (OpenAI)
- Gemini (Google)
- Llama、Mistral 等开源模型

这样你只需要管理一个 Key，还能随时切换模型。

### 2. agents：Agent 行为配置

```json
{
  "agents": {
    "defaults": {
      "model": "anthropic/claude-opus-4-5",
      "workspace": "~/.nanobot/workspace",
      "maxTokens": 8192,
      "temperature": 0.7,
      "maxToolIterations": 20
    }
  }
}
```

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `model` | `anthropic/claude-opus-4-5` | 使用的模型 |
| `workspace` | `~/.nanobot/workspace` | 工作空间路径 |
| `maxTokens` | 8192 | 最大生成 token 数 |
| `temperature` | 0.7 | 创造性（0=确定性，1=随机） |
| `maxToolIterations` | 20 | 最大工具调用轮数 |

#### 模型命名规则

模型名称格式：`提供商/模型名`

```
openrouter/anthropic/claude-opus-4-5  # 通过 OpenRouter 访问 Claude
anthropic/claude-opus-4-5            # 直连 Anthropic
openai/gpt-4-turbo                    # 直连 OpenAI
deepseek/deepseek-chat                # 直连 DeepSeek
```

### 3. tools：工具配置

```json
{
  "tools": {
    "web": {
      "search": {
        "apiKey": "BSA-xxx",
        "maxResults": 5
      }
    },
    "exec": {
      "timeout": 60
    },
    "restrictToWorkspace": false
  }
}
```

| 配置 | 说明 |
|------|------|
| `web.search.apiKey` | Brave Search API Key（用于网页搜索） |
| `exec.timeout` | Shell 命令超时时间（秒） |
| `restrictToWorkspace` | 是否限制工具只能操作工作空间（安全选项） |

#### 安全提示

如果你在生产环境部署，强烈建议设置：

```json
{
  "tools": {
    "restrictToWorkspace": true
  }
}
```

这会限制 AI 只能读写 workspace 目录内的文件，防止意外操作系统文件。

### 4. channels：聊天渠道配置

这部分配置各种聊天平台的连接信息。详细配置请参考下一篇文章《多渠道接入配置详解》。

简单示例（Telegram）：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowFrom": ["YOUR_USER_ID"]
    }
  }
}
```

### 5. gateway：网关配置

```json
{
  "gateway": {
    "host": "0.0.0.0",
    "port": 18790
  }
}
```

这是 nanobot 服务运行时的网络配置，一般保持默认即可。

## 🔑 获取 API Key

### OpenRouter（推荐）

1. 访问 [openrouter.ai](https://openrouter.ai)
2. 注册/登录账号
3. 进入 [Keys 页面](https://openrouter.ai/keys)
4. 点击 "Create Key"
5. 复制生成的 Key（格式：`sk-or-v1-xxx`）

### Brave Search（可选，用于网页搜索）

1. 访问 [brave.com/search/api](https://brave.com/search/api/)
2. 注册开发者账号
3. 创建 API Key（格式：`BSA-xxx`）
4. 免费额度：每月 2000 次查询

## 📝 配置示例

### 最小配置（命令行对话）

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-your-key-here"
    }
  }
}
```

### 推荐配置（带搜索能力）

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-your-key-here"
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-opus-4-5"
    }
  },
  "tools": {
    "web": {
      "search": {
        "apiKey": "BSA-your-brave-key"
      }
    }
  }
}
```

### 经济配置（降低成本）

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-your-key-here"
    }
  },
  "agents": {
    "defaults": {
      "model": "minimax/minimax-m2"
    }
  }
}
```

## 🖥️ 本地模型配置（vLLM）

如果你有足够的 GPU 资源，可以运行本地模型，完全免费且隐私安全。

### 步骤 1：启动 vLLM 服务器

```bash
# 安装 vLLM
pip install vllm

# 启动服务（以 Llama 3.1 8B 为例）
vllm serve meta-llama/Llama-3.1-8B-Instruct --port 8000
```

### 步骤 2：配置 nanobot

```json
{
  "providers": {
    "vllm": {
      "apiKey": "dummy",
      "apiBase": "http://localhost:8000/v1"
    }
  },
  "agents": {
    "defaults": {
      "model": "vllm/meta-llama/Llama-3.1-8B-Instruct"
    }
  }
}
```

> **提示**：本地服务不需要真正的 API Key，但字段不能为空，填 `"dummy"` 即可。

### 步骤 3：验证

```bash
nanobot agent -m "Hello from my local LLM!"
```

## 🎉 第一次对话

配置完成后，让我们进行第一次对话！

### 单次对话模式

```bash
nanobot agent -m "你好，介绍一下你自己"
```

### 交互式对话模式

```bash
nanobot agent
```

进入交互模式后，直接输入问题即可，按 `Ctrl+C` 退出。

### 检查状态

如果遇到问题，运行状态检查：

```bash
nanobot status
```

这会显示：
- 配置文件是否存在
- 工作空间是否就绪
- 各个 API Key 是否配置

## 🐳 Docker 部署

如果你更喜欢容器化部署：

### 构建镜像

```bash
docker build -t nanobot .
```

### 初始化

```bash
docker run -v ~/.nanobot:/root/.nanobot --rm nanobot onboard
```

### 运行

```bash
# 单次对话
docker run -v ~/.nanobot:/root/.nanobot --rm nanobot agent -m "Hello!"

# 启动网关（连接 Telegram/WhatsApp 等）
docker run -v ~/.nanobot:/root/.nanobot -p 18790:18790 nanobot gateway
```

> **提示**：`-v ~/.nanobot:/root/.nanobot` 确保配置和数据在容器重启后保留。

## 🔧 常见问题

### Q: 报错 "No API key configured"

**A**: 确保在 `config.json` 中正确配置了至少一个提供商的 API Key。

### Q: 报错 "Model not found"

**A**: 检查模型名称是否正确。使用 OpenRouter 时，模型名需要包含 `openrouter/` 前缀。

### Q: 如何切换模型？

**A**: 修改 `config.json` 中的 `agents.defaults.model` 字段即可。

### Q: 配置文件在哪里？

**A**: 默认路径是 `~/.nanobot/config.json`，其中 `~` 是你的用户主目录：
- Windows: `C:\Users\你的用户名\.nanobot\config.json`
- macOS/Linux: `/home/你的用户名/.nanobot/config.json`

## 📊 CLI 命令速查

| 命令 | 说明 |
|------|------|
| `nanobot onboard` | 初始化配置和工作空间 |
| `nanobot agent -m "..."` | 发送单条消息 |
| `nanobot agent` | 进入交互模式 |
| `nanobot status` | 查看系统状态 |
| `nanobot gateway` | 启动网关（连接聊天渠道） |
| `nanobot channels status` | 查看渠道状态 |
| `nanobot cron list` | 查看定时任务 |

---

## 📝 小结

在这篇文章中，我们完成了：

- ✅ 安装 nanobot（三种方式可选）
- ✅ 理解配置文件结构（providers、agents、tools 等）
- ✅ 获取并配置 API Key
- ✅ 完成第一次对话
- ✅ 了解本地模型和 Docker 部署选项

现在你已经有了一个能用的 AI 助手！但目前只能在命令行中对话，如何让它连接到 Telegram、Discord、WhatsApp 或飞书呢？

---

> **下一篇预告**：[《多渠道接入配置详解：让 nanobot 无处不在》](./2026-01-31-nanobot-03-channels-setup.md)
>
> 我们将详细讲解每个聊天渠道的配置方法，包括获取 Bot Token、设置权限、配置白名单等。无论你想用哪个平台与 AI 对话，都能找到完整的配置指南。

---

*本文是 nanobot 深度解析系列的第 2 篇，共 11 篇。*

