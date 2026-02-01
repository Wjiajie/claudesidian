---
title: "modelcontextprotocol/typescript-sdk: The official Typescript SDK for Model Context Protocol servers and clients"
source: "https://github.com/modelcontextprotocol/typescript-sdk"
author:
published:
created: 2025-04-19
description:
tags:
  - "clippings"
parent: "[[obsidian剪藏]]"
---
The official Typescript SDK for Model Context Protocol servers and clients

[modelcontextprotocol.io](https://modelcontextprotocol.io/ "https://modelcontextprotocol.io")

[MIT license](https://github.com/modelcontextprotocol/typescript-sdk/blob/main/LICENSE)

[Open in github.dev](https://github.dev/) [Open in a new github.dev tab](https://github.dev/) [Open in codespace](https://github.com/codespaces/new/modelcontextprotocol/typescript-sdk?resume=1)

<table><thead><tr><th colspan="2"><span>Name</span></th><th colspan="1"></th><th></th><th colspan="1"></th></tr></thead><tbody><tr><td colspan="3"></td></tr><tr><td colspan="2"><p><a href="https://github.com/modelcontextprotocol/typescript-sdk/tree/main/.github/workflows"><span>.github/</span> <span>workflows</span></a></p></td><td colspan="1"></td><td></td><td></td></tr><tr><td colspan="2"><p><a href="https://github.com/modelcontextprotocol/typescript-sdk/tree/main/src">src</a></p></td><td colspan="1"></td><td></td><td></td></tr><tr><td colspan="2"><p><a href="https://github.com/modelcontextprotocol/typescript-sdk/blob/main/.gitattributes">.gitattributes</a></p></td><td colspan="1"></td><td></td><td></td></tr><tr><td colspan="2"><p><a href="https://github.com/modelcontextprotocol/typescript-sdk/blob/main/.gitignore">.gitignore</a></p></td><td colspan="1"></td><td></td><td></td></tr><tr><td colspan="2"><p><a href="https://github.com/modelcontextprotocol/typescript-sdk/blob/main/.npmrc">.npmrc</a></p></td><td colspan="1"></td><td></td><td></td></tr><tr><td colspan="2"><p><a href="https://github.com/modelcontextprotocol/typescript-sdk/blob/main/CLAUDE.md">CLAUDE.md</a></p></td><td colspan="1"></td><td></td><td></td></tr><tr><td colspan="2"><p><a href="https://github.com/modelcontextprotocol/typescript-sdk/blob/main/CODE_OF_CONDUCT.md">CODE_OF_CONDUCT.md</a></p></td><td colspan="1"></td><td></td><td></td></tr><tr><td colspan="2"><p><a href="https://github.com/modelcontextprotocol/typescript-sdk/blob/main/CONTRIBUTING.md">CONTRIBUTING.md</a></p></td><td colspan="1"></td><td></td><td></td></tr><tr><td colspan="2"><p><a href="https://github.com/modelcontextprotocol/typescript-sdk/blob/main/LICENSE">LICENSE</a></p></td><td colspan="1"></td><td></td><td></td></tr><tr><td colspan="2"><p><a href="https://github.com/modelcontextprotocol/typescript-sdk/blob/main/README.md">README.md</a></p></td><td colspan="1"></td><td></td><td></td></tr><tr><td colspan="3"></td></tr></tbody></table>

- - [测试和调试](https://github.com/modelcontextprotocol/#testing-and-debugging)
- [例子](https://github.com/modelcontextprotocol/#examples)
	- [回声服务器](https://github.com/modelcontextprotocol/#echo-server)
	- [SQLite资源管理器](https://github.com/modelcontextprotocol/#sqlite-explorer)
- [高级用法](https://github.com/modelcontextprotocol/#advanced-usage)
	- [低级服务器](https://github.com/modelcontextprotocol/#low-level-server)
	- [编写MCP客户端](https://github.com/modelcontextprotocol/#writing-mcp-clients)
	- [服务器功能](https://github.com/modelcontextprotocol/#server-capabilities)
	- [向后兼容性](https://github.com/modelcontextprotocol/#backwards-compatibility)

## 概览

模型上下文协议允许应用程序以标准化的方式为LLM提供上下文，将提供上下文的关注点与实际的LLM交互分开。此TypeScript SDK实现了完整的MCP规范，可以轻松地：

- 构建可以连接到任何MCP服务器的MCP客户端
- 创建公开资源、提示和工具的MCP服务器
- 使用标准传输，如标准输入输出和Streamable HTTP
- 处理所有MCP协议消息和生命周期事件

## 安装

```
npm install @modelcontextprotocol/sdk
```

让我们创建一个简单的MCP服务器，它公开了一个计算器工具和一些数据：

```
import { McpServer, ResourceTemplate } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// Create an MCP server
const server = new McpServer({
  name: "Demo",
  version: "1.0.0"
});

// Add an addition tool
server.tool("add",
  { a: z.number(), b: z.number() },
  async ({ a, b }) => ({
    content: [{ type: "text", text: String(a + b) }]
  })
);

// Add a dynamic greeting resource
server.resource(
  "greeting",
  new ResourceTemplate("greeting://{name}", { list: undefined }),
  async (uri, { name }) => ({
    contents: [{
      uri: uri.href,
      text: \`Hello, ${name}!\`
    }]
  })
);

// Start receiving messages on stdin and sending messages on stdout
const transport = new StdioServerTransport();
await server.connect(transport);
```

[模型上下文协议（MCP）](https://modelcontextprotocol.io/) 允许您构建服务器，以安全、标准化的方式向LLM应用程序公开数据和功能。把它想象成一个Web API，但专为LLM交互而设计。MCP服务器可以：

- 通过 **Resources** 公开数据（想想这些类似GET端点的东西；它们用于将信息加载到LLM的上下文中）
- 通过 **Tools** 提供功能（有点像POST端点；它们用于执行代码或以其他方式产生副作用）
- 通过 **Prompts** （LLM交互的可重用模板）定义交互模式
- 还有更多！

### 服务器

McpServer是MCP协议的核心接口。它处理连接管理、协议合规性和消息路由：

```
const server = new McpServer({
  name: "My App",
  version: "1.0.0"
});
```

### 资源

资源是您向LLM公开数据的方式。它们类似于REST API中的GET端点-它们提供数据但不应执行大量计算或具有副作用：

```
// Static resource
server.resource(
  "config",
  "config://app",
  async (uri) => ({
    contents: [{
      uri: uri.href,
      text: "App configuration here"
    }]
  })
);

// Dynamic resource with parameters
server.resource(
  "user-profile",
  new ResourceTemplate("users://{userId}/profile", { list: undefined }),
  async (uri, { userId }) => ({
    contents: [{
      uri: uri.href,
      text: \`Profile data for user ${userId}\`
    }]
  })
);
```

### 工具

工具让LLM通过您的服务器执行操作。与资源不同，工具需要执行计算并具有副作用：

```
// Simple tool with parameters
server.tool(
  "calculate-bmi",
  {
    weightKg: z.number(),
    heightM: z.number()
  },
  async ({ weightKg, heightM }) => ({
    content: [{
      type: "text",
      text: String(weightKg / (heightM * heightM))
    }]
  })
);

// Async tool with external API call
server.tool(
  "fetch-weather",
  { city: z.string() },
  async ({ city }) => {
    const response = await fetch(\`https://api.weather.com/${city}\`);
    const data = await response.text();
    return {
      content: [{ type: "text", text: data }]
    };
  }
);
```

### 提示

提示是可重用的模板，可帮助LLM与您的服务器有效交互：

```
server.prompt(
  "review-code",
  { code: z.string() },
  ({ code }) => ({
    messages: [{
      role: "user",
      content: {
        type: "text",
        text: \`Please review this code:\n\n${code}\`
      }
    }]
  })
);
```

TypeScript中的MCP服务器需要连接到传输才能与客户端通信。如何启动服务器取决于传输的选择：

### 标准输入输出

对于命令行工具和直接集成：

```
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new McpServer({
  name: "example-server",
  version: "1.0.0"
});

// ... set up server resources, tools, and prompts ...

const transport = new StdioServerTransport();
await server.connect(transport);
```


```
import express from "express";
import { randomUUID } from "node:crypto";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { InMemoryEventStore } from "@modelcontextprotocol/sdk/inMemory.js";

const app = express();
app.use(express.json());

// Map to store transports by session ID
const transports: { [sessionId: string]: StreamableHTTPServerTransport } = {};

// Handle POST requests for client-to-server communication
app.post('/mcp', async (req, res) => {
  // Check for existing session ID
  const sessionId = req.headers['mcp-session-id'] as string | undefined;
  let transport: StreamableHTTPServerTransport;

  if (sessionId && transports[sessionId]) {
    // Reuse existing transport
    transport = transports[sessionId];
  } else if (!sessionId && isInitializeRequest(req.body)) {
    // New initialization request
    const eventStore = new InMemoryEventStore();
    transport = new StreamableHTTPServerTransport({
      sessionIdGenerator: () => randomUUID(),
      eventStore, // Enable resumability
      onsessioninitialized: (sessionId) => {
        // Store the transport by session ID
        transports[sessionId] = transport;
      }
    });

    // Clean up transport when closed
    transport.onclose = () => {
      if (transport.sessionId) {
        delete transports[transport.sessionId];
      }
    };
    const server = new McpServer({
      name: "example-server",
      version: "1.0.0"
    });

    // ... set up server resources, tools, and prompts ...

    // Connect to the MCP server
    await server.connect(transport);
  } else {
    // Invalid request
    res.status(400).json({
      jsonrpc: '2.0',
      error: {
        code: -32000,
        message: 'Bad Request: No valid session ID provided',
      },
      id: null,
    });
    return;
  }

  // Handle the request
  await transport.handleRequest(req, res, req.body);
});

// Reusable handler for GET and DELETE requests
const handleSessionRequest = async (req: express.Request, res: express.Response) => {
  const sessionId = req.headers['mcp-session-id'] as string | undefined;
  if (!sessionId || !transports[sessionId]) {
    res.status(400).send('Invalid or missing session ID');
    return;
  }
  
  const transport = transports[sessionId];
  await transport.handleRequest(req, res);
};

// Handle GET requests for server-to-client notifications via SSE
app.get('/mcp', handleSessionRequest);

// Handle DELETE requests for session termination
app.delete('/mcp', handleSessionRequest);

app.listen(3000);
```


```
const app = express();
app.use(express.json());

const transport: StreamableHTTPServerTransport = new StreamableHTTPServerTransport({
  sessionIdGenerator: undefined, // set to undefined for stateless servers
});

// Setup routes for the server
const setupServer = async () => {
  await server.connect(transport);
};

app.post('/mcp', async (req: Request, res: Response) => {
  console.log('Received MCP request:', req.body);
  try {
      await transport.handleRequest(req, res, req.body);
  } catch (error) {
    console.error('Error handling MCP request:', error);
    if (!res.headersSent) {
      res.status(500).json({
        jsonrpc: '2.0',
        error: {
          code: -32603,
          message: 'Internal server error',
        },
        id: null,
      });
    }
  }
});

app.get('/mcp', async (req: Request, res: Response) => {
  console.log('Received GET MCP request');
  res.writeHead(405).end(JSON.stringify({
    jsonrpc: "2.0",
    error: {
      code: -32000,
      message: "Method not allowed."
    },
    id: null
  }));
});

app.delete('/mcp', async (req: Request, res: Response) => {
  console.log('Received DELETE MCP request');
  res.writeHead(405).end(JSON.stringify({
    jsonrpc: "2.0",
    error: {
      code: -32000,
      message: "Method not allowed."
    },
    id: null
  }));
});

// Start the server
const PORT = 3000;
setupServer().then(() => {
  app.listen(PORT, () => {
    console.log(\`MCP Streamable HTTP Server listening on port ${PORT}\`);
  });
}).catch(error => {
  console.error('Failed to set up the server:', error);
  process.exit(1);
});
```


```
import { McpServer, ResourceTemplate } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

const server = new McpServer({
  name: "Echo",
  version: "1.0.0"
});

server.resource(
  "echo",
  new ResourceTemplate("echo://{message}", { list: undefined }),
  async (uri, { message }) => ({
    contents: [{
      uri: uri.href,
      text: \`Resource echo: ${message}\`
    }]
  })
);

server.tool(
  "echo",
  { message: z.string() },
  async ({ message }) => ({
    content: [{ type: "text", text: \`Tool echo: ${message}\` }]
  })
);

server.prompt(
  "echo",
  { message: z.string() },
  ({ message }) => ({
    messages: [{
      role: "user",
      content: {
        type: "text",
        text: \`Please process this message: ${message}\`
      }
    }]
  })
);
```


```
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import sqlite3 from "sqlite3";
import { promisify } from "util";
import { z } from "zod";

const server = new McpServer({
  name: "SQLite Explorer",
  version: "1.0.0"
});

// Helper to create DB connection
const getDb = () => {
  const db = new sqlite3.Database("database.db");
  return {
    all: promisify<string, any[]>(db.all.bind(db)),
    close: promisify(db.close.bind(db))
  };
};

server.resource(
  "schema",
  "schema://main",
  async (uri) => {
    const db = getDb();
    try {
      const tables = await db.all(
        "SELECT sql FROM sqlite_master WHERE type='table'"
      );
      return {
        contents: [{
          uri: uri.href,
          text: tables.map((t: {sql: string}) => t.sql).join("\n")
        }]
      };
    } finally {
      await db.close();
    }
  }
);

server.tool(
  "query",
  { sql: z.string() },
  async ({ sql }) => {
    const db = getDb();
    try {
      const results = await db.all(sql);
      return {
        content: [{
          type: "text",
          text: JSON.stringify(results, null, 2)
        }]
      };
    } catch (err: unknown) {
      const error = err as Error;
      return {
        content: [{
          type: "text",
          text: \`Error: ${error.message}\`
        }],
        isError: true
      };
    } finally {
      await db.close();
    }
  }
);
```


```
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

const server = new McpServer({
  name: "Dynamic Example",
  version: "1.0.0"
});

const listMessageTool = server.tool(
  "listMessages",
  { channel: z.string() },
  async ({ channel }) => ({
    content: [{ type: "text", text: await listMessages(channel) }]
  })
);

const putMessageTool = server.tool(
  "putMessage",
  { channel: z.string(), message: z.string() },
  async ({ channel, message }) => ({
    content: [{ type: "text", text: await putMessage(channel, string) }]
  })
);
// Until we upgrade auth, \`putMessage\` is disabled (won't show up in listTools)
putMessageTool.disable()

const upgradeAuthTool = server.tool(
  "upgradeAuth",
  { permission: z.enum(["write', vadmin"])},
  // Any mutations here will automatically emit \`listChanged\` notifications
  async ({ permission }) => {
    const { ok, err, previous } = await upgradeAuthAndStoreToken(permission)
    if (!ok) return {content: [{ type: "text", text: \`Error: ${err}\` }]}

    // If we previously had read-only access, 'putMessage' is now available
    if (previous === "read") {
      putMessageTool.enable()
    }

    if (permission === 'write') {
      // If we've just upgraded to 'write' permissions, we can still call 'upgradeAuth' 
      // but can only upgrade to 'admin'. 
      upgradeAuthTool.update({
        paramSchema: { permission: z.enum(["admin"]) }, // change validation rules
      })
    } else {
      // If we're now an admin, we no longer have anywhere to upgrade to, so fully remove that tool
      upgradeAuthTool.remove()
    }
  }
)

// Connect as normal
const transport = new StdioServerTransport();
await server.connect(transport);
```


```
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  ListPromptsRequestSchema,
  GetPromptRequestSchema
} from "@modelcontextprotocol/sdk/types.js";

const server = new Server(
  {
    name: "example-server",
    version: "1.0.0"
  },
  {
    capabilities: {
      prompts: {}
    }
  }
);

server.setRequestHandler(ListPromptsRequestSchema, async () => {
  return {
    prompts: [{
      name: "example-prompt",
      description: "An example prompt template",
      arguments: [{
        name: "arg1",
        description: "Example argument",
        required: true
      }]
    }]
  };
});

server.setRequestHandler(GetPromptRequestSchema, async (request) => {
  if (request.params.name !== "example-prompt") {
    throw new Error("Unknown prompt");
  }
  return {
    description: "Example prompt",
    messages: [{
      role: "user",
      content: {
        type: "text",
        text: "Example prompt text"
      }
    }]
  };
});

const transport = new StdioServerTransport();
await server.connect(transport);
```


```
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";

const transport = new StdioClientTransport({
  command: "node",
  args: ["server.js"]
});

const client = new Client(
  {
    name: "example-client",
    version: "1.0.0"
  }
);

await client.connect(transport);

// List prompts
const prompts = await client.listPrompts();

// Get a prompt
const prompt = await client.getPrompt({
  name: "example-prompt",
  arguments: {
    arg1: "value"
  }
});

// List resources
const resources = await client.listResources();

// Read a resource
const resource = await client.readResource({
  uri: "file:///example.txt"
});

// Call a tool
const result = await client.callTool({
  name: "example-tool",
  arguments: {
    arg1: "value"
  }
});
```
```
import express from 'express';
import { ProxyOAuthServerProvider, mcpAuthRouter } from '@modelcontextprotocol/sdk';

const app = express();

const proxyProvider = new ProxyOAuthServerProvider({
    endpoints: {
        authorizationUrl: "https://auth.external.com/oauth2/v1/authorize",
        tokenUrl: "https://auth.external.com/oauth2/v1/token",
        revocationUrl: "https://auth.external.com/oauth2/v1/revoke",
    },
    verifyAccessToken: async (token) => {
        return {
            token,
            clientId: "123",
            scopes: ["openid", "email", "profile"],
        }
    },
    getClient: async (client_id) => {
        return {
            client_id,
            redirect_uris: ["http://localhost:3000/callback"],
        }
    }
})

app.use(mcpAuthRouter({
    provider: proxyProvider,
    issuerUrl: new URL("http://auth.external.com"),
    baseUrl: new URL("http://mcp.example.com"),
    serviceDocumentationUrl: new URL("https://docs.example.com/"),
}))
```
```
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StreamableHTTPClientTransport } from "@modelcontextprotocol/sdk/client/streamableHttp.js";
import { SSEClientTransport } from "@modelcontextprotocol/sdk/client/sse.js";
let client: Client|undefined = undefined
const baseUrl = new URL(url);
try {
  client = new Client({
    name: 'streamable-http-client',
    version: '1.0.0'
  });
  const transport = new StreamableHTTPClientTransport(
    new URL(baseUrl)
  );
  await client.connect(transport);
  console.log("Connected using Streamable HTTP transport");
} catch (error) {
  // If that fails with a 4xx error, try the older SSE transport
  console.log("Streamable HTTP connection failed, falling back to SSE transport");
  client = new Client({
    name: 'sse-client',
    version: '1.0.0'
  });
  const sseTransport = new SSEClientTransport(baseUrl);
  await client.connect(sseTransport);
  console.log("Connected using SSE transport");
}
```
```
import express from "express";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";
import { InMemoryEventStore } from "@modelcontextprotocol/sdk/inMemory.js";

const server = new McpServer({
  name: "backwards-compatible-server",
  version: "1.0.0"
});

// ... set up server resources, tools, and prompts ...

const app = express();
app.use(express.json());

// Store transports for each session type
const transports = {
  streamable: {} as Record<string, StreamableHTTPServerTransport>,
  sse: {} as Record<string, SSEServerTransport>
};

// Modern Streamable HTTP endpoint
app.all('/mcp', async (req, res) => {
  // Handle Streamable HTTP transport for modern clients
  // Implementation as shown in the "With Session Management" example
  // ...
});

// Legacy SSE endpoint for older clients
app.get('/sse', async (req, res) => {
  // Create SSE transport for legacy clients
  const transport = new SSEServerTransport('/messages', res);
  transports.sse[transport.sessionId] = transport;
  
  res.on("close", () => {
    delete transports.sse[transport.sessionId];
  });
  
  await server.connect(transport);
});

// Legacy message endpoint for older clients
app.post('/messages', async (req, res) => {
  const sessionId = req.query.sessionId as string;
  const transport = transports.sse[sessionId];
  if (transport) {
    await transport.handlePostMessage(req, res);
  } else {
    res.status(400).send('No transport found for sessionId');
  }
});

app.listen(3000);
```