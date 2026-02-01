---
标题: 我使用开源进行了深入的研究 — 您也可以！- Milvus 博客 --- I Built a Deep Research with Open Source—and So Can You! - Milvus Blog
url: https://milvus.io/blog/i-built-a-deep-research-with-open-source-so-can-you.md
创建时间: 2025-02-15 15:55
更新时间: 2025-02-15 15:55
笔记ID: HM9M6M7
收藏: false
划线数量: 1
标签: 
obsidianUIMode: preview
---

# 我使用开源进行了深入的研究 — 您也可以！- Milvus 博客 --- I Built a Deep Research with Open Source—and So Can You! - Milvus Blog 

## collectedBy
[[wucai汇总]]

> [阅读原文](https://milvus.io/blog/i-built-a-deep-research-with-open-source-so-can-you.md)
> [在五彩中查看](https://marker.dotalk.cn/#/?nx=HM9M6M7&vs=1)


## 划线列表

> [!Highlight] 
> <font color="#00F2B8">◇  </font> Why certainly! Let’s build our own “Deep Research”, running locally and with open-source tools. We’ll be armed with just a basic knowledge of Generative AI, common sense, a couple of spare hours, a GPU, and the open-source Milvus, DeepSeek R1, and LangChain.
> 为什么肯定！让我们构建自己的“深度研究”，在本地运行并使用开源工具。我们将只具备生成式 AI 的基本知识、常识、几个空闲时间、一个 GPU 以及开源 Milvus、DeepSeek R1 和 LangChain。

> ^be753a7



---


## 全文剪藏 %% fold %%
![](https://g1proxy.wimg.site/s2QOKeaYKlFluWVaUj17HB-kpfF9Q9CPGTio7Bt-Bpa0/https://assets.zilliz.com/deep_research_blog_image_95225226eb.png) 

Well actually, a minimally scoped agent that can reason, plan, use tools, etc. to perform research using Wikipedia. Still, not bad for a few hours of work…  
嗯，实际上，一个最小范围的代理，可以推理、计划、使用工具等来使用维基百科进行研究。不过，对于几个小时的工作来说还不错......

Unless you reside under a rock, in a cave, or in a remote mountain monastery, you will have heard about OpenAI’s release of Deep Research on Feb 2, 2025\. This new product promises to revolutionize how we answer questions requiring the synthesis of large amounts of diverse information.  
除非你住在岩石下、山洞里或偏远的山间修道院里，否则你一定听说过 OpenAI 将于 2025 年 2 月 2 日发布《深度研究》。这款新产品有望彻底改变我们回答需要综合大量不同信息的问题的方式。

You type in your query, select the Deep Research option, and the platform autonomously searches the web, performs reasoning on what it discovers, and synthesizes multiple sources into a coherent, fully-cited report. It takes several orders of magnitude longer to produce its output relative to a standard chatbot, but the result is more detailed, more informed, and more nuanced.  
您输入查询，选择 Deep Research 选项，平台会自动搜索 Web，根据发现的内容进行推理，并将多个来源综合成一份连贯的、完全引用的报告。相对于标准聊天机器人，生成其输出需要几个数量级的时间，但结果更详细、更明智、更细致。

But how does this technology work, and why is Deep Research a noticeable improvement over previous attempts (like Google’s Deep Research \- incoming trademark dispute alert)? We’ll leave the latter for a future post. As for the former, there is no doubt much “secret sauce” underlying Deep Research. We can glean a few details from OpenAI’s release post, which I summarize.  
但是这项技术是如何运作的，为什么 Deep Research 比以前的尝试有了明显的改进（比如 Google 的 Deep Research \- 传入商标争议警报）？我们将把后者留到以后的文章中。至于前者，毫无疑问，Deep Research 背后有很多“秘密武器”。我们可以从 OpenAI 的发布帖子中收集一些细节，我对此进行了总结。

**Deep Research exploits recent advances in foundation models specialized for reasoning tasks:  
Deep Research 利用了专门用于推理任务的基础模型的最新进展：** 

* “…fine-tuned on the upcoming OpenAI o3 reasoning model…”  
“…在即将推出的 OpenAI o3 推理模型上进行了微调......”
* “…leverages reasoning to search, interpret, and analyze massive amounts of text…”  
“…利用推理来搜索、解释和分析大量文本......”

**Deep Research makes use of a sophisticated agentic workflow with planning, reflection, and memory:  
Deep Research 利用了复杂的代理工作流程，包括规划、反思和记忆：** 

* “…learned to plan and execute a multi-step trajectory…”  
“…学会了规划和执行多步骤的轨迹......”
* “…backtracking and reacting to real-time information…”  
“…回溯并对实时信息做出反应......”
* “…pivoting as needed in reaction to information it encounters…”  
“…根据需要调整以响应它遇到的信息......”

**Deep Research is trained on proprietary data, using several types of fine-tuning, which is likely a key component in its performance:  
Deep Research 基于专有数据进行训练，使用多种类型的微调，这可能是其性能的关键组成部分：** 

* “…trained using end-to-end reinforcement learning on hard browsing and reasoning tasks across a range of domains…”  
“…使用端到端强化学习对一系列领域的硬浏览和推理任务进行训练......”
* “…optimized for web browsing and data analysis…”  
“…针对 Web 浏览和数据分析进行了优化...”

The exact design of the agentic workflow is a secret, however, we can build something ourselves based on well-established ideas about how to structure agents.  
代理工作流程的确切设计是一个秘密，但是，我们可以根据关于如何构建代理的既定想法自己构建一些东西。

**One note before we begin** : It is easy to be swept away by Generative AI fever, especially when a new product that seems a step-improvement is released. However, Deep Research, as OpenAI acknowledges, has limitations common to Generative AI technology. We should remember to think critically about the output in that it may contain false facts (“hallucinations”), incorrect formatting and citations, and vary significantly in quality based on the random seed.  
**在我们开始之前，需要注意** 一点：很容易被生成式 AI 热潮席卷，尤其是当一款看似逐步改进的新产品发布时。然而，正如 OpenAI 所承认的那样，Deep Research 具有生成式 AI 技术共有的局限性。我们应该记住批判性地思考输出，因为它可能包含虚假事实（“幻觉”）、不正确的格式和引用，并且根据随机种子的质量有很大差异。

Why certainly! Let’s build our own “Deep Research”, running locally and with open-source tools. We’ll be armed with just a basic knowledge of Generative AI, common sense, a couple of spare hours, a GPU, and the open-source [Milvus](https://milvus.io/docs), [DeepSeek R1](https://huggingface.co/unsloth/DeepSeek-R1-Distill-Llama-8B-unsloth-bnb-4bit), and [LangChain](https://python.langchain.com/docs/introduction/)  
为什么肯定！让我们构建自己的“深度研究”，在本地运行并使用开源工具。我们将只具备生成式 AI 的基本知识、常识、几个小时的空闲时间、一个 GPU，以及开源的[Milvus](https://milvus.io/docs)[DeepSeek R1](https://huggingface.co/unsloth/DeepSeek-R1-Distill-Llama-8B-unsloth-bnb-4bit) 和[LangChain](https://python.langchain.com/docs/introduction/).  
为什么肯定！让我们构建自己的“深度研究”，在本地运行并使用开源工具。我们将只具备生成式 AI 的基本知识、常识、几个空闲时间、一个 GPU 以及开源 [Milvus](https://milvus.io/docs)、[DeepSeek R1](https://huggingface.co/unsloth/DeepSeek-R1-Distill-Llama-8B-unsloth-bnb-4bit) 和 [LangChain](https://python.langchain.com/docs/introduction/)。

We cannot hope to replicate OpenAI’s performance of course, but our prototype will minimally demonstrate some of the key ideas likely underlying their technology, combining advances in reasoning models with advances in agentic workflows. Importantly, and unlike OpenAI, we will be using only open-source tools, and be able to deploy our system locally - open-source certainly provides us great flexibility!  
当然，我们不能希望复制 OpenAI 的性能，但我们的原型将至少展示可能支撑其技术的一些关键思想，将推理模型的进步与代理工作流程的进步相结合。重要的是，与 OpenAI 不同的是，我们将仅使用开源工具，并且能够在本地部署我们的系统 - 开源无疑为我们提供了极大的灵活性！

We will make a few simplifying assumptions to reduce the scope of our project:  
我们将做一些简化的假设来缩小我们的项目范围：

* We will use an open-source reasoning mode distilled then [quantized](https://zilliz.com/learn/unlock-power-of-vector-quantization-techniques-for-efficient-data-compression-and-retrieval) for 4-bits that can be run locally.  
我们将使用一种开源推理模式，该模式经过提炼，然后[量化](https://zilliz.com/learn/unlock-power-of-vector-quantization-techniques-for-efficient-data-compression-and-retrieval)为可在本地运行的 4 位。
* We will not perform additional fine-tuning on our reasoning model ourselves.  
我们不会自己对推理模型进行额外的微调。
* The only tool our agent has is the ability to download and read a Wikipedia page and perform separate RAG queries (we will not have access to the entire web).  
我们的代理拥有的唯一工具是能够下载和阅读 Wikipedia 页面并执行单独的 RAG 查询（我们将无法访问整个网络）。
* Our agent will only process text data, not images, PDFs, etc.  
我们的代理将只处理文本数据，不会处理图像、PDF 等。
* Our agent will not backtrack or consider pivots.  
我们的代理不会回溯或考虑转向。
* Our agent will (not yet) control its execution flow based on its output.  
我们的代理将 （还） 根据其输出控制其执行流程。
* Wikipedia contains the truth, the whole truth and nothing but the truth.  
维基百科包含真理，全部真理，除了真理之外别无他物。

We will use [Milvus](https://milvus.io/docs) for our vector database, [DeepSeek R1](https://huggingface.co/unsloth/DeepSeek-R1-Distill-Llama-8B-unsloth-bnb-4bit) as our reasoning model, and [LangChain](https://python.langchain.com/docs/introduction/) to implement RAG. Let’s get started!  
我们将使用 [Milvus](https://milvus.io/docs) 作为我们的向量数据库，使用 [DeepSeek R1](https://huggingface.co/unsloth/DeepSeek-R1-Distill-Llama-8B-unsloth-bnb-4bit) 作为我们的推理模型，并使用 [LangChain](https://python.langchain.com/docs/introduction/) 来实现 RAG。让我们开始吧！

We will use our mental model of how humans conduct research to design the agentic workflow:  
我们将使用人类如何进行研究的心智模型来设计代理工作流程：

Research starts by defining a question. We take the question to be the user’s query, however, we use our reasoning model to ensure the question is expressed in a way that is specific, clear, and focused. That is, our first step is to rewrite the prompt and extract any subqueries or subquestions. We make effective use of our foundation models specialization for reasoning, and a simple method for JSON structured output.  
研究从定义问题开始。我们将问题视为用户的查询，但是，我们使用我们的推理模型来确保问题以具体、清晰和重点突出的方式表达。也就是说，我们的第一步是重写 prompt 并提取任何子查询或子问题。我们有效地利用了我们的基础模型专业化进行推理，并采用了一种简单的 JSON 结构化输出方法。

Here is an example reasoning trace as DeepSeek refines the question “How has the cast changed over time?”:  
以下是 DeepSeek 细化问题 “cast's how changed over time？”时的推理跟踪示例：


```text
<think>

Alright, so I need to break down the question "How has the cast changed over time?" related to the evolution of The Simpsons. Let me think about what aspects are involved here.

First, I know that the cast has changed a lot, but I need to figure out the intermediate questions to approach this. The main question is about changes in the cast over time, so I should consider different areas that contribute to this change.

I guess the first sub-question would be about the original cast members. Who were the main voices and how did they evolve? Then, there might be new cast additions over the years, so another sub-question about that.

Also, some original voice actors have left, so I should include a sub-question about departures. Then, new voice actors joining would be another point.

The show has been popular for a long time, so recurring roles changing might be another aspect. Additionally, the role of the show in society might have influenced casting choices, so a sub-question about that.

Lastly, the overall impact on the cast's careers could be another angle. So, I should list these as sub-questions to cover all aspects.

</think>

  
    
  

```


Next, we conduct a “literature review” of Wikipedia articles. For now, we read a single article and leave navigating links to a future iteration. We discovered during prototyping that link exploration can become very expensive if each link requires a call to the reasoning model. We parse the article, and store its data in our vector database, Milvus, akin to taking notes.  
接下来，我们对维基百科文章进行“文献综述”。现在，我们阅读一篇文章，并将导航链接留给未来的迭代。在原型设计过程中，我们发现，如果每个链接都需要调用推理模型，则链接探索可能会变得非常昂贵。我们解析文章，并将其数据存储在我们的矢量数据库 Milvus 中，类似于做笔记。

Here is a code snippet showing how we store our Wikipedia page in Milvus using its LangChain integration:  
下面是一个代码片段，展示了我们如何使用其 LangChain 集成将 Wikipedia 页面存储在 Milvus 中：


```python
wiki_wiki = wikipediaapi.Wikipedia(user_agent='MilvusDeepResearchBot (<insert your email>)', language='en')
page_py = wiki_wiki.page(page_title)

text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=200)
docs = text_splitter.create_documents([page_py.text])

vectorstore = Milvus.from_documents(  # or Zilliz.from_documents
    documents=docs,
    embedding=embeddings,
    connection_args={
        "uri": "./milvus_demo.db",
    },
    drop_old=True, 
    index_params={
        "metric_type": "COSINE",
        "index_type": "FLAT",  
        "params": {},
    },
)

  
    
  

```


The agent returns to its questions and answers them based on the relevant information in the document. We will leave a multi-step analysis/reflection workflow for future work, as well as any critical thinking on the credibility and bias of our sources.  
代理返回到其问题，并根据文档中的相关信息回答这些问题。我们将为未来的工作留下一个多步骤的分析/反思工作流程，以及对我们来源的可信度和偏见的任何批判性思考。

Here is a code snippet illustrating constructing a RAG with LangChain and answering our subquestions separately.  
这是一个代码片段，说明了如何使用 LangChain 构建 RAG 并分别回答我们的子问题。


```python
# Define the RAG chain for response generation
rag_chain = (
    {"context": retriever | format_docs, "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)

# Prompt the RAG for each question
answers = {}
total = len(leaves(breakdown))

pbar = tqdm(total=total)
for k, v in breakdown.items():
    if v == []:
        print(k)
        answers[k] = rag_chain.invoke(k).split('</think>')[-1].strip()
        pbar.update(1)
    else:
        for q in v:
            print(q)
            answers[q] = rag_chain.invoke(q).split('</think>')[-1].strip()
            pbar.update(1)

  
    
  

```


After the agent has performed its research, it creates a structured outline, or rather, a skeleton, of its findings to summarize in a report. It then completes each section, filling it in with a section title and the corresponding content. We leave a more sophisticated workflow with reflection, reordering, and rewriting for a future iteration. This part of the agent involves planning, tool usage, and memory.  
代理执行其研究后，它会创建其发现的结构化大纲，或者更确切地说，是其结果的框架，以在报告中进行总结。然后，它将完成每个部分，并在其中填写部分标题和相应的内容。我们将更复杂的工作流程留给未来的迭代，包括反射、重新排序和重写。代理的这一部分涉及规划、工具使用和内存。

See [accompanying notebook](https://drive.google.com/file/d/1waKX%5FNTgiY-47bYE0cI6qD8Cjn3zjrL6/view?usp=sharing) for the full code and the [saved report file](https://drive.google.com/file/d/15xeEe%5FEqY-29V2IlAvDy5yGdJdEPSHOh/view?usp=drive%5Flink) for example output.  
有关完整代码，请参阅[随附的 notebook](https://drive.google.com/file/d/1waKX%5FNTgiY-47bYE0cI6qD8Cjn3zjrL6/view?usp=sharing)，有关示例输出，请参阅[保存的报告文件](https://drive.google.com/file/d/15xeEe%5FEqY-29V2IlAvDy5yGdJdEPSHOh/view?usp=drive%5Flink)。

Our query for testing is “How has The Simpsons changed over time?” and the data source is the Wikipedia article for “The Simpsons”. Here is one section of the [generated report](https://drive.google.com/file/d/15xeEe%5FEqY-29V2IlAvDy5yGdJdEPSHOh/view?usp=sharing):  
我们用于测试的查询是“The Simpsons how change over time？”，数据源是“The Simpsons”的维基百科文章。以下是[生成的报告](https://drive.google.com/file/d/15xeEe%5FEqY-29V2IlAvDy5yGdJdEPSHOh/view?usp=sharing)的一部分：

![](https://g1proxy.wimg.site/siRNKUefPP2eN5mzMz0I9XIG3LSiwgD2j9zbOjiQibuI/https://assets.zilliz.com/result_query_424beba224.jpg) 

## Summary: What we built and what’s next  
摘要：我们构建了什么，下一步是什么

In just a few hours, we have designed a basic agentic workflow that can reason, plan, and retrieve information from Wikipedia to generate a structured research report. While this prototype is far from OpenAI’s Deep Research, it demonstrates the power of open-source tools like Milvus, DeepSeek, and LangChain in building autonomous research agents.  
在短短几个小时内，我们设计了一个基本的代理工作流程，可以从维基百科推理、计划和检索信息，以生成结构化的研究报告。虽然这个原型与 OpenAI 的 Deep Research 相去甚远，但它展示了 Milvus、DeepSeek 和 LangChain 等开源工具在构建自主研究代理方面的强大功能。

Of course, there’s plenty of room for improvement. Future iterations could:  
当然，还有很大的改进空间。未来的迭代可以：

* Expand beyond Wikipedia to search multiple sources dynamically  
扩展到 Wikipedia 之外，以动态搜索多个来源
* Introduce backtracking and reflection to refine responses  
引入回溯和反射以优化响应
* Optimize execution flow based on the agent’s own reasoning  
根据代理自身的推理优化执行流程

Open-source gives us flexibility and control that closed source doesn’t. Whether for academic research, content synthesis, or AI-powered assistance, building our own research agents open up exciting possibilities. Stay tuned for the next post where we explore adding real-time web retrieval, multi-step reasoning, and conditional execution flow!  
开源为我们提供了闭源所不具备的灵活性和控制力。无论是用于学术研究、内容合成还是 AI 驱动的帮助，构建我们自己的研究代理都开辟了令人兴奋的可能性。请继续关注下一篇文章，我们将探索添加实时 Web 检索、多步骤推理和条件执行流程！

* Notebook: “[_Baseline for An Open-Source Deep Research_](https://colab.research.google.com/drive/1W5tW8SqWXve7ZwbSb9pVdbt5R2wq105O?usp=sharing)”  
笔记本：“[_开源深入研究的基线_](https://colab.research.google.com/drive/1W5tW8SqWXve7ZwbSb9pVdbt5R2wq105O?usp=sharing)”
* Report: “[_The evolution of The Simpsons as a show over time, covering changes in content, humor, character development, animation, and its role in society._](https://drive.google.com/file/d/15xeEe%5FEqY-29V2IlAvDy5yGdJdEPSHOh/view?usp=drive%5Flink)”  
报告：“[_《辛普森一家》作为一个节目随着时间的推移而演变，涵盖内容、幽默、角色发展、动画及其在社会中的作用的变化。_](https://drive.google.com/file/d/15xeEe%5FEqY-29V2IlAvDy5yGdJdEPSHOh/view?usp=drive%5Flink)“
* [Milvus vector database documentation Milvus vector 数据库文档](https://milvus.io/docs)
* [Distilled and quantized DeepSeek R1 model page 提炼和量化的 DeepSeek R1 模型页面](https://huggingface.co/unsloth/DeepSeek-R1-Distill-Llama-8B-unsloth-bnb-4bit)
* [️🔗 LangChain 🔗 ️ LangChain 语言链](https://python.langchain.com/docs/introduction/)
* [Deep Research FAQ | OpenAI Help Center Deep Research 常见问题 |OpenAI 帮助中心](https://help.openai.com/en/articles/10500283-deep-research-faq)

Like the article? Spread the word  
喜欢这篇文章吗？传播信息
