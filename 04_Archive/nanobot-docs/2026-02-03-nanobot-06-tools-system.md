---
parent: "[[nanobot-docs]]"
slug: nanobot-06-tools-system
title: 工具系统设计与实现：让 AI 拥有"双手"
authors: [jiajiewu]
tags: [软件架构, Nanobot, Tools]
date: 2026-02-03
description: 揭秘 Nanobot 工具系统的设计与实现，涵盖 Tool 抽象基类、参数验证机制、安全防护策略以及文件、网络、命令执行等内置工具的开发细节。
draft: false
---

# 工具系统设计与实现：让 AI 拥有"双手"

> **系列导读**：在上一篇《Agent 核心引擎解析》中，我们了解了 nanobot 的大脑是如何工作的。但光有大脑是不够的，AI 还需要"双手"来与现实世界交互——读写文件、搜索网络、执行命令。本篇将深入探讨 nanobot 的工具系统，这是 Agent 能力扩展的关键。


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

1. 理解 nanobot 的工具抽象设计——什么是 Tool
2. 掌握工具注册与发现机制——如何管理工具
3. 学习内置核心工具的实现——文件、命令、网络
4. 学会为 nanobot 开发自定义工具

---

## 🛠️ Tool 抽象：一切皆工具

在 nanobot 中，所有的能力扩展都基于 `Tool` 抽象基类。这种统一的设计让添加新功能变得极其简单。

### Tool 基类设计

```python
# agent/tools/base.py
class Tool(ABC):
    """Abstract base class for all tools."""

    @property
    @abstractmethod
    def name(self) -> str:
        """The name of the tool (e.g., 'read_file')."""
        pass

    @property
    @abstractmethod
    def description(self) -> str:
        """A description of what the tool does."""
        pass

    @property
    @abstractmethod
    def parameters(self) -> dict:
        """JSON Schema for the tool's parameters."""
        pass

    @abstractmethod
    async def execute(self, **kwargs) -> Any:
        """Execute the tool with the given arguments."""
        pass

    def get_definition(self) -> dict:
        """Get the tool definition for the LLM."""
        return {
            "type": "function",
            "function": {
                "name": self.name,
                "description": self.description,
                "parameters": self.parameters
            }
        }
```

**设计亮点**：
- **自描述**：每个工具都必须提供自己的名称、描述和参数定义（JSON Schema）
- **异步执行**：`execute` 方法是异步的，适合处理 I/O 密集型任务
- **标准化接口**：`get_definition` 直接返回符合 OpenAI/Anthropic 标准的 Function Calling 格式

---

## 📚 ToolRegistry：工具大管家

有了工具定义，我们需要一个地方来管理它们。`ToolRegistry` 负责工具的注册、查找和执行。

```python
# agent/tools/registry.py
class ToolRegistry:
    """Registry for managing available tools."""

    def __init__(self):
        self._tools: dict[str, Tool] = {}

    def register(self, tool: Tool) -> None:
        """Register a tool."""
        if tool.name in self._tools:
            logger.warning(f"Overwriting tool: {tool.name}")
        self._tools[tool.name] = tool

    def get(self, name: str) -> Tool | None:
        """Get a tool by name."""
        return self._tools.get(name)

    def get_definitions(self) -> list[dict]:
        """Get definitions for all registered tools."""
        return [t.get_definition() for t in self._tools.values()]

    async def execute(self, name: str, arguments: str | dict) -> str:
        """Execute a tool by name with JSON arguments."""
        tool = self.get(name)
        if not tool:
            return f"Error: Tool '{name}' not found"

        # 解析参数
        try:
            if isinstance(arguments, str):
                kwargs = json.loads(arguments)
            else:
                kwargs = arguments
        except json.JSONDecodeError as e:
            return f"Error: Invalid JSON arguments: {e}"

        # 执行工具
        try:
            result = await tool.execute(**kwargs)
            return str(result)
        except Exception as e:
            logger.error(f"Error executing tool {name}: {e}")
            return f"Error executing tool {name}: {e}"
```

**安全防护**：
- `execute` 方法捕获了所有潜在异常，防止单个工具崩溃导致整个程序退出
- 即使发生错误，也会返回友好的错误信息给 LLM，让 LLM 有机会自我修正

---

## 📂 文件系统工具：AI 的文件柜

文件操作是 Agent 最基础的能力。nanobot 提供了一组安全的文件工具。

### 路径安全检查

为了防止 AI 访问系统敏感文件（如 `/etc/passwd`），我们在 `BaseFileTool` 中实现了路径检查：

```python
class BaseFileTool(Tool):
    def __init__(self, workspace: Path):
        self.workspace = workspace.resolve()

    def validate_path(self, path_str: str) -> Path:
        """Ensure path is within workspace."""
        try:
            # 处理波浪号展开
            path = Path(path_str).expanduser().resolve()
            
            # 检查是否在工作区内
            if not str(path).startswith(str(self.workspace)):
                raise ValueError(f"Access denied: Path must be within {self.workspace}")
            
            return path
        except Exception as e:
            raise ValueError(f"Invalid path: {e}")
```

### ReadFileTool

```python
class ReadFileTool(BaseFileTool):
    @property
    def name(self) -> str:
        return "read_file"

    @property
    def description(self) -> str:
        return "Read the contents of a file. Returns error if file doesn't exist."

    @property
    def parameters(self) -> dict:
        return {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "Absolute path to the file"
                }
            },
            "required": ["path"]
        }

    async def execute(self, path: str) -> str:
        try:
            safe_path = self.validate_path(path)
            if not safe_path.exists():
                return f"Error: File not found: {path}"
            
            # 读取文件（限制大小）
            content = safe_path.read_text(encoding="utf-8")
            if len(content) > 100000:
                return content[:100000] + "\n... (truncated)"
            return content
        except Exception as e:
            return f"Error reading file: {e}"
```

类似的工具还有：
- `WriteFileTool`：写入文件（会自动创建目录）
- `ListDirTool`：列出目录内容
- `EditFileTool`：基于字符串替换的编辑（实现较简单，未来可升级为基于 AST 的编辑）

---

## 💻 命令行执行工具：强大的双刃剑

`ExecTool` 赋予了 AI 执行 Shell 命令的能力。这是最强大的工具，也是最危险的工具。

### 安全策略

为了控制风险，我们采用了多层防护：

1.  **黑名单机制**：禁止执行高危命令（如 `rm -rf /`, `sudo`, `su`）
2.  **受限环境**：设置特定的工作目录
3.  **超时控制**：防止命令长时间挂起
4.  **截断输出**：防止大量日志冲爆 LLM 上下文

```python
# agent/tools/exec.py
class ExecTool(Tool):
    FORBIDDEN_COMMANDS = [
        "rm -rf /", "mkfs", "dd", ":(){ :|:& };:", "sudo", "su"
    ]

    def __init__(self, workspace: Path, config: ExecToolConfig | None = None):
        self.workspace = workspace
        self.config = config or ExecToolConfig()

    async def execute(self, command: str, background: bool = False) -> str:
        # 1. 黑名单检查
        for bad in self.FORBIDDEN_COMMANDS:
            if bad in command:
                return f"Error: Command '{bad}' is forbidden for safety reasons."

        # 2. 执行命令
        try:
            process = await asyncio.create_subprocess_shell(
                command,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
                cwd=self.workspace
            )

            # 3. 处理超时
            try:
                stdout, stderr = await asyncio.wait_for(
                    process.communicate(), 
                    timeout=self.config.timeout
                )
            except asyncio.TimeoutError:
                process.kill()
                return f"Error: Command timed out after {self.config.timeout}s"

            # 4. 格式化输出
            output = stdout.decode().strip()
            error = stderr.decode().strip()
            
            result = []
            if output:
                result.append(f"STDOUT:\n{output}")
            if error:
                result.append(f"STDERR:\n{error}")
            
            return "\n".join(result) if result else "Command executed successfully (no output)"

        except Exception as e:
            return f"Error executing command: {e}"
```

---

## 🌐 网络工具：连接世界

nanobot 内置了两个主要网络工具：

### 1. WebSearchTool (基于 Brave Search)

如果配置了 `BRAVE_API_KEY`，AI 就可以搜索实时信息：

```python
class WebSearchTool(Tool):
    async def execute(self, query: str) -> str:
        if not self.api_key:
            return "Error: Web search is not configured (missing BRAVE_API_KEY)"

        # 调用 Brave Search API
        async with httpx.AsyncClient() as client:
            resp = await client.get(
                "https://api.search.brave.com/res/v1/web/search",
                headers={"X-Subscription-Token": self.api_key},
                params={"q": query, "count": 5}
            )
            data = resp.json()
            
            # 解析结果
            results = []
            for item in data.get("web", {}).get("results", []):
                results.append(f"- [{item['title']}]({item['url']}): {item['description']}")
            
            return "\n".join(results)
```

### 2. WebFetchTool (基于 Readability)

AI 可以读取网页内容，用于总结文章或抓取文档：

```python
class WebFetchTool(Tool):
    async def execute(self, url: str) -> str:
        # 1. 验证 URL
        if not self._validate_url(url):
            return "Error: Invalid URL"

        # 2. 下载网页
        async with httpx.AsyncClient() as client:
            resp = await client.get(url, follow_redirects=True)
            html = resp.text

        # 3. 提取正文（去除广告、导航栏）
        doc = Document(html)
        title = doc.title()
        content = doc.summary(html_partial=True) # 使用 readability-lxml 提取

        # 4. 转换为 Markdown (简化版)
        markdown = self._html_to_markdown(content)
        
        return f"# {title}\n\n{markdown}"
```

---

## 🧩 其他特色工具

### MessageTool

允许 AI 主动向特定渠道发送消息，而不是只能回复当前消息。

```python
class MessageTool(Tool):
    @property
    def name(self) -> str:
        return "message"

    async def execute(self, content: str, channel: str | None = None, chat_id: str | None = None) -> str:
        # 默认发送到当前上下文
        target_channel = channel or self.current_channel
        target_chat_id = chat_id or self.current_chat_id
        
        # 发布消息到总线
        await self.bus.publish_outbound(OutboundMessage(
            channel=target_channel,
            chat_id=target_chat_id,
            content=content
        ))
        return "Message sent"
```

### SpawnTool & CronTool

这将在后续关于"子代理"和"定时任务"的文章中详细介绍。

---

## 🏗️ 如何开发自定义工具？

nanobot 的工具系统是可扩展的。你只需继承 `Tool` 类并注册即可。

例如，创建一个查询股票价格的工具：

```python
class StockPriceTool(Tool):
    @property
    def name(self) -> str:
        return "get_stock_price"

    @property
    def description(self) -> str:
        return "Get the current price of a stock symbol."

    @property
    def parameters(self) -> dict:
        return {
            "type": "object",
            "properties": {
                "symbol": {"type": "string", "description": "Stock symbol (e.g., AAPL)"}
            },
            "required": ["symbol"]
        }

    async def execute(self, symbol: str) -> str:
        # 这里调用真实的股票 API
        price = await fetch_stock_price(symbol)
        return f"The current price of {symbol} is ${price}"

# 注册工具
registry = ToolRegistry()
registry.register(StockPriceTool())
```

通过这种方式，你可以无限扩展 nanobot 的能力！

---

## 📝 小结

nanobot 的工具系统设计简洁而强大：

- **统一抽象**：所有能力都封装为 Tool，易于理解和扩展
- **安全优先**：文件路径检查、命令黑名单、执行超时控制
- **标准兼容**：完全适配 Function Calling 格式
- **开箱即用**：内置了文件、命令、搜索、网页抓取等核心工具

在下一篇文章中，我们将探讨 nanobot 内部各组件是如何通信的——消息总线与事件系统。

---

> **下一篇预告**：[《消息总线与事件系统：解耦架构的艺术》](./2026-02-04-nanobot-07-message-bus.md)
>
> 我们将深入 `bus/` 模块，了解 Inbound/Outbound 消息模型，以及如何利用 `asyncio.Queue` 实现高效的发布/订阅机制。

---

*本文是 nanobot 深度解析系列的第 6 篇，共 11 篇。*

