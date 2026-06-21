# ⚙️ 工具脚本

> 知识库维护相关的 PowerShell / Python 脚本。配合 `06_Metadata/A-202606061851-obsidian-cli.md` 使用。

## 目录结构

```
06_Metadata/工具脚本/
├── README.md           # 本文件 (目录索引)
├── obsidian-cli.ps1    # Obsidian 1.12+ 官方 CLI 的 PowerShell 包装器
└── logs/               # wrapper 调用日志 (按日期分文件)
    └── obsidian-cli-yyyy-MM-dd.log
```

## 脚本列表

### `obsidian-cli.ps1`

Obsidian 1.12+ **官方**内置 CLI 的 PowerShell 包装器（不是社区 CLI）。

**作用**：
- 静默过滤启动 banner（`Loading updated app package...` + `Your Obsidian installer is out of date`）
- 强制 UTF-8 编码捕获 stdout（避免 PS 5.1 ANSI 编码吞中文）
- 提供 `-DryRun` 安全网（agent 操作知识库前先 dry-run 一次再确认）
- 自动写入调用日志到 `logs/obsidian-cli-yyyy-MM-dd.log`
- `-Json` 自动美化 JSON 输出
- 提供 `set-property` 子命令（绕过 1.12.7 `property:set` 命令的 bug，走原生 API）

**快速调用**：

```powershell
$w = "06_Metadata/工具脚本/obsidian-cli.ps1"

# 读
& $w read 'file=06_Metadata/README.md'

# 搜索 + JSON
& $w search 'query=obsidian' 'format=json' -Json

# 写 frontmatter (text)
& $w set-property -File '00_Inbox/2025-12-29.md' -Name 'tags' -Value 'demo' -Type text

# 写 frontmatter (list)
& $w set-property -File '00_Inbox/2025-12-29.md' -Name 'tags' -Value 'a, b, c' -Type list

# 危险操作前
& $w delete 'path=some/old/note.md' -DryRun
```

**完整文档**：见 `06_Metadata/A-202606061851-obsidian-cli.md`

**前置要求**：
- PowerShell 5.1+（Windows 自带；macOS / Linux 用 pwsh 7+）
- Obsidian 1.12+ 已安装并至少打开过一次（首次安装时 installer 注册 `obsidian` 命令到 PATH）
- 当前 vault 在 Obsidian 中已打开（写入操作需要；读取不强制）

## 使用建议

1. **任何写入操作前**先用 `-DryRun` 看会执行什么
2. **批量改 frontmatter** 时每条命令之间 `Start-Sleep -Seconds 1`，避免 Obsidian 内部状态冲突
3. **写完核对**用 `& $w read 'file=...'` 看实际写入
4. **回滚**用 `obsidian history:restore`（如果开了 sync）或 `git checkout` 或 `Edit` 工具
5. **写日志**：参考 `06_Metadata/模板文件/agent-operation-log.md`

## 添加新脚本

如果你要加新脚本到这个目录：

1. 文件命名风格：`kebab-case.ps1` / `kebab-case.py` / `kebab-case.sh`
2. 顶部加说明注释块（参考 `obsidian-cli.ps1` 的 `<#...#>` 块）
3. 在本 README 加一行简介
4. 复杂脚本另写 `06_Metadata/A-YYYYMMDDHHNN-<name>.md` 速查文档
