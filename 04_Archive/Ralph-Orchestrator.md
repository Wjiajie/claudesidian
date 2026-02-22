---
author: 吴家杰
category: Ralph-Orchestrator
tags:
  - AI
  - 自动化
  - Claude Code
parent: "[[索引入口]]"
---

# Ralph-Orchestrator

> 基于 Claude Code 的 AI 自动化框架，让 AI 能够自主完成复杂任务

## 概述

Ralph-Orchestrator 是一个让 AI 自主完成任务的框架，核心思想是 **"Ralph 循环"**——像 Ralph Wiggum 一样，永不放弃，失败后重新尝试直到成功。

## 核心概念

| 文档 | 主题 | 简介 |
|------|------|------|
| 01 | Ralph Wiggum Technique | 核心循环技术，通过不断重试实现任务完成 |
| 02 | Fresh Context | 保持上下文新鲜，避免上下文膨胀 |
| 03 | Six Tenets | 六项原则指导框架设计 |
| 04 | Backpressure | 背压机制，管理任务流 |
| 05 | Hats System | 帽子系统，多角色切换 |
| 06 | Events Routing | 事件路由机制 |
| 07 | The Loop | 主循环机制 |
| 08 | Memory and State | 内存与状态管理 |
| 09 | The Scratchpad | 草稿板概念 |
| 10 | Skills | 技能系统 |
| 11 | Tasks Two Systems | 任务的双系统架构 |

## 核心理念

- **简单粗暴**：Ralph 就是一个 Bash 循环
- **确定性失败**：失败方式可预测，因此可修复
- **自主执行**：AI 能够自主决定下一步行动

## 相关资源

- 子文档：[[01-ralph-wiggum-technique]]、[[02-fresh-context]] 等
