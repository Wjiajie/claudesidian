---
标题: LightRAG：简单快速的检索增强生成 --- LightRAG:Simple and Fast Retrieval-Augmented Generation
url: https://arxiv.org/html/2410.05779v2/
创建时间: 2024-12-24 12:57
更新时间: 2024-12-24 12:57
笔记ID: HM7D6FA
收藏: false
划线数量: 1
标签: 
obsidianUIMode: preview
---

# LightRAG：简单快速的检索增强生成 --- LightRAG:Simple and Fast Retrieval-Augmented Generation 

## collectedBy
[[wucai汇总]]

> [阅读原文](https://arxiv.org/html/2410.05779v2/)
> [在五彩中查看](https://marker.dotalk.cn/#/?nx=HM7D6FA&vs=1)


## 划线列表

> [!Highlight] 
> <font color="#A6FFE9">◇  </font> 实体使用其名称作为唯一的索引键，而关系可能具有从LLM增强功能派生的多个索引键，这些增强功能包括来自所连接实体的全局主题。

> ^b63me2e



---


## 全文剪藏 %% fold %%
HTML conversions [sometimes display errors](https://info.dev.arxiv.org/about/accessibility%5Fhtml%5Ferror%5Fmessages.html) due to content that did not convert correctly from the source. This paper uses the following packages that are not yet supported by the HTML conversion tool. Feedback on these issues are not necessary; they are known and are being worked on.

* failed: inconsolata
* failed: moresize
* failed: filecontents

Authors: achieve the best HTML results from your LaTeX submissions by following these [best practices](https://info.arxiv.org/help/submit%5Flatex%5Fbest%5Fpractices.html).

## LightRAG: Simple and Fast   
Retrieval-Augmented Generation  
LightRAG：简单快速 检索增强生成

Zirui Guo1,2, Lianghao Xia2, Yanhua Yu1, Tu Ao1, Chao Huang2   
Beijing University of Posts and Telecommunications1   
University of Hong Kong2   
zrguo101@hku.hk aka\_xia@foxmail.com chaohuang75@gmail.com 

###### Abstract 摘要

Retrieval-Augmented Generation (RAG) systems enhance large language models (LLMs) by integrating external knowledge sources, enabling more accurate and contextually relevant responses tailored to user needs. However, existing RAG systems have significant limitations, including reliance on flat data representations and inadequate contextual awareness, which can lead to fragmented answers that fail to capture complex inter-dependencies. To address these challenges, we propose LightRAG, which incorporates graph structures into text indexing and retrieval processes. This innovative framework employs a dual-level retrieval system that enhances comprehensive information retrieval from both low-level and high-level knowledge discovery. Additionally, the integration of graph structures with vector representations facilitates efficient retrieval of related entities and their relationships, significantly improving response times while maintaining contextual relevance. This capability is further enhanced by an incremental update algorithm that ensures the timely integration of new data, allowing the system to remain effective and responsive in rapidly changing data environments. Extensive experimental validation demonstrates considerable improvements in retrieval accuracy and efficiency compared to existing approaches. We have made our LightRAG open-source and available at the link: <https://github.com/HKUDS/LightRAG>.  
检索增强生成（Retrieval-Augmented Generation，RAG）系统通过集成外部知识源来增强大型语言模型（Large Language Model，LLMs），从而能够根据用户需求定制更准确且上下文相关的响应。然而，现有的RAG系统具有显著的局限性，包括依赖于平面数据表示和不充分的上下文感知，这可能导致无法捕获复杂的相互依赖性的碎片化答案。为了解决这些挑战，我们提出了LightRAG，它将图形结构纳入文本索引和检索过程。该创新框架采用了一个双层检索系统，从低级和高级知识发现两个方面增强了全面的信息检索。另外，图结构与向量表示的集成便于相关实体及其关系的高效检索，在保持上下文相关性的同时显著地改进了响应时间。 增量更新算法可确保及时整合新数据，从而使系统在快速变化的数据环境中保持高效和响应能力，从而进一步增强了这一能力。大量的实验验证表明，与现有方法相比，该方法在检索精度和效率上都有了显著的提高。我们已将LightRAG开源，可在以下链接获得：<https://github.com/HKUDS/LightRAG>。

## 1 Introduction  
1引言

Retrieval-Augmented Generation (RAG) systems have been developed to enhance large language models (LLMs) by integrating external knowledge sources Sudhi et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib16)); Es et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib5)); Salemi & Zamani ([2024](https://arxiv.org/html/2410.05779v2#bib.bib15)). This innovative integration allows LLMs to generate more accurate and contextually relevant responses, significantly improving their utility in real-world applications. By adapting to specific domain knowledge Tu et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib18)), RAG systems ensure that the information provided is not only pertinent but also tailored to the user’s needs. Furthermore, they offer access to up-to-date information Zhao et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib21)), which is crucial in rapidly evolving fields. Chunking plays a vital role in facilitating the retrieval-augmented generation process Lyu et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib11)). By breaking down a large external text corpus into smaller, more manageable segments, chunking significantly enhances the accuracy of information retrieval. This approach allows for more targeted similarity searches, ensuring that the retrieved content is directly relevant to user queries.  
检索增强生成（RAG）系统已被开发出来，通过集成外部知识源来增强大型语言模型（LLMs）Sudhi等人（[2024](https://arxiv.org/html/2410.05779v2#bib.bib16)）; Es等人（[2024](https://arxiv.org/html/2410.05779v2#bib.bib5)）; Salemi Zamani（[2024](https://arxiv.org/html/2410.05779v2#bib.bib15)）。这种创新的集成允许LLMs生成更准确和上下文相关的响应，显着提高其在现实世界中的应用程序的效用。通过适应特定的领域知识Tu et al.（[2024](https://arxiv.org/html/2410.05779v2#bib.bib18)），RAG系统确保提供的信息不仅相关，而且适合用户的需求。此外，它们还提供了最新信息的访问Zhao et al.（[2024](https://arxiv.org/html/2410.05779v2#bib.bib21)），这在快速发展的领域中至关重要。组块在促进检索增强生成过程中起着至关重要的作用Lyu et al.（[2024](https://arxiv.org/html/2410.05779v2#bib.bib11)）。 通过将大型外部文本语料库分解为更小、更易于管理的片段，组块显著提高了信息检索的准确性。这种方法允许更有针对性的相似性搜索，确保检索到的内容与用户查询直接相关。

However, existing RAG systems have key limitations that hinder their performance. First, many methods rely on flat data representations, restricting their ability to understand and retrieve information based on intricate relationships between entities. Second, these systems often lack the contextual awareness needed to maintain coherence across various entities and their interrelations, resulting in responses that may not fully address user queries. For example, consider a user asking, “How does the rise of electric vehicles influence urban air quality and public transportation infrastructure?” Existing RAG methods might retrieve separate documents on electric vehicles, air pollution, and public transportation challenges but struggle to synthesize this information into a cohesive response. They may fail to explain how the adoption of electric vehicles can improve air quality, which in turn could affect public transportation planning. As a result, the user may receive a fragmented answer that does not adequately capture the complex inter-dependencies among these topics.  
然而，现有的RAG系统具有阻碍其性能的关键限制。首先，许多方法依赖于平面数据表示，这限制了它们基于实体之间复杂关系理解和检索信息的能力。其次，这些系统通常缺乏维持各个实体及其相互关系之间的一致性所需的上下文意识，导致响应可能无法完全解决用户查询。例如，考虑用户询问“电动汽车的兴起如何影响城市空气质量和公共交通基础设施？”现有的RAG方法可能会检索关于电动汽车、空气污染和公共交通挑战的单独文档，但很难将这些信息综合到一个有凝聚力的响应中。他们可能无法解释电动汽车的采用如何改善空气质量，这反过来可能会影响公共交通规划。 结果，用户可能接收到不充分地捕捉这些主题之间的复杂的相互依赖性的片段化回答。

To address these limitations, we propose incorporating graph structures into text indexing and relevant information retrieval. Graphs are particularly effective at representing the interdependencies among different entities Rampášek et al. ([2022](https://arxiv.org/html/2410.05779v2#bib.bib14)), which enables a more nuanced understanding of relationships. The integration of graph-based knowledge structures facilitates the synthesis of information from multiple sources into coherent and contextually rich responses. Despite these advantages, developing a fast and scalable graph-empowered RAG system that efficiently handles varying query volumes is crucial. In this work, we achieve an effective and efficient RAG system by addressing three key challenges: i) Comprehensive Information Retrieval. Ensuring comprehensive information retrieval that captures the full context of inter-dependent entities from all documents; ii) Enhanced Retrieval Efficiency. Improving retrieval efficiency over the graph-based knowledge structures to significantly reduce response times; iii) Rapid Adaptation to New Data. Enabling quick adaptation to new data updates, ensuring the system remains relevant in dynamic environments.  
为了解决这些局限性，我们建议将图形结构的文本索引和相关的信息检索。图在表示不同实体之间的相互依赖性方面特别有效，Rampášek et al.（[2022](https://arxiv.org/html/2410.05779v2#bib.bib14)），这使得人们能够更细致地理解关系。基于图的知识结构的集成有助于将来自多个源的信息合成为连贯且上下文丰富的响应。尽管有这些优点，但开发一个快速、可扩展的、支持图的RAG系统来有效地处理变化的查询量仍然是至关重要的。在这项工作中，我们实现了一个有效和高效的RAG系统，通过解决三个关键挑战：i）全面的信息检索。确保全面的信息检索，从所有文档中捕获相互依赖的实体的完整上下文; ii）提高检索效率。 在基于图的知识结构上提高检索效率，以显著减少响应时间; iii）对新数据的快速适应。支持快速适应新的数据更新，确保系统在动态环境中保持相关性。

In response to the outlined challenges, we propose LightRAG, a model that seamlessly integrates a graph-based text indexing paradigm with a dual-level retrieval framework. This innovative approach enhances the system’s capacity to capture complex inter-dependencies among entities, resulting in more coherent and contextually rich responses. LightRAG employs efficient dual-level retrieval strategies: low-level retrieval, which focuses on precise information about specific entities and their relationships, and high-level retrieval, which encompasses broader topics and themes. By combining both detailed and conceptual retrieval, LightRAG effectively accommodates a diverse range of quries, ensuring that users receive relevant and comprehensive responses tailored to their specific needs. Additionally, by integrating graph structures with vector representations, our framework facilitates efficient retrieval of related entities and relations while enhancing the comprehensiveness of results through relevant structural information from the constructed knowledge graph.  
为了应对上述挑战，我们提出了LightRAG模型，它将基于图的文本索引范式与双层检索框架无缝集成。这一创新方法增强了系统捕捉实体间复杂的相互依赖关系的能力，从而产生更加连贯和内容丰富的响应。LightRAG采用了高效的双层检索策略：低层检索，关注关于特定实体及其关系的精确信息;高层检索，包含更广泛的主题。通过将详细检索和概念检索相结合，LightRAG有效地适应了各种各样的查询，确保用户收到针对其特定需求的相关和全面的响应。 此外，通过将图结构与向量表示相结合，该框架有助于高效地检索相关实体和关系，同时通过来自所构造的知识图的相关结构信息来增强结果的全面性。

In summary, the key contributions of this work are highlighted as follows:  
总之，这项工作的主要贡献突出如下：

* •  
General Aspect. We emphasize the importance of developing a graph-empowered RAG system to overcome the limitations of existing methods. By integrating graph structures into text indexing, we can effectively represent complex interdependencies among entities, fostering a nuanced understanding of relationships and enabling coherent, contextually rich responses.  
    
·总体方面。我们强调了开发一个基于图的RAG系统以克服现有方法的局限性的重要性。通过将图结构集成到文本索引中，我们可以有效地表示实体之间复杂的相互依赖关系，促进对关系的细微理解，并实现连贯、上下文丰富的响应。
* •  
Methodologies. To enable an efficient and adaptive RAG system, we propose LightRAG, which integrates a dual-level retrieval paradigm with graph-enhanced text indexing. This approach captures both low-level and high-level information for comprehensive, cost-effective retrieval. By eliminating the need to rebuild the entire index, LightRAG reduces computational costs and accelerates adaptation, while its incremental update algorithm ensures timely integration of new data, maintaining effectiveness in dynamic environments.  
    
方法。为了实现一个高效、自适应的RAG系统，我们提出了LightRAG，它集成了两级检索范式和图增强文本索引。此方法可捕获低级别和高级别信息，以实现全面、经济高效的检索。LightRAG无需重建整个索引，从而降低了计算成本并加快了适应速度，同时其增量更新算法可确保及时整合新数据，从而保持在动态环境中的有效性。
* •  
Experimental Findings. Extensive experiments were conducted to evaluate the effectiveness of LightRAG in comparison to existing RAG models. These assessments focused on several key dimensions, including retrieval accuracy, model ablation, response efficiency, and adaptability to new information. The results demonstrated significant improvements over baseline methods.  
    
·实验发现。进行了大量的实验，以评估LightRAG的有效性相比，现有的RAG模型。这些评估侧重于几个关键维度，包括检索准确性、模型消融、反应效率和对新信息的适应性。结果表明，与基线方法相比，有显著改善。

## 2 Retrieval-Augmented Generation  
2检索增强生成

Retrieval-Augmented Generation (RAG) integrates user queries with a collection of pertinent documents sourced from an external knowledge database, incorporating two essential elements: the Retrieval Component and the Generation Component. 1) The retrieval component is responsible for fetching relevant documents or information from the external knowledge database. It identifies and retrieves the most pertinent data based on the input query. 2) After the retrieval process, the generation component takes the retrieved information and generates coherent, contextually relevant responses. It leverages the capabilities of the language model to produce meaningful outputs. Formally, this RAG framework, denoted as ℳℳ\\mathcal{M}caligraphic\_M, can be defined as follows:  
检索增强生成（RAG）将用户查询与来自外部知识数据库的相关文档集合集成在一起，包含两个基本元素：检索组件和生成组件。1)检索组件负责从外部知识数据库中获取相关文档或信息。它根据输入查询识别和检索最相关的数据。2)在检索过程之后，生成组件获取检索到的信息并生成连贯的、上下文相关的响应。它利用语言模型的功能来产生有意义的输出。形式上，这个RAG框架，表示为 ℳ\\mathcal{M}caligraphic\_M ，可以定义如下：

| ℳ\=(𝒢,ℛ\=(φ,ψ)),ℳ⁢(q;𝒟)\=𝒢⁢(q,ψ⁢(q;𝒟^)),𝒟^\=φ⁢(𝒟)formulae-sequenceℳ𝒢ℛ𝜑𝜓formulae-sequenceℳ𝑞𝒟𝒢𝑞𝜓𝑞^𝒟^𝒟𝜑𝒟\\displaystyle\\mathcal{M}=\\Big{(}\\mathcal{G},\\leavevmode\\nobreak\\ \\leavevmode% \\nobreak\\ \\mathcal{R}=(\\varphi,\\psi)\\Big{)},\\leavevmode\\nobreak\\ \\leavevmode% \\nobreak\\ \\leavevmode\\nobreak\\ \\mathcal{M}(q;\\mathcal{D})=\\mathcal{G}\\Big{(}q,% \\psi(q;\\hat{\\mathcal{D}})\\Big{)},\\leavevmode\\nobreak\\ \\leavevmode\\nobreak\\ % \\leavevmode\\nobreak\\ \\hat{\\mathcal{D}}=\\varphi(\\mathcal{D})caligraphic\_M = ( caligraphic\_G , caligraphic\_R = ( italic\_φ , italic\_ψ ) ) , caligraphic\_M ( italic\_q ; caligraphic\_D ) = caligraphic\_G ( italic\_q , italic\_ψ ( italic\_q ; over^ start\_ARG caligraphic\_D end\_ARG ) ) , over^ start\_ARG caligraphic\_D end\_ARG = italic\_φ ( caligraphic\_D ) | (1) |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |

In this framework, 𝒢𝒢\\mathcal{G}caligraphic\_G and ℛℛ\\mathcal{R}caligraphic\_R represent the generation module and the retrieval module, respectively, while q𝑞qitalic\_q denotes the input query and D𝐷Ditalic\_D refers to the external database. The retrieval module ℛℛ\\mathcal{R}caligraphic\_R includes two key functionalities: i) Data Indexer φ⁢(⋅)𝜑⋅\\varphi(\\cdot)italic\_φ ( ⋅ ): which involves building a specific data structure 𝒟^^𝒟\\hat{\\mathcal{D}}over^ start\_ARG caligraphic\_D end\_ARG based on the external database D𝐷Ditalic\_D. ii) Data Retriever ψ⁢(⋅)𝜓⋅\\psi(\\cdot)italic\_ψ ( ⋅ ): The relevant documents are obtained by comparing the query against the indexed data, also denoted as “relevant documents”. By leveraging the information retrieved through ψ⁢(⋅)𝜓⋅\\psi(\\cdot)italic\_ψ ( ⋅ ) along with the initial query q𝑞qitalic\_q, the generative model 𝒢⁢(⋅)𝒢⋅\\mathcal{G}(\\cdot)caligraphic\_G ( ⋅ ) efficiently produces high-quality, contextually relevant responses.  
在这个框架中， 𝒢\\mathcal{G}caligraphic\_G 和 ℛ\\mathcal{R}caligraphic\_R 分别表示生成模块和检索模块，而 qqitalic\_q 表示输入查询， DDitalic\_D 表示外部数据库。检索模块 ℛ\\mathcal{R}caligraphic\_R 包括两个关键功能：i）数据索引器 φ⁢(⋅)\\varphi(\\cdot)italic\_φ ( ⋅ ) ：其涉及基于外部数据库 DDitalic\_D 构建特定数据结构 𝒟^\\hat{\\mathcal{D}}over^ start\_ARG caligraphic\_D end\_ARG 。ii）数据检索器 ψ⁢(⋅)\\psi(\\cdot)italic\_ψ ( ⋅ ) ：通过将查询与索引数据进行比较来获得相关文档，也被表示为“相关文档”。通过利用通过 ψ⁢(⋅)\\psi(\\cdot)italic\_ψ ( ⋅ ) 连同初始查询 qqitalic\_q 沿着检索的信息，生成模型 𝒢⁢(⋅)\\mathcal{G}(\\cdot)caligraphic\_G ( ⋅ ) 有效地产生高质量的、上下文相关的响应。

In this work, we target several key points essential for an efficient and effective Retrieval-Augmented Generation (RAG) system which are elaborated below:  
在这项工作中，我们针对高效和有效的检索增强生成（RAG）系统所必需的几个关键点，详细说明如下：

* •  
Comprehensive Information Retrieval: The indexing function φ⁢(⋅)𝜑⋅\\varphi(\\cdot)italic\_φ ( ⋅ ) must be adept at extracting global information, as this is crucial for enhancing the model’s ability to answer queries effectively.  
    
·综合信息检索：索引函数 φ⁢(⋅)\\varphi(\\cdot)italic\_φ ( ⋅ ) 必须擅长提取全局信息，因为这对于增强模型有效回答查询的能力至关重要。
* •  
Efficient and Low-Cost Retrieval: The indexed data structure 𝒟^^𝒟\\hat{\\mathcal{D}}over^ start\_ARG caligraphic\_D end\_ARG must enable rapid and cost-efficient retrieval to effectively handle a high volume of queries.  
    
·高效和低成本的检索：索引数据结构 𝒟^\\hat{\\mathcal{D}}over^ start\_ARG caligraphic\_D end\_ARG 必须支持快速和经济高效的检索，以有效地处理大量的查询。
* •  
Fast Adaptation to Data Changes: The ability to swiftly and efficiently adjust the data structure to incorporate new information from the external knowledge base, is crucial for ensuring that the system remains current and relevant in an ever-changing information landscape.  
    
快速适应数据变化：快速有效地调整数据结构以纳入外部知识库中的新信息的能力，对于确保系统在不断变化的信息环境中保持最新和相关性至关重要。

## 3 The LightRAG Architecture  
3LightRAG架构

![Refer to caption](https://g1proxy.wimg.site/sjQ0KM_3-n_OtitxttLNfVz3Gh8ejvyzQ3gp-H-MlzBM/https://arxiv.org/html/2410.05779v2/x1.png) 

Figure 1: Overall architecture of the proposed LightRAG framework.  
图1：LightRAG框架的整体架构。

### 3.1 Graph-based Text Indexing  
3.1基于图的文本索引

Graph-Enhanced Entity and Relationship Extraction. Our LightRAG enhances the retrieval system by segmenting documents into smaller, more manageable pieces. This strategy allows for quick identification and access to relevant information without analyzing entire documents. Next, we leverage LLMs to identify and extract various entities (e.g., names, dates, locations, and events) along with the relationships between them. The information collected through this process will be used to create a comprehensive knowledge graph that highlights the connections and insights across the entire collection of documents. We formally represent this graph generation module as follows:  
图形增强的实体和关系提取。我们的LightRAG通过将文档分割成更小、更易于管理的片段来增强检索系统。该策略允许快速识别和访问相关信息，而无需分析整个文档。接下来，我们利用LLMs来识别和提取各种实体（例如，名称、日期、位置和事件）沿着它们之间的关系。通过此流程收集的信息将用于创建一个全面的知识图表，突出整个文档集之间的联系和见解。我们将该图生成模块正式表示如下：

| 𝒟^\=(𝒱^,ℰ^)\=Dedupe∘Prof⁢(𝒱,ℰ),𝒱,ℰ\=∪𝒟i∈𝒟Recog⁢(𝒟i)formulae-sequence^𝒟^𝒱^ℰDedupeProf𝒱ℰ𝒱ℰsubscriptsubscript𝒟𝑖𝒟Recogsubscript𝒟𝑖\\displaystyle\\hat{\\mathcal{D}}=(\\hat{\\mathcal{V}},\\hat{\\mathcal{E}})=\\text{% Dedupe}\\circ\\text{Prof}(\\mathcal{V},\\mathcal{E}),\\leavevmode\\nobreak\\ % \\leavevmode\\nobreak\\ \\leavevmode\\nobreak\\ \\mathcal{V},\\mathcal{E}=\\cup\_{% \\mathcal{D}\_{i}\\in\\mathcal{D}}\\text{Recog}(\\mathcal{D}\_{i})over^ start\_ARG caligraphic\_D end\_ARG = ( over^ start\_ARG caligraphic\_V end\_ARG , over^ start\_ARG caligraphic\_E end\_ARG ) = Dedupe ∘ Prof ( caligraphic\_V , caligraphic\_E ) , caligraphic\_V , caligraphic\_E = ∪ start\_POSTSUBSCRIPT caligraphic\_D start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT ∈ caligraphic\_D end\_POSTSUBSCRIPT Recog ( caligraphic\_D start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT ) | (2) |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |

where 𝒟^^𝒟\\hat{\\mathcal{D}}over^ start\_ARG caligraphic\_D end\_ARG represents the resulting knowledge graphs. To generate this data, we apply three main processing steps to the raw text documents 𝒟isubscript𝒟𝑖\\mathcal{D}\_{i}caligraphic\_D start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT. These steps utilize a LLM for text analysis and processing. Details about the prompt templates and specific settings for this part can be found in Appendix [7.3.2](https://arxiv.org/html/2410.05779v2#S7.SS3.SSS2 "7.3.2 Prompts for Query Generation ‣ 7.3 Overview of the Prompts Used in LightRAG ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"). The functions used in our graph-based text indexing paradigm are described as:  
其中 𝒟^\\hat{\\mathcal{D}}over^ start\_ARG caligraphic\_D end\_ARG 表示所得到的知识图。为了生成此数据，我们对原始文本文档 𝒟isubscript\\mathcal{D}\_{i}caligraphic\_D start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT 应用三个主要处理步骤。这些步骤利用LLM进行文本分析和处理。LLM关于此部分的提示模板和具体设置的详细信息可参见附录7.3.2。在我们的基于图的文本索引范例中使用的函数被描述为：

* •  
Extracting Entities and Relationships. R⁢(⋅)R⋅\\text{R}(\\cdot)R ( ⋅ ): This function prompts a LLM to identify entities (nodes) and their relationships (edges) within the text data. For instance, it can extract entities like "Cardiologists" and "Heart Disease," and relationships such as "Cardiologists diagnose Heart Disease" from the text: "Cardiologists assess symptoms to identify potential heart issues." To improve efficiency, the raw text 𝒟𝒟\\mathcal{D}caligraphic\_D is segmented into multiple chunks 𝒟isubscript𝒟𝑖\\mathcal{D}\_{i}caligraphic\_D start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT.  
    
·提取实体和关系。 R⁢(⋅)\\text{R}(\\cdot)R ( ⋅ ) ：该函数提示LLM识别文本数据中的实体（节点）及其关系（边）。LLM例如，它可以从文本中提取"心脏病专家"和"心脏病"等实体，以及"心脏病专家诊断心脏病"等关系："心脏病专家评估症状以识别潜在的心脏问题。为了提高效率，原始文本 𝒟\\mathcal{D}caligraphic\_D 被分割成多个块 𝒟isubscript\\mathcal{D}\_{i}caligraphic\_D start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT 。
* •  
LLM Profiling for Key-Value Pair Generation. P⁢(⋅)P⋅\\text{P}(\\cdot)P ( ⋅ ): We employ a LLM-empowered profiling function, P⁢(⋅)P⋅\\text{P}(\\cdot)P ( ⋅ ), to generate a text key-value pair (K,V)𝐾𝑉(K,V)( italic\_K , italic\_V ) for each entity node in 𝒱𝒱\\mathcal{V}caligraphic\_V and relation edge in ℰℰ\\mathcal{E}caligraphic\_E. Each index key is a word or short phrase that enables efficient retrieval, while the corresponding value is a text paragraph summarizing relevant snippets from external data to aid in text generation. Entities use their names as the sole index key, whereas relations may have multiple index keys derived from LLM enhancements that include global themes from connected entities.  
    
·用于生成键值对LLM分析。 P⁢(⋅)\\text{P}(\\cdot)P ( ⋅ ) ：我们采用LLM授权的剖析函数 P⁢(⋅)\\text{P}(\\cdot)P ( ⋅ ) 来为 𝒱\\mathcal{V}caligraphic\_V 中的每个实体节点和 ℰ\\mathcal{E}caligraphic\_E 中的关系边生成文本键值对 (K,V)(K,V)( italic\_K , italic\_V ) 。每个索引关键字都是一个词或短语，可实现高效检索，而相应的值是一个文本段落，概括了外部数据中的相关片段，以帮助生成文本。实体使用其名称作为唯一的索引键，而关系可能具有从LLM增强功能派生的多个索引键，这些增强功能包括来自所连接实体的全局主题。
* •  
Deduplication to Optimize Graph Operations. D⁢(⋅)D⋅\\text{D}(\\cdot)D ( ⋅ ): Finally, we implement a deduplication function, D⁢(⋅)D⋅\\text{D}(\\cdot)D ( ⋅ ), that identifies and merges identical entities and relations from different segments of the raw text 𝒟isubscript𝒟𝑖\\mathcal{D}\_{i}caligraphic\_D start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT. This process effectively reduces the overhead associated with graph operations on 𝒟^^𝒟\\hat{\\mathcal{D}}over^ start\_ARG caligraphic\_D end\_ARG by minimizing the graph’s size, leading to more efficient data processing.  
    
·通过重复数据删除优化图形操作。第0号：最后，我们实现了一个重复数据删除功能 D⁢(⋅)\\text{D}(\\cdot)D ( ⋅ ) ，它可以从原始文本 𝒟isubscript\\mathcal{D}\_{i}caligraphic\_D start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT 的不同片段中识别和合并相同的实体和关系。这个过程通过最小化图的大小有效地减少了与 𝒟^\\hat{\\mathcal{D}}over^ start\_ARG caligraphic\_D end\_ARG 上的图操作相关联的开销，从而导致更有效的数据处理。

Our LightRAG offers two advantages through its graph-based text indexing paradigm. First, Comprehensive Information Understanding. The constructed graph structures enable the extraction of global information from multi-hop subgraphs, greatly enhancing LightRAG’s ability to handle complex queries that span multiple document chunks. Second, Enhanced Retrieval Performance. the key-value data structures derived from the graph are optimized for rapid and precise retrieval. This provides a superior alternative to less accurate embedding matching methods (Gao et al., [2023](https://arxiv.org/html/2410.05779v2#bib.bib8)) and inefficient chunk traversal techniques (Edge et al., [2024](https://arxiv.org/html/2410.05779v2#bib.bib4)) commonly used in existing approaches.  
我们的LightRAG通过其基于图的文本索引范式提供了两个优势。一是全面了解信息。构建的图结构能够从多跳子图中提取全局信息，大大增强了LightRAG处理跨多个文档块的复杂查询的能力。第二，提高检索性能。从图中导出的关键字-值数据结构被优化用于快速和精确的检索。这为不太准确的嵌入匹配方法提供了一种上级替代方案（Gao 等人，[2023](https://arxiv.org/html/2410.05779v2#bib.bib8)）和低效的块遍历技术（Edge 等人，[2024](https://arxiv.org/html/2410.05779v2#bib.bib4)年），在现有的方法中普遍使用。

Fast Adaptation to Incremental Knowledge Base. To efficiently adapt to evolving data changes while ensuring accurate and relevant responses, our LightRAG incrementally updates the knowledge base without the need for complete reprocessing of the entire external database. For a new document 𝒟′superscript𝒟′\\mathcal{D}^{\\prime}caligraphic\_D start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT, the incremental update algorithm processes it using the same graph-based indexing steps φ𝜑\\varphiitalic\_φ as before, resulting in 𝒟^′\=(𝒱^′,ℰ^′)superscript^𝒟′superscript^𝒱′superscript^ℰ′\\hat{\\mathcal{D}}^{\\prime}=(\\hat{\\mathcal{V}}^{\\prime},\\hat{\\mathcal{E}}^{% \\prime})over^ start\_ARG caligraphic\_D end\_ARG start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT = ( over^ start\_ARG caligraphic\_V end\_ARG start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT , over^ start\_ARG caligraphic\_E end\_ARG start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT ). Subsequently, LightRAGcombines the new graph data with the original by taking the union of the node sets 𝒱^^𝒱\\hat{\\mathcal{V}}over^ start\_ARG caligraphic\_V end\_ARG and 𝒱^′superscript^𝒱′\\hat{\\mathcal{V}}^{\\prime}over^ start\_ARG caligraphic\_V end\_ARG start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT, as well as the edge sets ℰ^^ℰ\\hat{\\mathcal{E}}over^ start\_ARG caligraphic\_E end\_ARG and ℰ^′superscript^ℰ′\\hat{\\mathcal{E}}^{\\prime}over^ start\_ARG caligraphic\_E end\_ARG start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT.  
快速适应增量知识库。为了有效地适应不断变化的数据，同时确保准确和相关的响应，我们的LightRAG增量更新知识库，而无需完全重新处理整个外部数据库。对于新文档 𝒟′superscript\\mathcal{D}^{\\prime}caligraphic\_D start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT ，增量更新算法使用与之前相同的基于图的索引步骤 φ\\varphiitalic\_φ 来处理它，得到 𝒟^′\=(𝒱^′,ℰ^′)superscriptsuperscriptsuperscript\\hat{\\mathcal{D}}^{\\prime}=(\\hat{\\mathcal{V}}^{\\prime},\\hat{\\mathcal{E}}^{% \\prime})over^ start\_ARG caligraphic\_D end\_ARG start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT = ( over^ start\_ARG caligraphic\_V end\_ARG start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT , over^ start\_ARG caligraphic\_E end\_ARG start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT ) 。随后，LightRAG通过取节点集 𝒱^\\hat{\\mathcal{V}}over^ start\_ARG caligraphic\_V end\_ARG 和 𝒱^′superscript\\hat{\\mathcal{V}}^{\\prime}over^ start\_ARG caligraphic\_V end\_ARG start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT 以及边集 ℰ^\\hat{\\mathcal{E}}over^ start\_ARG caligraphic\_E end\_ARG 和 ℰ^′superscript\\hat{\\mathcal{E}}^{\\prime}over^ start\_ARG caligraphic\_E end\_ARG start\_POSTSUPERSCRIPT ′ end\_POSTSUPERSCRIPT 的并集来将新的图形数据与原始图形数据组合。

Two key objectives guide our approach to fast adaptation for the incremental knowledge base: Seamless Integration of New Data. By applying a consistent methodology to new information, the incremental update module allows the LightRAG to integrate new external databases without disrupting the existing graph structure. This approach preserves the integrity of established connections, ensuring that historical data remains accessible while enriching the graph without conflicts or redundancies. Reducing Computational Overhead. By eliminating the need to rebuild the entire index graph, this method reduces computational overhead and facilitates the rapid assimilation of new data. Consequently, LightRAG maintains system accuracy, provides current information, and conserves resources, ensuring users receive timely updates and enhancing the overall RAG effectiveness.  
两个关键目标指导我们快速适应增量知识库的方法：新数据的无缝集成。通过对新信息应用一致的方法，增量更新模块允许LightRAG集成新的外部数据库，而不会破坏现有的图形结构。这种方法保留了已建立连接的完整性，确保历史数据保持可访问性，同时丰富了图形，没有冲突或冗余。减少计算开销。通过消除重建整个索引图的需要，该方法减少了计算开销，并促进了新数据的快速同化。因此，LightRAG保持系统的准确性，提供最新信息，并节省资源，确保用户及时获得更新，并提高整体RAG的有效性。

### 3.2 Dual-level Retrieval Paradigm  
3.2双层检索范式

To retrieve relevant information from both specific document chunks and their complex inter-dependencies, our LightRAG proposes generating query keys at both detailed and abstract levels.  
为了从特定的文档块及其复杂的相互依赖关系中检索相关信息，我们的LightRAG建议在详细和抽象级别上生成查询键。

* •  
Specific Queries. These queries are detail-oriented and typically reference specific entities within the graph, requiring precise retrieval of information associated with particular nodes or edges. For example, a specific query might be, “Who wrote ’Pride and Prejudice’?”  
    
·具体的时间表。这些查询是面向细节的，并且通常引用图中的特定实体，需要精确检索与特定节点或边相关联的信息。例如，一个特定的查询可能是，“谁写的'傲慢与偏见'？”
* •  
Abstract Queries. In contrast, abstract queries are more conceptual, encompassing broader topics, summaries, or overarching themes that are not directly tied to specific entities. An example of an abstract query is, “How does artificial intelligence influence modern education?”  
    
·抽象的。相比之下，抽象查询更具概念性，包含更广泛的主题，摘要或不直接与特定实体联系的总体主题。抽象查询的一个例子是，“人工智能如何影响现代教育？”

To accommodate diverse query types, the LightRAG employs two distinct retrieval strategies within the dual-level retrieval paradigm. This ensures that both specific and abstract inquiries are addressed effectively, allowing the system to deliver relevant responses tailored to user needs.  
为了适应不同的查询类型，LightRAG采用两种不同的检索策略内的双级检索范式。这确保了具体和抽象的查询都得到有效处理，使系统能够根据用户需求提供相关的答复。

* •  
Low-Level Retrieval. This level is primarily focused on retrieving specific entities along with their associated attributes or relationships. Queries at this level are detail-oriented and aim to extract precise information about particular nodes or edges within the graph.  
    
·低级检索。此级别主要集中于检索特定实体及其关联属性或关系沿着。此级别的查询是面向细节的，旨在提取有关图中特定节点或边的精确信息。
* •  
High-Level Retrieval. This level addresses broader topics and overarching themes. Queries at this level aggregate information across multiple related entities and relationships, providing insights into higher-level concepts and summaries rather than specific details.  
    
·高级检索。这一级别涉及更广泛的主题和最重要的主题。此级别的查询聚合了多个相关实体和关系中的信息，提供了对更高级别的概念和摘要（而不是具体细节）的深入了解。

Integrating Graph and Vectors for Efficient Retrieval. By combining graph structures with vector representations, the model gains a deeper insight into the interrelationships among entities. This synergy enables the retrieval algorithm to effectively utilize both local and global keywords, streamlining the search process and improving the relevance of results.  
集成图形和矢量以实现高效检索。通过将图形结构与矢量表示相结合，该模型可以更深入地了解实体之间的相互关系。这种协同作用使检索算法能够有效地利用本地和全局关键字，简化搜索过程并提高结果的相关性。

* •  
(i) Query Keyword Extraction. For a given query q𝑞qitalic\_q, the retrieval algorithm of LightRAG begins by extracting both local query keywords k(l)superscript𝑘𝑙k^{(l)}italic\_k start\_POSTSUPERSCRIPT ( italic\_l ) end\_POSTSUPERSCRIPT and global query keywords k(g)superscript𝑘𝑔k^{(g)}italic\_k start\_POSTSUPERSCRIPT ( italic\_g ) end\_POSTSUPERSCRIPT.  
    
·（i）查询关键字提取。对于给定的查询 qqitalic\_q ，LightRAG的检索算法通过提取局部查询关键字 k(l)superscriptk^{(l)}italic\_k start\_POSTSUPERSCRIPT ( italic\_l ) end\_POSTSUPERSCRIPT 和全局查询关键字 k(g)superscriptk^{(g)}italic\_k start\_POSTSUPERSCRIPT ( italic\_g ) end\_POSTSUPERSCRIPT 两者开始。
* •  
(ii) Keyword Matching. The algorithm uses an efficient vector database to match local query keywords with candidate entities and global query keywords with relations linked to global keys.  
    
·（ii）关键字匹配。该算法使用高效的向量数据库将局部查询关键字与候选实体进行匹配，并将全局查询关键字与全局关键字链接的关系进行匹配。
* •  
(iii) Incorporating High-Order Relatedness. To enhance the query with higher-order relatedness, LightRAGfurther gathers neighboring nodes within the local subgraphs of the retrieved graph elements. This process involves the set {vi|vi∈𝒱∧(vi∈𝒩v∨vi∈𝒩e)}conditional-setsubscript𝑣𝑖subscript𝑣𝑖𝒱subscript𝑣𝑖subscript𝒩𝑣subscript𝑣𝑖subscript𝒩𝑒\\{v\_{i}|v\_{i}\\in\\mathcal{V}\\land(v\_{i}\\in\\mathcal{N}\_{v}\\lor v\_{i}\\in\\mathcal{% N}\_{e})\\}{ italic\_v start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT | italic\_v start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT ∈ caligraphic\_V ∧ ( italic\_v start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT ∈ caligraphic\_N start\_POSTSUBSCRIPT italic\_v end\_POSTSUBSCRIPT ∨ italic\_v start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT ∈ caligraphic\_N start\_POSTSUBSCRIPT italic\_e end\_POSTSUBSCRIPT ) }, where 𝒩vsubscript𝒩𝑣\\mathcal{N}\_{v}caligraphic\_N start\_POSTSUBSCRIPT italic\_v end\_POSTSUBSCRIPT and 𝒩esubscript𝒩𝑒\\mathcal{N}\_{e}caligraphic\_N start\_POSTSUBSCRIPT italic\_e end\_POSTSUBSCRIPT represent the one-hop neighboring nodes of the retrieved nodes v𝑣vitalic\_v and edges e𝑒eitalic\_e, respectively.  
    
（iii）描述高阶相关性。为了增强具有更高阶相关性的查询，LightRAG进一步收集检索到的图形元素的局部子图内的邻近节点。该处理涉及集合 {vi|vi∈𝒱∧(vi∈𝒩v∨vi∈𝒩e)}conditional-setsubscriptsubscriptsubscriptsubscriptsubscriptsubscript\\{v\_{i}|v\_{i}\\in\\mathcal{V}\\land(v\_{i}\\in\\mathcal{N}\_{v}\\lor v\_{i}\\in\\mathcal{% N}\_{e})\\}{ italic\_v start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT | italic\_v start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT ∈ caligraphic\_V ∧ ( italic\_v start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT ∈ caligraphic\_N start\_POSTSUBSCRIPT italic\_v end\_POSTSUBSCRIPT ∨ italic\_v start\_POSTSUBSCRIPT italic\_i end\_POSTSUBSCRIPT ∈ caligraphic\_N start\_POSTSUBSCRIPT italic\_e end\_POSTSUBSCRIPT ) } ，其中 𝒩vsubscript\\mathcal{N}\_{v}caligraphic\_N start\_POSTSUBSCRIPT italic\_v end\_POSTSUBSCRIPT 和 𝒩esubscript\\mathcal{N}\_{e}caligraphic\_N start\_POSTSUBSCRIPT italic\_e end\_POSTSUBSCRIPT 分别表示检索到的节点 vvitalic\_v 和边 eeitalic\_e 的一跳相邻节点。

This dual-level retrieval paradigm not only facilitates efficient retrieval of related entities and relations through keyword matching, but also enhances the comprehensiveness of results by integrating relevant structural information from the constructed knowledge graph.  
这种双层检索模式不仅通过关键字匹配实现了对相关实体和关系的高效检索，而且通过整合构建的知识图中的相关结构信息，增强了检索结果的全面性。

### 3.3 Retrieval-Augmented Answer Generation  
3.3检索增强答案生成

Utilization of Retrieved Information. Utilizing the retrieved information ψ⁢(q;𝒟^)𝜓𝑞^𝒟\\psi(q;\\hat{\\mathcal{D}})italic\_ψ ( italic\_q ; over^ start\_ARG caligraphic\_D end\_ARG ), our LightRAG employs a general-purpose LLM to generate answers based on the collected data. This data comprises concatenated values V𝑉Vitalic\_V from relevant entities and relations, produced by the profiling function P⁢(⋅)P⋅\\text{P}(\\cdot)P ( ⋅ ). It includes names, descriptions of entities and relations, and excerpts from the original text.  
检索信息的使用。利用检索到的信息 ψ⁢(q;𝒟^)\\psi(q;\\hat{\\mathcal{D}})italic\_ψ ( italic\_q ; over^ start\_ARG caligraphic\_D end\_ARG ) ，我们的LightRAG采用通用LLM来基于收集的数据生成答案。该数据包括来自相关实体和关系的级联值 VVitalic\_V ，由剖析函数 P⁢(⋅)\\text{P}(\\cdot)P ( ⋅ ) 产生。它包括名称，实体和关系的描述，以及原文的摘录。

Context Integration and Answer Generation. By unifying the query with this multi-source text, the LLM generates informative answers tailored to the user’s needs, ensuring alignment with the query’s intent. This approach streamlines the answer generation process by integrating both context and query into the LLM model, as illustrated in detailed examples (Appendix [7.2](https://arxiv.org/html/2410.05779v2#S7.SS2 "7.2 Case Example of Retrieval-Augmented Generation in LightRAG. ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation")).  
上下文集成和答案生成。通过将查询与此多源文本统一起来，LLM生成针对用户需求量身定制的信息性答案，确保与查询意图保持一致。这种方法通过将上下文和查询集成到LLM模型中来简化答案生成过程，如详细示例所示（附录[7.2](https://arxiv.org/html/2410.05779v2#S7.SS2 "7.2 Case Example of Retrieval-Augmented Generation in LightRAG. ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation")）。

### 3.4 Complexity Analysis of the LightRAG Framework  
3.4LightRAG框架的复杂性分析

In this section, we analyze the complexity of our proposed LightRAG framework, which can be divided into two main parts. The first part is the graph-based Index phase. During this phase, we use the large language model (LLM) to extract entities and relationships from each chunk of text. As a result, the LLM needs to be called total tokenschunk sizetotal tokenschunk size\\frac{\\text{total tokens}}{\\text{chunk size}}divide start\_ARG total tokens end\_ARG start\_ARG chunk size end\_ARG times. Importantly, there is no additional overhead involved in this process, making our approach highly efficient in managing updates to new text.

The second part of the process involves the graph-based retrieval phase. For each query, we first utilize the large language model (LLM) to generate relevant keywords. Similar to current Retrieval-Augmented Generation (RAG) systems Gao et al. ([2023](https://arxiv.org/html/2410.05779v2#bib.bib8); [2022](https://arxiv.org/html/2410.05779v2#bib.bib7)); Chan et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib2)), our retrieval mechanism relies on vector-based search. However, instead of retrieving chunks as in conventional RAG, we concentrate on retrieving entities and relationships. This approach markedly reduces retrieval overhead compared to the community-based traversal method used in GraphRAG.

## 4 Evaluation

We conduct empirical evaluations on benchmark data to assess the effectiveness of the proposed LightRAG framework by addressing the following research questions: ∙∙\\bullet∙ (RQ1): How does LightRAG compare to existing RAG baseline methods in terms of generation performance? ∙∙\\bullet∙ (RQ2): How do dual-level retrieval and graph-based indexing enhance the generation quality of LightRAG? ∙∙\\bullet∙ (RQ3): What specific advantages does LightRAG demonstrate through case examples in various scenarios? ∙∙\\bullet∙ (RQ4): What are the costs associated with LightRAG, as well as its adaptability to data changes?

### 4.1 Experimental Settings

Evaluation Datasets. To conduct a comprehensive analysis of LightRAG, we selected four datasets from the UltraDomain benchmark (Qian et al., [2024](https://arxiv.org/html/2410.05779v2#bib.bib12)). The UltraDomain data is sourced from 428 college textbooks and encompasses 18 distinct domains, including agriculture, social sciences, and humanities. From these, we chose the Agriculture, CS, Legal, and Mix datasets. Each dataset contains between 600,000 and 5,000,000 tokens, with detailed information provided in Table [4](https://arxiv.org/html/2410.05779v2#S7.T4 "Table 4 ‣ 7.1 Experimental Data Details ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"). Below is a specific introduction to the four domains utilized in our experiments:

* •  
Agriculture: This domain focuses on agricultural practices, covering a range of topics including beekeeping, hive management, crop production, and disease prevention.
* •  
CS: This domain focuses on computer science and encompasses key areas of data science and software engineering. It particularly highlights machine learning and big data processing, featuring content on recommendation systems, classification algorithms, and real-time analytics using Spark.
* •  
Legal: This domain centers on corporate legal practices, addressing corporate restructuring, legal agreements, regulatory compliance, and governance, with a focus on the legal and financial sectors.
* •  
Mixed: This domain presents a rich variety of literary, biographical, and philosophical texts, spanning a broad spectrum of disciplines, including cultural, historical, and philosophical studies.

Question Generation. To evaluate the effectiveness of RAG systems for high-level sensemaking tasks, we consolidate all text content from each dataset as context and adopt the generation method outlined in Edge et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib4)). Specifically, we instruct an LLM to generate five RAG users, along with five tasks for each user. Each generated user is accompanied by a textual description detailing their expertise and traits that motivate their question-raising activities. Each user task is also described, emphasizing one of the user’s potential intentions when interacting with RAG systems. For each user-task combination, the LLM generates five questions that require an understanding of the entire corpus. In total, this process results in 125 questions for each dataset.

Baselines. LightRAG is compared against the following state-of-the-art methods across all datasets:

* •  
Naive RAG (Gao et al., [2023](https://arxiv.org/html/2410.05779v2#bib.bib8)): This model serves as a standard baseline in existing RAG systems. It segments raw texts into chunks and stores them in a vector database using text embeddings. For queries, Naive RAG generates vectorized representations to directly retrieve text chunks based on the highest similarity in their representations, ensuring efficient and straightforward matching.
* •  
RQ-RAG (Chan et al., [2024](https://arxiv.org/html/2410.05779v2#bib.bib2)): This approach leverages the LLM to decompose the input query into multiple sub-queries. These sub-queries are designed to enhance search accuracy by utilizing explicit techniques such as rewriting, decomposition, and disambiguation.
* •  
HyDE (Gao et al., [2022](https://arxiv.org/html/2410.05779v2#bib.bib7)): This method utilizes the LLM to generate a hypothetical document based on the input query. This generated document is then employed to retrieve relevant text chunks, which are subsequently used to formulate the final answer.
* •  
GraphRAG (Edge et al., [2024](https://arxiv.org/html/2410.05779v2#bib.bib4)): This is a graph-enhanced RAG system that utilizes an LLM to extract entities and relationships from the text, representing them as nodes and edges. It generates corresponding descriptions for these elements, aggregates nodes into communities, and produces a community report to capture global information. When handling high-level queries, GraphRAG retrieves more comprehensive information by traversing these communities.

Implementation and Evaluation Details. In our experiments, we utilize the [nano vector database](https://github.com/gusye1234/nano-vectordb) for vector data management and access. For all LLM-based operations in LightRAG, we default to using GPT-4o-mini. To ensure consistency, the chunk size is set to 1200 across all datasets. Additionally, the gleaning parameter is fixed at 1 for both GraphRAG and LightRAG.

Defining ground truth for many RAG queries, particularly those involving complex high-level semantics, poses significant challenges. To address this, we build on existing work (Edge et al., [2024](https://arxiv.org/html/2410.05779v2#bib.bib4)) and adopt an LLM-based multi-dimensional comparison method. We employ a robust LLM, specifically GPT-4o-mini, to rank each baseline against our LightRAG. The evaluation prompt we used is detailed in Appendix [7.3.4](https://arxiv.org/html/2410.05779v2#S7.SS3.SSS4 "7.3.4 Prompts for RAG Evaluation ‣ 7.3 Overview of the Prompts Used in LightRAG ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"). In total, we utilize four evaluation dimensions, including:

i) Comprehensiveness: How thoroughly does the answer address all aspects and details of the question? ii) Diversity: How varied and rich is the answer in offering different perspectives and insights related to the question? iii) Empowerment: How effectively does the answer enable the reader to understand the topic and make informed judgments? iv) Overall: This dimension assesses the cumulative performance across the three preceding criteria to identify the best overall answer.

The LLM directly compares two answers for each dimension and selects the superior response for each criterion. After identifying the winning answer for the three dimensions, the LLM combines the results to determine the overall better answer. To ensure a fair evaluation and mitigate the potential bias that could arise from the order in which the answers are presented in the prompt, we alternate the placement of each answer. We calculate win rates accordingly, ultimately leading to the final results.

### 4.2 Comparison of LightRAG with Existing RAG Methods (RQ1)

We compare LightRAG against each baseline across various evaluation dimensions and datasets. The results are presented in Table [1](https://arxiv.org/html/2410.05779v2#S4.T1 "Table 1 ‣ 4.2 Comparison of LightRAG with Existing RAG Methods (RQ1) ‣ 4 Evaluation ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"). Based on these findings, we draw the following conclusions:

Table 1: Win rates (%) of baselines v.s. LightRAG across four datasets and four evaluation dimensions.

The Superiority of Graph-enhanced RAG Systems in Large-Scale CorporaWhen handling large token counts and complex queries that require a thorough understanding of the dataset’s context, graph-based RAG systems like LightRAG and GraphRAG consistently outperform purely chunk-based retrieval methods such as NaiveRAG, HyDE, and RQRAG. This performance gap becomes particularly pronounced as the dataset size increases. For instance, in the largest dataset (Legal), the disparity widens significantly, with baseline methods achieving only about 20% win rates compared to the dominance of LightRAG. This trend underscores the advantages of graph-enhanced RAG systems in capturing complex semantic dependencies within large-scale corpora, facilitating a more comprehensive understanding of knowledge and leading to improved generalization performance.

Enhancing Response Diversity with LightRAG: Compared to various baselines, LightRAG demonstrates a significant advantage in the Diversity metric, particularly within the larger Legal dataset. Its consistent lead in this area underscores LightRAG’s effectiveness in generating a wider range of responses, especially in scenarios where diverse content is essential. We attribute this advantage to LightRAG’s dual-level retrieval paradigm, which facilitates comprehensive information retrieval from both low-level and high-level dimensions. This approach effectively leverages graph-based text indexing to consistently capture the full context in response to queries.

LightRAG’s Superiority over GraphRAG: While both LightRAG and GraphRAG use graph-based retrieval mechanisms, LightRAG consistently outperforms GraphRAG, particularly in larger datasets with complex language contexts. In the Agriculture, CS, and Legal datasets—each containing millions of tokens—LightRAG shows a clear advantage, significantly surpassing GraphRAG and highlighting its strength in comprehensive information understanding within diverse environments. Enhanced Response Variety: By integrating low-level retrieval of specific entities with high-level retrieval of broader topics, LightRAG boosts response diversity. This dual-level mechanism effectively addresses both detailed and abstract queries, ensuring a thorough grasp of information. Complex Query Handling: This approach is especially valuable in scenarios requiring diverse perspectives. By accessing both specific details and overarching themes, LightRAG adeptly responds to complex queries involving interconnected topics, providing contextually relevant answers.

### 4.3 Ablation Studies (RQ2)

Table 2: Performance of ablated versions of LightRAG, using NaiveRAG as reference.

We also conduct ablation studies to evaluate the impact of our dual-level retrieval paradigm and the effectiveness of our graph-based text indexing in LightRAG. The results are presented in Table [2](https://arxiv.org/html/2410.05779v2#S4.T2 "Table 2 ‣ 4.3 Ablation Studies (RQ2) ‣ 4 Evaluation ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation").

Effectiveness of Dual-level Retrieval Paradigm. We begin by analyzing the effects of low-level and high-level retrieval paradigms. We compare two ablated models—each omitting one module—against LightRAG across four datasets. Here are our key observations for the different variants:

* •  
Low-level-only Retrieval: The -High variant removes high-order retrieval, leading to a significant performance decline across nearly all datasets and metrics. This drop is mainly due to its emphasis on the specific information, which focuses excessively on entities and their immediate neighbors. While this approach enables deeper exploration of directly related entities, it struggles to gather information for complex queries that demand comprehensive insights.
* •  
High-level-only Retrieval: The -Low variant prioritizes capturing a broader range of content by leveraging entity-wise relationships rather than focusing on specific entities. This approach offers a significant advantage in comprehensiveness, allowing it to gather more extensive and varied information. However, the trade-off is a reduced depth in examining specific entities, which can limit its ability to provide highly detailed insights. Consequently, this high-level-only retrieval method may struggle with tasks that require precise, detailed answers.
* •  
Hybrid Mode: The hybrid mode, or the full version of LightRAG, combines the strengths of both low-level and high-level retrieval methods. It retrieves a broader set of relationships while simultaneously conducting an in-depth exploration of specific entities. This dual-level approach ensures both breadth in the retrieval process and depth in the analysis, providing a comprehensive view of the data. As a result, LightRAG achieves balanced performance across multiple dimensions.

Semantic Graph Excels in RAG. We eliminated the use of original text in our retrieval process. Surprisingly, the resulting variant, -Origin, does not exhibit significant performance declines across all four datasets. In some cases, this variant even shows improvements (e.g. in Agriculture and Mix). We attribute this phenomenon to the effective extraction of key information during the graph-based indexing process, which provides sufficient context for answering queries. Additionally, the original text often contains irrelevant information that can introduce noise in the response.

### 4.4 Case Study (RQ3)

To provide a clear comparison between baseline methods and our LightRAG, we present specific case examples in Table [3](https://arxiv.org/html/2410.05779v2#S4.T3 "Table 3 ‣ 4.4 Case Study (RQ3) ‣ 4 Evaluation ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"), which includes responses to a machine learning question from both the competitive baseline, GraphRAG, and our LightRAG framework. In this instance, LightRAG outperforms in all evaluation dimensions assessed by the LLM judge, including comprehensiveness, diversity, empowerment, and overall quality. Our key observations are as follows:

i) Comprehensiveness. Notably, LightRAG covers a broader range of machine learning metrics, showcasing its comprehensiveness and ability to effectively discover relevant information. This highlights the strength of our graph-based indexing paradigm, which excels in precise entity and relation extraction as well as LLM profiling.ii) Both Diversity and Empowerment. Furthermore, LightRAG not only offers a more diverse array of information but also delivers more empowering content. This success is due to LightRAG’s hierarchical retrieval paradigm, which combines in-depth explorations of related entities through low-level retrieval to enhance empowerment with broader explorations via high-level retrieval to improve answer diversity. Together, these approaches capture a comprehensive global perspective of the knowledge domain, contributing to better RAG performance.

Table 3: Case Study: Comparison Between LightRAG and the Baseline Method GraphRAG.

### 4.5 Model Cost and Adaptability Analysis (RQ4)

Figure 2: Comparison of Cost in Terms of Tokens and API Calls for GraphRAG and LightRAG on the Legal Dataset.

| Phase                                                                                                        | Retrieval Phase                                                                                                                                                                                  | Incremental Text Update                                                    |                                                                                                                                                     |                                                                                                         |
| ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Model                                                                                                        | GraphRAG                                                                                                                                                                                         | Ours                                                                       | GraphRAG                                                                                                                                            | Ours                                                                                                    |
| Tokens                                                                                                       | <100absent100<100< 100                                                                                                                                                                           | 1,399×2×5,0001399250001{,}399\\times 2\\times 5{,}0001 , 399 × 2 × 5 , 000 | Textractsubscript𝑇extractT\_{\\text{extract}}italic\_T start\_POSTSUBSCRIPT extract end\_POSTSUBSCRIPT                                             |                                                                                                         |
| +Textractsubscript𝑇extract+T\_{\\text{extract}}\+ italic\_T start\_POSTSUBSCRIPT extract end\_POSTSUBSCRIPT |                                                                                                                                                                                                  |                                                                            |                                                                                                                                                     |                                                                                                         |
| API                                                                                                          | 610×1,000Cmax6101000subscript𝐶max\\frac{610\\times 1{,}000}{C\_{\\text{max}}}divide start\_ARG 610 × 1 , 000 end\_ARG start\_ARG italic\_C start\_POSTSUBSCRIPT max end\_POSTSUBSCRIPT end\_ARG | 1                                                                          | 1,399×2+Cextract13992subscript𝐶extract1{,}399\\times 2+C\_{\\text{extract}}1 , 399 × 2 + italic\_C start\_POSTSUBSCRIPT extract end\_POSTSUBSCRIPT | Cextractsubscript𝐶extractC\_{\\text{extract}}italic\_C start\_POSTSUBSCRIPT extract end\_POSTSUBSCRIPT |
| Calls                                                                                                        |                                                                                                                                                                                                  |                                                                            |                                                                                                                                                     |                                                                                                         |

We compare the cost of our LightRAG with that of the top-performing baseline, GraphRAG, from two key perspectives. First, we examine the number of tokens and API calls during the indexing and retrieval processes. Second, we analyze these metrics in relation to handling data changes in dynamic environments. The results of this evaluation on the legal dataset are presented in Table [2](https://arxiv.org/html/2410.05779v2#S4.F2 "Figure 2 ‣ 4.5 Model Cost and Adaptability Analysis (RQ4) ‣ 4 Evaluation ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"). In this context, Textractsubscript𝑇extractT\_{\\text{extract}}italic\_T start\_POSTSUBSCRIPT extract end\_POSTSUBSCRIPT represents the token overhead for entity and relationship extraction, Cmaxsubscript𝐶maxC\_{\\text{max}}italic\_C start\_POSTSUBSCRIPT max end\_POSTSUBSCRIPT denotes the maximum number of tokens allowed per API call, and Cextractsubscript𝐶extractC\_{\\text{extract}}italic\_C start\_POSTSUBSCRIPT extract end\_POSTSUBSCRIPT indicates the number of API calls required for extraction.

In the retrieval phase, GraphRAG generates 1,399 communities, with 610 level-2 communities actively utilized for retrieval in this experiment. Each community report averages 1,000 tokens, resulting in a total token consumption of 610,000 tokens (610 communities ×\\times× 1,000 tokens per community). Additionally, GraphRAG’s requirement to traverse each community individually leads to hundreds of API calls, significantly increasing retrieval overhead. In contrast, LightRAG optimizes this process by using fewer than 100 tokens for keyword generation and retrieval, requiring only a single API call for the entire process. This efficiency is achieved through our retrieval mechanism, which seamlessly integrates graph structures and vectorized representations for information retrieval, thereby eliminating the need to process large volumes of information upfront.

In the incremental data update phase, designed to address changes in dynamic real-world scenarios, both models exhibit similar overhead for entity and relationship extraction. However, GraphRAG shows significant inefficiency in managing newly added data. When a new dataset of the same size as the legal dataset is introduced, GraphRAG must dismantle its existing community structure to incorporate new entities and relationships, followed by complete regeneration. This process incurs a substantial token cost of approximately 5,000 tokens per community report. Given 1,399 communities, GraphRAG would require around 1,399 × 2 × 5,000 tokens to reconstruct both the original and new community reports—an exorbitant expense that underscores its inefficiency. In contrast, LightRAG seamlessly integrates newly extracted entities and relationships into the existing graph without the need for full reconstruction. This approach results in significantly lower overhead during incremental updates, demonstrating its superior efficiency and cost-effectiveness.

## 5 Related Work

### 5.1 Retrieval-Augmented Generation with LLMs

Retrieval-Augmented Generation (RAG) systems enhance LLM inputs by retrieving relevant information from external sources, grounding responses in factual, domain-specific knowledge Ram et al. ([2023](https://arxiv.org/html/2410.05779v2#bib.bib13)); Fan et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib6)). Current RAG approaches Gao et al. ([2022](https://arxiv.org/html/2410.05779v2#bib.bib7); [2023](https://arxiv.org/html/2410.05779v2#bib.bib8)); Chan et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib2)); Yu et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib20)) typically embed queries in a vector space to find the nearest context vectors. However, many of these methods rely on fragmented text chunks and only retrieve the top-k contexts, limiting their ability to capture comprehensive global information needed for effective responses.

Although recent studies Edge et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib4)) have explored using graph structures for knowledge representation, two key limitations persist. First, these approaches often lack the capability for dynamic updates and expansions of the knowledge graph, making it difficult to incorporate new information effectively. In contrast, our proposed model, LightRAG, addresses these challenges by enabling the RAG system to quickly adapt to new information, ensuring the model’s timeliness and accuracy. Additionally, existing methods often rely on brute-force searches for each generated community, which are inefficient for large-scale queries. Our LightRAG framework overcomes this limitation by facilitating rapid retrieval of relevant information from the graph through our proposed dual-level retrieval paradigm, significantly enhancing both retrieval efficiency and response speed.

### 5.2 Large Language Model for Graphs

Graphs are a powerful framework for representing complex relationships and find applications in numerous fields. As Large Language Models (LLMs) continue to evolve, researchers have increasingly focused on enhancing their capability to interpret graph-structured data. This body of work can be divided into three primary categories: i) GNNs as Prefix where Graph Neural Networks (GNNs) are utilized as the initial processing layer for graph data, generating structure-aware tokens that LLMs can use during inference. Notable examples include GraphGPT Tang et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib17)) and LLaGA Chen et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib3)). ii) LLMs as Prefix involves LLMs processing graph data enriched with textual information to produce node embeddings or labels, ultimately refining the training process for GNNs, as demonstrated in systems like GALM Xie et al. ([2023](https://arxiv.org/html/2410.05779v2#bib.bib19)) and OFA Liu et al. ([2024](https://arxiv.org/html/2410.05779v2#bib.bib10)). iii) LLMs-Graphs Integration focuses on achieving a seamless interaction between LLMs and graph data, employing techniques such as fusion training and GNN alignment, and developing LLM-based agents capable of engaging with graph information directly Li et al. ([2023](https://arxiv.org/html/2410.05779v2#bib.bib9)); Brannon et al. ([2023](https://arxiv.org/html/2410.05779v2#bib.bib1)).

## 6 Conclusion

This work introduces an advancement in Retrieval-Augmented Generation (RAG) through the integration of a graph-based indexing approach that enhances both efficiency and comprehension in information retrieval. LightRAG utilizes a comprehensive knowledge graph to facilitate rapid and relevant document retrieval, enabling a deeper understanding of complex queries. Its dual-level retrieval paradigm allows for the extraction of both specific and abstract information, catering to diverse user needs. Furthermore, LightRAG’s seamless incremental update capability ensures that the system remains current and responsive to new information, thereby maintaining its effectiveness over time. Overall, LightRAG excels in both efficiency and effectiveness, significantly improving the speed and quality of information retrieval and generation while reducing costs for LLM inference.

## References

* Brannon et al. (2023) William Brannon, Suyash Fulay, Hang Jiang, Wonjune Kang, Brandon Roy, Jad Kabbara, and Deb Roy. Congrat: Self-supervised contrastive pretraining for joint graph and text embeddings. arXiv preprint arXiv:2305.14321, 2023.
* Chan et al. (2024) Chi-Min Chan, Chunpu Xu, Ruibin Yuan, Hongyin Luo, Wei Xue, Yike Guo, and Jie Fu. Rq-rag: Learning to refine queries for retrieval augmented generation. arXiv preprint arXiv:2404.00610, 2024.
* Chen et al. (2024) Runjin Chen, Tong Zhao, AJAY KUMAR JAISWAL, Neil Shah, and Zhangyang Wang. Llaga: Large language and graph assistant. In International Conference on Machine Learning (ICML), 2024.
* Edge et al. (2024) Darren Edge, Ha Trinh, Newman Cheng, Joshua Bradley, Alex Chao, Apurva Mody, Steven Truitt, and Jonathan Larson. From local to global: A graph rag approach to query-focused summarization. arXiv preprint arXiv:2404.16130, 2024.
* Es et al. (2024) Shahul Es, Jithin James, Luis Espinosa Anke, and Steven Schockaert. Ragas: Automated evaluation of retrieval augmented generation. In International Conference of the European Chapter of the Association for Computational Linguistics (EACL), pp. 150–158, 2024.
* Fan et al. (2024) Wenqi Fan, Yujuan Ding, Liangbo Ning, Shijie Wang, Hengyun Li, Dawei Yin, Tat-Seng Chua, and Qing Li. A survey on rag meeting llms: Towards retrieval-augmented large language models. In International Conference on Knowledge Discovery and Data Mining (KDD), pp. 6491–6501, 2024.
* Gao et al. (2022) Luyu Gao, Xueguang Ma, Jimmy Lin, and Jamie Callan. Precise zero-shot dense retrieval without relevance labels. arXiv preprint arXiv:2212.10496, 2022.
* Gao et al. (2023) Yunfan Gao, Yun Xiong, Xinyu Gao, Kangxiang Jia, Jinliu Pan, Yuxi Bi, Yi Dai, Jiawei Sun, and Haofen Wang. Retrieval-augmented generation for large language models: A survey. arXiv preprint arXiv:2312.10997, 2023.
* Li et al. (2023) Yichuan Li, Kaize Ding, and Kyumin Lee. Grenade: Graph-centric language model for self-supervised representation learning on text-attributed graphs. In International Conference on Empirical Methods in Natural Language Processing (EMNLP), pp. 2745–2757, 2023.
* Liu et al. (2024) Hao Liu, Jiarui Feng, Lecheng Kong, Ningyue Liang, Dacheng Tao, Yixin Chen, and Muhan Zhang. One for all: Towards training one graph model for all classification tasks. In International Conference on Learning Representations (ICLR), 2024.
* Lyu et al. (2024) Yuanjie Lyu, Zhiyu Li, Simin Niu, Feiyu Xiong, Bo Tang, Wenjin Wang, Hao Wu, Huanyong Liu, Tong Xu, and Enhong Chen. Crud-rag: A comprehensive chinese benchmark for retrieval-augmented generation of large language models. arXiv preprint arXiv:2401.17043, 2024.
* Qian et al. (2024) Hongjin Qian, Peitian Zhang, Zheng Liu, Kelong Mao, and Zhicheng Dou. Memorag: Moving towards next-gen rag via memory-inspired knowledge discovery, 2024. URL <https://arxiv.org/abs/2409.05591>.
* Ram et al. (2023) Ori Ram, Yoav Levine, Itay Dalmedigos, Dor Muhlgay, Amnon Shashua, Kevin Leyton-Brown, and Yoav Shoham. In-context retrieval-augmented language models. Transactions of the Association for Computational Linguistics (TACL), 11:1316–1331, 2023.
* Rampášek et al. (2022) Ladislav Rampášek, Michael Galkin, Vijay Prakash Dwivedi, Anh Tuan Luu, Guy Wolf, and Dominique Beaini. Recipe for a general, powerful, scalable graph transformer. International Conference on Neural Information Processing Systems (NeurIPS), 35:14501–14515, 2022.
* Salemi & Zamani (2024) Alireza Salemi and Hamed Zamani. Evaluating retrieval quality in retrieval-augmented generation. In ACM International Conference on Research and Development in Information Retrieval (SIGIR), pp. 2395–2400, 2024.
* Sudhi et al. (2024) Viju Sudhi, Sinchana Ramakanth Bhat, Max Rudat, and Roman Teucher. Rag-ex: A generic framework for explaining retrieval augmented generation. In ACM International Conference on Research and Development in Information Retrieval (SIGIR), pp. 2776–2780, 2024.
* Tang et al. (2024) Jiabin Tang, Yuhao Yang, Wei Wei, Lei Shi, Lixin Su, Suqi Cheng, Dawei Yin, and Chao Huang. Graphgpt: Graph instruction tuning for large language models. In ACM International Conference on Research and Development in Information Retrieval (SIGIR), pp. 491–500, 2024.
* Tu et al. (2024) Shangqing Tu, Yuanchun Wang, Jifan Yu, Yuyang Xie, Yaran Shi, Xiaozhi Wang, Jing Zhang, Lei Hou, and Juanzi Li. R-eval: A unified toolkit for evaluating domain knowledge of retrieval augmented large language models. In International Conference on Knowledge Discovery and Data Mining (KDD), pp. 5813–5824, 2024.
* Xie et al. (2023) Han Xie, Da Zheng, Jun Ma, Houyu Zhang, Vassilis N Ioannidis, Xiang Song, Qing Ping, Sheng Wang, Carl Yang, Yi Xu, et al. Graph-aware language model pre-training on a large graph corpus can help multiple graph applications. In International Conference on Knowledge Discovery and Data Mining (KDD), pp. 5270–5281, 2023.
* Yu et al. (2024) Yue Yu, Wei Ping, Zihan Liu, Boxin Wang, Jiaxuan You, Chao Zhang, Mohammad Shoeybi, and Bryan Catanzaro. Rankrag: Unifying context ranking with retrieval-augmented generation in llms. arXiv preprint arXiv:2407.02485, 2024.
* Zhao et al. (2024) Penghao Zhao, Hailin Zhang, Qinhan Yu, Zhengren Wang, Yunteng Geng, Fangcheng Fu, Ling Yang, Wentao Zhang, and Bin Cui. Retrieval-augmented generation for ai-generated content: A survey. arXiv preprint arXiv:2402.19473, 2024.

## 7 Appendix

In this section, we elaborate on the methodologies and experimental settings used in the LightRAG framework. It describes the specific steps for extracting entities and relationships from documents, detailing how large language models (LLMs) are utilized for this purpose. The section also specifies the prompt templates and configurations used in LLM operations, ensuring clarity in the experimental setup. Additionally, it outlines the evaluation criteria and dimensions used to assess the performance of LightRAG against baselines from various dimensions.

### 7.1 Experimental Data Details

Table 4: Statistical information of the datasets.

Table [4](https://arxiv.org/html/2410.05779v2#S7.T4 "Table 4 ‣ 7.1 Experimental Data Details ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation") presents statistical information for four datasets: Agriculture, CS, Legal, and Mix. The Agriculture dataset consists of 12 documents totaling 2,017,886 tokens, while the CS dataset contains 10 documents with 2,306,535 tokens. The Legal dataset is the largest, comprising 94 documents and 5,081,069 tokens. Lastly, the Mix dataset includes 61 documents with a total of 619,009 tokens.

### 7.2 Case Example of Retrieval-Augmented Generation in LightRAG.

![Refer to caption](https://g1proxy.wimg.site/s0ASEeJnkOFd6ADM2UxmVESfC3f1dtZB1ggMSRFkySPM/https://arxiv.org/html/2410.05779v2/extracted/5984364/figs/retrieval_and_generation_example.png) 

Figure 3: A retrieval and generation example.

In Figure [3](https://arxiv.org/html/2410.05779v2#S7.F3 "Figure 3 ‣ 7.2 Case Example of Retrieval-Augmented Generation in LightRAG. ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"), we illustrate the retrieve-and-generate process. When presented with the query, “What metrics are most informative for evaluating movie recommendation systems?”, the LLM first extracts both low-level and high-level keywords. These keywords guide the dual-level retrieval process on the generated knowledge graph, targeting relevant entities and relationships. The retrieved information is organized into three components: entities, relationships, and corresponding text chunks. This structured data is then fed into the LLM, enabling it to generate a comprehensive answer to the query.

### 7.3 Overview of the Prompts Used in LightRAG

#### 7.3.1 Prompts for Graph Generation

![Refer to caption](https://g1proxy.wimg.site/sZqmlWEvaltInqKVVpgSkYZHuL8_K7WOiYhlSlc9gw4w/https://arxiv.org/html/2410.05779v2/extracted/5984364/figs/graph_construct_prompt.png) 

Figure 4: Prompts for Graph Generation

The graph construction prompt outlined in Figure [4](https://arxiv.org/html/2410.05779v2#S7.F4 "Figure 4 ‣ 7.3.1 Prompts for Graph Generation ‣ 7.3 Overview of the Prompts Used in LightRAG ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation") is designed to extract and structure entity-relationship information from a text document based on specified entity types. The process begins by identifying entities and categorizing them into types such as organization, person, location, and event. It then provides detailed descriptions of their attributes and activities. Next, the prompt identifies relationships between these entities, offering explanations, assigning strength scores, and summarizing the relationships using high-level keywords.

#### 7.3.2 Prompts for Query Generation

![Refer to caption](https://g1proxy.wimg.site/sNbQ_I6tb2HxRfdF7t3_jWD8J1edv65GZe-VmkWpCAHk/https://arxiv.org/html/2410.05779v2/extracted/5984364/figs/query_generate_prompt.png) 

Figure 5: Prompts for Query Generation

In Figure [5](https://arxiv.org/html/2410.05779v2#S7.F5 "Figure 5 ‣ 7.3.2 Prompts for Query Generation ‣ 7.3 Overview of the Prompts Used in LightRAG ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"), the query generation prompt outlines a framework for identifying potential user roles (e.g., data scientist, finance analyst, and product manager) and their objectives for generating queries based on a specified dataset description. The prompt explains how to define five distinct users who would benefit from interacting with the dataset. For each user, it specifies five key tasks they would perform while working with the dataset. Additionally, for each (user, task) combination, five high-level questions are posed to ensure a thorough understanding of the dataset.

#### 7.3.3 Prompts for Keyword Extraction

![Refer to caption](https://g1proxy.wimg.site/sk2t_NiFmsIABkRyDoDtZdlFYv4cE-3sAFUpCrvIIgtc/https://arxiv.org/html/2410.05779v2/extracted/5984364/figs/Keywords_generate_prompt.png) 

Figure 6: Prompts for Keyword Extraction

In Figure [6](https://arxiv.org/html/2410.05779v2#S7.F6 "Figure 6 ‣ 7.3.3 Prompts for Keyword Extraction ‣ 7.3 Overview of the Prompts Used in LightRAG ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"), the prompt describes a method for extracting keywords from a user’s query, distinguishing between high-level and low-level keywords. High-level keywords represent broad concepts or themes, while low-level keywords focus on specific entities and details. The extracted keywords are returned in JSON format, organized into two fields: “high\_level\_keywords” for overarching ideas and “low\_level\_keywords” for specific details.

#### 7.3.4 Prompts for RAG Evaluation

![Refer to caption](https://g1proxy.wimg.site/ssbrIRki8GTEEx1LZuuKqgoZEUJ_JWTTr-qdOoYCLG68/https://arxiv.org/html/2410.05779v2/extracted/5984364/figs/evaluation_prompt.png) 

Figure 7: Prompts for RAG Evaluation

The evaluation prompt is illustrated in Figure [7](https://arxiv.org/html/2410.05779v2#S7.F7 "Figure 7 ‣ 7.3.4 Prompts for RAG Evaluation ‣ 7.3 Overview of the Prompts Used in LightRAG ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"). It introduces a comprehensive evaluation framework for comparing two answers to the same question based on three key criteria: Comprehensiveness, Diversity, and Empowerment. Its purpose is to guide the LLM through the process of selecting the better answer for each criterion, followed by an overall assessment. For each of the three criteria, the LLM must identify which answer performs better and provide a rationale for its choice. Ultimately, an overall winner is determined based on performance across all three dimensions, accompanied by a detailed summary that justifies the decision. The evaluation is structured in JSON format, ensuring clarity and consistency, and facilitating a systematic comparison between the two answers.

### 7.4 Case Study: Comparison Between LightRAG and the Baseline NaiveRAG.

Table 5: Case Study: Comparison Between LightRAG and the Baseline NaiveRAG.

To further illustrate LightRAG’s superiority over baseline models in terms of comprehensiveness, empowerment, and diversity, we present a case study comparing LightRAG and NaiveRAG in Table [5](https://arxiv.org/html/2410.05779v2#S7.T5 "Table 5 ‣ 7.4 Case Study: Comparison Between LightRAG and the Baseline NaiveRAG. ‣ 7 Appendix ‣ LightRAG: Simple and Fast Retrieval-Augmented Generation"). This study addresses a question regarding indigenous perspectives in the context of corporate mergers. Notably, LightRAG offers a more in-depth exploration of key themes related to indigenous perspectives, such as cultural significance, collaboration, and legal frameworks, supported by specific and illustrative examples. In contrast, while NaiveRAG provides informative responses, it lacks the depth needed to thoroughly examine the various dimensions of indigenous ownership and collaboration. The dual-level retrieval process employed by LightRAG enables a more comprehensive investigation of specific entities and their interrelationships, facilitating extensive searches that effectively capture overarching themes and complexities within the topic.
