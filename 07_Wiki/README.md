# 📖 Wiki

LLM 维护的知识编译层 — Claudesidian Vault 的第七层。

## Purpose

Wiki 是对 `00_Inbox` ~ `06_Metadata` 中所有原始笔记的**自动编译产物**。LLM 读取你的笔记，提取实体、概念、事实，交叉引用后形成结构化的知识图谱。

## What Lives Here

```
07_Wiki/
├── index.md       # 内容目录 (LLM 导航用)
├── log.md         # 操作日志 (时间线)
├── entities/      # 人物、工具、公司
├── concepts/      # 概念、框架、心智模型
├── sources/       # 源材料摘要
└── syntheses/     # 综合分析、对比研究
```

## Rules

1. **LLM 拥有此目录的写权限**。所有 wiki 页面由 LLM 创建和维护。
2. **人类只读**。你浏览 wiki 内容，在 Obsidian 图谱视图中探索联系。
3. **原始笔记不可变**。LLM 从 `00-06` 层读取，但绝不修改。
4. **所有修改需确认**。LLM 在写入前展示计划，等你批准。

## How It Works

- **Ingest**: 新笔记/文章 → LLM 创建摘要 + 更新实体/概念页 + 交叉引用
- **Query**: 你提问 → LLM 查 index → 综合回答 → 有价值的答案写回 wiki
- **Lint**: 定期健康检查 → 找孤立页、矛盾、缺失链接
- **Review**: 日/周回顾时自动将洞察持久化到 wiki

## Philosophy

> 知识库维护中最枯燥的不是阅读和思考，而是编目、交叉引用、保持一致性。LLM 不会厌烦这些工作。
