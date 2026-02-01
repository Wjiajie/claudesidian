---
title: 如何使用LLMware开始学习RAG | ponder
source: https://www.jiajiewu.top/blog/how-to-start-learn-rag-with-llmware
author: 
published: 2025-03-08
created: 2025-03-12
description: 本指南将帮助您系统地学习如何使用llmware构建RAG应用，从基础概念到高级技术，涵盖环境设置、知识库创建、嵌入向量构建等内容。
tags:
  - clippings
parent: "[[技术栈]]"
---
![screenshot-20250308-180515.png](https://cdn.sa.net/2025/03/08/7ILDUeZ1c5npu2C.png)

==本指南将帮助您使用llmware仓库系统地学习检索增强生成（Retrieval-Augmented Generation，RAG）技术。llmware是一个强大的框架，提供了构建RAG应用所需的所有组件，从文档解析、嵌入生成到检索和生成。==

1. **克隆仓库**：

```prism
git clone https://github.com/llmware-ai/llmware.git
cd llmware
```
2. **设置Python环境**：

```prism
# 使用Python 3.9-3.13
# 如果使用pyenv
pyenv install 3.10.x
pyenv local 3.10.x

# 或使用系统Python
export PYTHONPATH=$PYTHONPATH:$(pwd)
```
3. **安装依赖**：

```prism
# 使用国内镜像源安装基本依赖
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple numpy huggingface-hub tokenizers boto3 colorama
```

1. **创建和管理知识库**

- 学习文件：`fast_start/rag/example-1-create_first_library.py`
- 核心概念：Library（知识库）、文档解析、文本分块
- 运行命令：`python fast_start/rag/example-1-create_first_library.py`
- 学习目标：理解如何创建知识库并导入文档
2. **构建嵌入向量**

- 学习文件：`fast_start/rag/example-2-build_embeddings.py`
- 核心概念：嵌入模型、向量数据库、语义索引
- 运行命令：`python fast_start/rag/example-2-build_embeddings.py`
- 学习目标：理解如何为文档创建嵌入向量并存储在向量数据库中
3. **使用提示和模型**

- 学习文件：`fast_start/rag/example-3-prompts_and_models.py`
- 核心概念：Prompt类、模型加载、推理
- 运行命令：`python fast_start/rag/example-3-prompts_and_models.py`
- 学习目标：理解如何使用不同的模型和提示模板

1. **基于文本的检索**

- 学习文件：`fast_start/rag/example-4-rag-text-query.py`
- 核心概念：文本查询、文档过滤、上下文整合
- 运行命令：`python fast_start/rag/example-4-rag-text-query.py`
- 学习目标：掌握基于关键词的文档检索和RAG流程
2. **基于语义的检索**

- 学习文件：`fast_start/rag/example-5-rag-semantic-query.py`
- 核心概念：语义查询、向量相似度、嵌入模型选择
- 运行命令：`python fast_start/rag/example-5-rag-semantic-query.py`
- 学习目标：掌握基于语义的文档检索和RAG流程
3. **多步骤查询**

- 学习文件：`fast_start/rag/example-6-rag-multi-step-query.py`
- 核心概念：多轮对话、上下文管理、状态保持
- 运行命令：`python fast_start/rag/example-6-rag-multi-step-query.py`
- 学习目标：理解如何构建多步骤的RAG流程

1. **混合检索方法**

- 学习文件：`examples/Retrieval/dual_pass_with_custom_filter.py`
- 核心概念：混合检索、自定义过滤器、精确度优化
- 运行命令：`python examples/Retrieval/dual_pass_with_custom_filter.py`
- 学习目标：掌握如何结合文本和语义检索以提高准确性
2. **检索结果整合到提示中**

- 学习文件：`examples/Prompts/prompt_with_sources.py`
- 核心概念：上下文整合、提示工程、来源管理
- 运行命令：`python examples/Prompts/prompt_with_sources.py`
- 学习目标：理解如何有效地将检索结果整合到提示中
3. **事实检查**

- 学习文件：`examples/Prompts/fact_checking.py`
- 核心概念：事实验证、证据检查、可靠性评估
- 运行命令：`python examples/Prompts/fact_checking.py`
- 学习目标：学习如何验证生成内容的准确性

1. **合同分析**

- 学习文件：`examples/Use_Cases/contract_analysis_on_laptop_with_bling_models.py`
- 核心概念：专业领域应用、信息提取、结构化输出
- 运行命令：`python examples/Use_Cases/contract_analysis_on_laptop_with_bling_models.py`
- 学习目标：理解RAG在专业领域的应用
2. **发票处理**

- 学习文件：`examples/Use_Cases/invoice_processing.py`
- 核心概念：文档解析、关键信息提取、结构化数据
- 运行命令：`python examples/Use_Cases/invoice_processing.py`
- 学习目标：掌握如何从半结构化文档中提取信息
3. **文档摘要**

- 学习文件：`examples/Prompts/document_summarizer.py`
- 核心概念：长文档处理、分块摘要、信息压缩
- 运行命令：`python examples/Prompts/document_summarizer.py`
- 学习目标：学习如何处理和总结长文档

- **BLING模型**：`examples/Models/bling_fast_start.py` - 了解小型RAG优化模型
- **DRAGON模型**：`examples/Models/dragon_gguf_fast_start.py` - 了解更强大的RAG模型
- **GGUF模型**：`examples/Models/chat_models_gguf_fast_start.py` - 了解量化模型在RAG中的应用

- **语义检索**：`examples/Retrieval/semantic_retrieval.py` - 深入了解语义检索
- **文本检索**：`examples/Retrieval/text_retrieval.py` - 深入了解文本检索
- **文档过滤**：`examples/Retrieval/document_filters.py` - 学习高级过滤技术

- **多嵌入模型**：`examples/Embedding/using_multiple_embeddings.py` - 学习如何比较和使用多种嵌入模型
- **大规模嵌入**：`examples/Embedding/docs2vecs_with_milvus-un_resolutions.py` - 学习如何处理大规模文档嵌入

完成RAG基础学习后，可以探索更高级的功能：

1. **函数调用**：

- 学习文件：`fast_start/rag/example-7-function-calls.py`
- 核心概念：结构化输出、工具使用、API集成
2. **代理**：

- 学习文件：`fast_start/rag/example-8-agents.py`
- 核心概念：自主代理、多步骤规划、工具使用
3. **Web服务集成**：

- 学习文件：`fast_start/rag/example-9-function-calls-with-web-services.py`
- 核心概念：外部API集成、实时数据、动态上下文

llmware提供了一系列视频教程，可以作为学习的补充：

- [RAG快速入门视频系列](https://www.youtube.com/playlist?list=PL1-dn33KwsmD7SB9iSO6vx4ZLRAWea1DB)
- [使用BLING在笔记本电脑上进行RAG](https://www.youtube.com/watch?v=JjgqOZ2v5oU)
- [使用LLMware进行合同分析的小型LLM](https://www.youtube.com/watch?v=8aV5p3tErP0)

1. **模型下载问题**：

- 模型默认保存在`~/llmware_data/model_repo/`目录
- 可以使用`ModelCatalog().set_model_repo_path()`更改位置
2. **数据库选择**：

- 快速开始推荐使用SQLite：`LLMWareConfig().set_active_db("sqlite")`
- 向量数据库推荐ChromaDB：`LLMWareConfig().set_vector_db("chromadb")`
3. **内存问题**：

- 使用较小的模型如`bling-tiny-llama-v0`
- 减小批处理大小：`batch_size=100`
- 限制结果数量：`result_count=10`

==通过按照本指南系统学习，您将掌握使用llmware构建RAG应用的全部技能。从基础组件到高级技术，再到实际应用案例，这个学习路径将帮助您全面理解RAG技术并能够应用到实际项目中。==

祝您学习愉快！
