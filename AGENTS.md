# Claudesidian 配置文件

> 最后更新: 2026-05-16
> 用户: jiajiewu

## 👤 用户档案

**姓名**: jiajiewu
**语言偏好**: 中文
**主要场景**: 知识管理、独立开发、研究写作、项目管理、日常笔记

## 🎯 使用场景

### 知识管理 + 独立开发
- 整理和连接知识点
- 独立开发工具和资源收集
- PMF（产品市场契合）研究
- 投资和价值观思考

### 研究与写作
- 深度阅读和笔记
- 内容创作和输出
- 思维模型构建

### 项目管理
- 年度/季度规划（如 2025年度规划）
- 高优先级项目追踪
- 任务和目标管理

### 日常笔记
- 每日记录（格式: YYYY-MM-DD.md）
- 闪念捕获
- 反思和总结

## 📁 仓库结构 (PARA 方法)

```
claudesidian/
├── 00_Inbox/           # 临时捕获 + 每日笔记
│   ├── YYYY-MM-DD.md   # 每日笔记格式
│   ├── 值得读的帖子/
│   ├── 决策能力/
│   ├── 思维模型/
│   ├── 独立开发杂谈/
│   └── ...
├── 01_Projects/        # 活跃项目（有明确截止日期）
├── 02_Areas/           # 持续关注领域（无截止日期）
├── 03_Resources/       # 参考资料和知识库
│   ├── A-*             # A类笔记（主题索引）
│   ├── B-*             # B类笔记（规划相关）
│   └── C-*             # C类笔记（流程/方法）
├── 04_Archive/         # 归档内容
├── 05_Attachments/     # 附件（图片、PDF等）
├── 06_Metadata/        # 模板和配置
├── 07_Wiki/            # 结构化知识库（由 AI 维护的主题索引、概念网络）
└── OLD_VAULT/          # 原始仓库备份
```

## 📝 笔记命名规范

根据你现有的笔记结构，遵循以下规范：

- **每日笔记**: `YYYY-MM-DD.md` (如 2024-08-01.md)
- **主题索引**: `A-YYYYMMDDHHNN-标题.md` (如 A-202408081001-产品与设计.md)
- **规划笔记**: `B-YYYYMMDDHHNN-标题.md` (如 B-202501251202-2025年度规划.md)
- **方法流程**: `C-YYYYMMDDHHNN-标题.md`

## 🤖 AI 交互规则

### Codex 默认技能

- 在 Codex 中，当当前项目为 `C:\Users\jiaji\Documents\github-project\claudesidian`，且对话涉及知识管理、笔记查询、资料摄入、Inbox 整理、日/周回顾、研究写作或知识库维护时，默认调用 `knowledge-curator` 技能。
- 不需要用户每次显式输入 `[$knowledge-curator]`；只要任务属于 Claudesidian 知识工作，就按该技能的工作流执行。
- 执行顺序：先读取本文件和 `07_Wiki/index.md`，再搜索 `03_Resources/` 与相关 PARA 目录，最后根据需要提出 `07_Wiki/` 写回计划。
- 默认只读 `00_Inbox/` 到 `06_Metadata/` 的原始笔记；除非用户明确要求整理、移动或编辑，否则写入仅限 `07_Wiki/`。
- 写入 `07_Wiki/` 前先列出计划并等待确认；若用户已经明确批准某个具体写入操作，则可直接执行并报告变更文件。

### 语言
- **始终使用中文**与用户交流
- 技术术语可保留英文原文

### 思考模式 vs 写作模式

**思考模式**（默认）:
- 通过提问帮助用户理清思路
- 搜索现有笔记寻找相关内容
- 建立知识之间的连接
- 不急于给出答案，而是引导思考

**写作模式**:
- 用户明确要求时进入
- 生成草稿、编辑内容
- 创建最终输出

### 与知识库交互
- 在回答问题前，先搜索 `03_Resources/` 查找相关笔记，并关联 `07_Wiki/` 中的知识实体
- 参考用户的思维模型和价值观，尊重用户已建立的知识结构
- 当需要更新或提取结构化知识时，遵守 `07_Wiki/` 的写回规则（仅在此目录下有写权限）

## 🔌 已安装的 Obsidian 插件

- **Copilot** - AI 助手
- **Dataview** - 数据查询
- **Excalidraw** - 手绘图表
- **Memos** - 快速记录
- **Omnivore** - 稍后阅读
- **WeRead Plugin** - 微信读书同步
- **PDF Plus** - PDF 增强
- **Remotely Save** - 远程同步
- **Zotlit** - Zotero 集成
- **Wucai Highlights** - 五彩划线

## 🚀 常用命令

在 Codex 中可用：

- `/thinking-partner` - 探索想法，通过提问深入思考
- `/daily-review` - 每日回顾和反思
- `/research-assistant` - 深度研究主题
- `/inbox-processor` - 整理收件箱内容
- `/weekly-synthesis` - 每周总结和模式发现

## 🔐 权限配置

权限配置位于 `.Codex/settings.json`：

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Write",
      "Edit",
      "Glob",
      "Grep",
      "WebSearch",
      "WebFetch",
      "mcp__fetch__fetch",
      "mcp__jina__search_web",
      "mcp__jina__read_url",
      "mcp__jina__search_images",
      "mcp__jina__search_arxiv",
      "mcp__jina__search_ssrn",
      "mcp__jina__search_bibtex",
      "mcp__github__*",
      "mcp__memory__*",
      "mcp__excalidraw__*"
    ]
  }
}
```

**权限说明：**
| 工具 | 用途 |
|------|------|
| Read/Write/Edit/Glob/Grep | 文件操作 |
| WebSearch/WebFetch | 网页搜索和获取 |
| mcp__jina__* | Jina 搜索服务（网页、学术论文、图片等） |
| mcp__github__* | GitHub 操作 |
| mcp__memory__* | 记忆/知识图谱 |
| mcp__excalidraw__* | 绘图 |

修改权限配置后需要重启 Codex 会话生效。

---

## 📌 重要提醒

1. **新笔记优先放入 `00_Inbox/`**，之后再整理归类
2. **保持笔记原子化**，每个笔记一个核心想法
3. **多使用双向链接** `[[笔记名]]` 建立知识网络
4. **定期回顾和整理** Inbox 中的临时笔记
5. **专题文档需建立索引**：当一个主题有多篇相关文档时（如 04_Archive/Ralph-Orchestrator/），应在同级目录创建一个索引文件（如 `04_Archive/Ralph-Orchestrator.md`），包含主题概述和文档目录，便于双向链接和导航
6. **建立层级化的 parent 链接**：通过 YAML frontmatter 中的 `parent` 字段建立层级关系

## 🔗 双向链接与层级结构

### parent 字段规范

使用 YAML frontmatter 中的 `parent` 字段建立笔记的层级关系：

```yaml
---
parent: "[[父笔记名]]"
---
```

### 层级结构规则

**三级结构**：
1. **索引入口** (`06_Metadata/A-000000000000-索引入口.md`) - 最顶层，无 parent
2. **专题索引文件** - 在同级目录创建的索引文件，parent 指向 `[[索引入口]]`
3. **子文档** - 具体的笔记内容，parent 指向对应的专题索引文件

**示例**：
```
[[索引入口]]                    # 无 parent（顶层）
├── 04_Archive/nanobot-docs.md  # parent: [[索引入口]]
│   ├── 01-overview.md          # parent: [[nanobot-docs]]
│   └── 02-installation.md     # parent: [[nanobot-docs]]
├── 04_Archive/Ralph-Orchestrator.md  # parent: [[索引入口]]
│   └── 01-ralph-wiggum-technique.md   # parent: [[Ralph-Orchestrator]]
└── 03_Resources/微信读书.md    # parent: [[索引入口]]
    └── 原子习惯.md              # parent: [[微信读书]]
```

### 新建专题文档时的操作步骤

1. **创建专题索引文件**（如 `04_Archive/专题名.md`）
   - 添加 frontmatter，包含 `parent: "[[索引入口]]"`
   - 写明主题概述和文档目录

2. **为子文档添加 parent**
   - 在每个子文档的 frontmatter 中添加 `parent: "[[专题名]]"`

### 检查和维护

定期检查链接完整性：
- 搜索 `^parent:` 确保所有文档都有 parent
- 确保索引文件位于同级目录
- 验证 parent 指向正确存在

---

*此配置文件由 Claudesidian 初始化向导生成*
