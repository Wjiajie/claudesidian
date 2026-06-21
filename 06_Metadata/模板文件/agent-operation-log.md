---
author: 吴家杰
category: 闪念胶囊
tags:
  - template
  - agent
  - log
parent: "[[索引入口]]"
---

# Agent Operation Log: {{date:YYYY-MM-DD}} {{time:HH:mm}}

> 每次 agent 自动修改知识库（创建/移动/修改/删除/frontmatter 变更）都应新建一份本模板的实例，沉淀操作记录便于回溯。
> 模板位置：`06_Metadata/模板文件/agent-operation-log.md`
> 配套工具：`06_Metadata/工具脚本/obsidian-cli.ps1`
> 速查表：`06_Metadata/A-202606061851-obsidian-cli.md`

---

## Context

<!-- 触发本次操作的用户请求 / 任务 / 调度信号 -->

- **Trigger**: 
- **Task / Session ID**: 
- **Date / Time**: {{date:YYYY-MM-DD}} {{time:HH:mm}}
- **Agent / Model**: 

## Operation Type

<!-- 选填，可多项 -->

- [ ] 创建 (`create`)
- [ ] 修改内容 (`append` / `prepend` / 全文重写)
- [ ] 修改 frontmatter (`property:set` / `set-property`)
- [ ] 移动 / 重命名 (`move` / `rename`)
- [ ] 删除 (`delete`)
- [ ] 批量操作（多个文件 / 多次调用）

## Files Affected

<!-- 列出本次操作涉及的所有文件 -->

| 路径 | 操作 | 风险等级 | 是否可回滚 |
|------|------|----------|------------|
| `00_Inbox/example.md` | 修改 | 中 | ✅ |
| | | | |

## Commands Executed

<!-- 粘贴实际执行的命令 (最好从 wrapper 日志里复制)，便于回放 -->

```powershell
# 例:
# & "06_Metadata/工具脚本/obsidian-cli.ps1" set-property `
#     -File "00_Inbox/example.md" `
#     -Name "tags" `
#     -Value "knowledge, demo" `
#     -Type list
```

## Changes Summary

<!-- 用自然语言描述变更要点。涉及多处文件时分段写。 -->

### Before
<!-- 改前状态（关键字段摘录即可） -->

### After
<!-- 改后状态 -->

## Risk Assessment

<!-- 评估本次操作的影响范围 -->
<!-- high = 改 frontmatter parent / 批量重命名 / 涉及多个笔记 / 删除 -->
<!-- medium = 改 tags / 改少量 frontmatter / append -->
<!-- low = 创建新笔记 / 改自己的操作日志 -->

- [ ] 高（影响索引、批量、删除）—— 需先 `-DryRun` 验证
- [ ] 中（改 frontmatter 字段、append）—— 建议备份
- [ ] 低（新建笔记、改本模板）—— 直接执行

## Rollback Plan

<!-- 如果操作错了，怎么回退 -->

- **手动回滚**: `obsidian rename` / `obsidian delete` / `Edit` 工具
- **Obsidian history**: 如果开了 sync，可以用 `obsidian history:restore` 还原
- **Git**: `git checkout` 对应文件
- **N/A**: 本操作是纯新增，可直接 `obsidian delete`

## Cross-References

<!-- 链接到相关资源 / 受影响的笔记 -->

- 速查表: `[[A-202606061851-obsidian-cli]]`
- Wrapper: `[[obsidian-cli]]`
- 受影响:
  - 
  - 

## Notes

<!-- 任何想留的备注：踩坑、未验证、todo 等 -->

- 

---

*End of log: Review with user before closing*
