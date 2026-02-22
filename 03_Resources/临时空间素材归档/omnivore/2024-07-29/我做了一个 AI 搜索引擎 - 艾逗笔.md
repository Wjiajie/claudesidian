---
parent: "[[omnivore汇总]]"
id: 0868bc8e-232e-4898-89b0-589f1c8249ca
---

# 我做了一个 AI 搜索引擎 - 艾逗笔
#Omnivore

## collectedBy
[[omnivore汇总]]

[Read on Omnivore](https://omnivore.app/me/ai-190fcd911d9)
[Read Original](https://idoubi.cc/posts/ai-search-engine/)


## content
## 前言

这是一篇两个月前就应该写的文章。

今年 3 月，我做了一个 AI 搜索引擎，名字叫做 ThinkAny，经过三个月的发展，ThinkAny 已经成长为一个月访问量 60 万的全球化产品，用户覆盖日本 / 埃及 / 俄罗斯 / 巴基斯坦等国家和地区，累计用户数突破 17 万。

我有一个习惯，每做一个新项目，都会写一篇文章进行总结。

ThinkAny 的总结文章一直拖着没写，主要原因是我有很严重的强迫症。我总觉得 ThinkAny 现在做的还不够好，想着把交互体验优化的好一些，把搜索准确度再提升一个量级之后，再来写总结文章。

然而 AI 搜索引擎这类产品，复杂性和工作量都超过了我的预期，这会是一个持久战，后面还需要投入很多的时间和精力去把产品做的更完善。

最近看了很多第三方介绍 ThinkAny 的文章和视频，总觉得没有完全表达我想表达的东西。

于是想自己写一篇文章，系统的介绍一下 ThinkAny 这款产品，以及我对 AI 搜索这个市场的一些看法。

**第一部分：ThinkAny 的发展历程**

## 介绍一下 ThinkAny

ThinkAny 是一款新时代的 AI 搜索引擎，利用 RAG（Retrieval-Augmented Generation）技术快速检索和聚合网络上的优质内容，并结合 AI 的智能回答功能，高效地回答用户的问题。

ThinkAny 的目标是：搜得更快，答得更准。

ThinkAny 的定位是做全球化市场，从第一个版本开始就支持了多语言，包括（英语 / 中文 / 韩语 / 日语 / 法语 / 德语 / 俄语 / 阿拉伯语）。

ThinkAny 的官网地址是：[https://thinkany.ai](https://thinkany.ai/)

采用双栏式布局，界面非常简洁大气。

![20240619140701](https://proxy-prod.omnivore-image-cache.app/0x0,sUQbt6Sz1ela2aRlGE-kMD8XHBE1Gj9uyhlo5pAWy5mE/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240619140701.png)

我选择做什么产品，一般有三个原则：

1. 是我很感兴趣的方向
2. 产品有价值，能带来成就感
3. 在我的能力范围内

早在去年 11 月，就有朋友建议我研究一下 AI 搜索赛道的产品。

当时我的第一想法是，搜索引擎应该是一类有很高技术壁垒的产品，不在我的能力范围，所以一直不敢尝试，也没花时间去研究。

直到今年年初，有媒体报道：“贾扬清 500 行代码写了一个 AI 搜索引擎”，当时觉得很神奇，写一个 AI 搜索引擎这么简单吗？

花了点时间研究了一下贾扬清老师开源的 `Lepton Search` 源码，Python 写的，后台逻辑 400 多行。

又看了一个叫 `float32` 的 AI 搜索引擎源码，Go 写的，核心逻辑也就几百行。

看完两个项目代码之后，开始“技术祛魅”，号称能颠覆谷歌 / 百度统治的新一代 AI 搜索引擎，好像也“不过如此”。

底层技术概括起来就一个词，叫做“RAG”，也就是所谓的“检索增强生成”。

1. 检索（Retrieve）：拿用户 query 调搜索引擎 API，拿到搜素结果；
2. 增强（Augmented）：设置提示词，把检索结果作为挂载上下文；
3. 生成（Generation）：大模型回答问题，标注引用来源；

弄清楚 AI 搜索的底层逻辑之后，我决定在这个领域开始新的尝试。

我给要做的 AI 搜索引擎产品取名“ThinkAny”，名字直译于我之前创立的一家公司“任想科技”。

## ThinkAny 是如何冷启动的

ThinkAny 第一个版本是我在一个周末的时间写完的。

MVP 版本实现起来很简单，使用 `NextJs` 做全栈开发，一个界面 + 两个接口。

两个接口分别是：

1. /api/rag-search

这个接口调用 `serper.dev` 的接口，获取谷歌的检索内容。输入用户的查询 query，输出谷歌搜索的前 10 条信息源。

1. /api/chat

这个接口选择 OpenAI 的 `gpt-3.5-turbo` 作为基座模型，把上一步返回的 10 条检索结果的 title + snippet 拼接成上下文，设置提示词，请求大模型做问答输出。

提示词参考的 `Lepton Search`，第一版内容为：

```sql
You are a large language AI assistant built by ThinkAny AI. You are given a user question, and please write clean, concise and accurate answer to the question. You will be given a set of related contexts to the question, each starting with a reference number like [[citation:x]], where x is a number. Please use the context and cite the context at the end of each sentence if applicable.

Your answer must be correct, accurate and written by an expert using an unbiased and professional tone. Please limit to 1024 tokens. Do not give any information that is not related to the question, and do not repeat. Say "information is missing on" followed by the related topic, if the given context do not provide sufficient information.

Please cite the contexts with the reference numbers, in the format [citation:x]. If a sentence comes from multiple contexts, please list all applicable citations, like [citation:3][citation:5]. Other than code and specific names and citations, your answer must be written in the same language as the question.

Here are the set of contexts:

{context}

Remember, don't blindly repeat the contexts verbatim. And here is the user question:

```

前端界面的构建也没有花太多时间，使用 `tailwindcss` \+ `daisyUI` 实现了基本的界面，主要是一个搜索输入框 + 搜索结果页。

![20240619150035](https://proxy-prod.omnivore-image-cache.app/0x0,scAYKOq3DRaE3QGInZSeZubpvIr3Clx7OeMHvBdgC8aQ/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240619150035.png)

写完基本功能后，我把代码提交到了 `Github`，使用 `Vercel` 进行发布，通过 `Cloudflare` 做域名 DNS 解析。第一个版本就这么上线了。

我在 ProductHunt 发布了 ThinkAny，在微信朋友圈 / 即刻 / Twitter 等地方发动态号召投票，当天 ThinkAny 冲到了 ProductHunt 日榜第四。

![20240619153349](https://proxy-prod.omnivore-image-cache.app/0x0,smVxCvdlk_vRyMf-oM0kRQ1y--m-6K8GlhmR7D5tlAXQ/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240619153349.png)

ProductHunt 上榜给了 ThinkAny 很大的曝光，接下来几天，在 Twitter / Youtube 等平台有用户自发传播，ThinkAny 完成了还算不错的冷启动。

![20240619153808](https://proxy-prod.omnivore-image-cache.app/0x0,sRfpq8AfCNqIVqEpf_fAJJmz3XwmHi-KN3hTs5ieAqd4/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240619153808.png)

## ThinkAny 的产品特性

![20240619154427](https://proxy-prod.omnivore-image-cache.app/0x0,smBlSsQJ8nGXzrwimTy4QL_3QTFUCS3ht7A3p6mFhGds/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240619154427.png)

ThinkAny 虽然第一个版本实现的比较简单，但在创立之初，就一直聚焦在三个核心问题。

也就是我认为的，AI 搜索的三个要义：准 / 快 / 稳。

> 准确度是 AI 搜索的第一要义。

用户之所以会选择使用 AI 搜索引擎，是因为传统搜索引擎不能第一时间给到用户想要的答案，往往需要点进去阅读几个链接的内容之后，才能得到足够多的信息。

而 AI 搜索引擎，解决的第一个问题就是搜索效率问题，用 AI 代替人工，阅读检索内容，总结归纳后给到用户一个直接的答案。

而这个答案，一定要有足够高的准确度。这是建立用户信任的基础，如果准确度不达标，用户使用 AI 搜索的理由就不成立。

影响 AI 搜索的两个关键因素：挂载的上下文信息密度 + 基座模型的智能程度。

ThinkAny 在基座模型的选择上，集成了 gpt-4-turbo / claude-3-opus 等大参数模型，有非常高的智能程度。

在上下文信息密度的问题上，采取了并行读取多个链接内容，暴力传输全部内容的策略。

ThinkAny 也缓存了历史对话，支持对搜索结果进行追问（连续对话）。

> AI 搜索的响应速度要足够快

AI 搜索的底层原理是 RAG，涉及到 Retrieve 和 Generation 两个步骤。Retrieve 要求联网检索信息的速度足够快，Generation 要求大模型生成内容的速度足够快。

除了这两个步骤之外，为了提高搜索结果的准确度，需要对检索结果进行重排（Reranking），需要获取检索到的内容详情（Read Content），这两个步骤往往是耗时的。

所谓鱼与熊掌不可兼得，在 AI 搜索准确度与响应速度之间，需要找到一个平衡。为了保证搜索准确度，有时候需要牺牲响应速度，加一些过渡动效来管理用户等待预期。

ThinkAny 目前采取的方案是，通过开关控制是否获取详情内容，线上的版本暂时关闭。表现是响应速度非常快，但准确度不够高。

后续的版本会重点优化准确度，在准与快之间找到一个更好的平衡。

> AI 搜索要保证高可用

软件产品的服务稳定性（高可用）是一个很常见的话题，用户规模起来之后，是必须要重视的一项工作。

影响 ThinkAny 可用性的因素，第一个是下游依赖，也就是搜索 API 与基座模型 API 的稳定性。

ThinkAny 最初的版本，大模型问答用的是 OpenAI 官方接口，有时候会遇到响应超时和账号封禁的问题，非常影响可用性，后来切到了 `OpenRouter` 做多模型聚合，稳定性有了很大的提高。

ThinkAny 当前的线上服务采用的是 `Vercel` \+ `Supabase` 的云平台部署方案。用户量和数据量起来之后也有会比较大的性能瓶颈，目前也在基于 `AWS` 搭建自己的 `K8S` 集群，后续迁移过来，在服务稳定性和动态扩容方面会有更好的表现。

除了以上三个核心问题之外，ThinkAny 五月初发布的第二个大版本，在功能差异化方面做了很多创新。

1. 多模式使用 Multi-Usage-Mode

支持 Search / Chat / Summarize 三种模式，对应检索问答 / 大模型对话 / 网页摘要三种使用场景。

![20240619163507](https://proxy-prod.omnivore-image-cache.app/0x0,snl5CQUtXlcndrzeE5oSoXqns4mgDcY6X9pz-9ZKnEYY/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240619163507.png)

1. 多模型对话 Multi-Chat-Model

集成了包括 Llama 3 70B / Claude 3 Opus / GPT-4 Turbo 在内的 10+ 大语言模型。

1. 多模态检索 Multi-Mode-Search

支持检索链接 / 图片 / 视频等模态内容

1. 多维度输出 Multi-Form-Output

支持以对话 / 大纲 / 思维导图 / 时间线等形式输出搜索问答内容。

![20240625150128](https://proxy-prod.omnivore-image-cache.app/0x0,sZLcJVmB_b4LcG3FoJzPJJzULj5oWYVAzGGXvZXuTQOc/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240625150128.png)

1. 多信源检索 Multi-Retrieve-Source

支持检索 Google / Wikipedia / Github 等信息源的内容，作为搜索问答的挂载上下文。

另外，ThinkAny 还开源了一个 API 项目：[rag-search](https://github.com/thinkany-ai/rag-search)，完整实现了联网检索功能，并对检索结果进行重排（Reranking）/ 获取详情内容（Read Content），最终得到一份准确度还不错的检索结果。

![20240619163823](https://proxy-prod.omnivore-image-cache.app/0x0,skyFm3KWHiA9fNWoD1z6bQfEcG-iomJ22-CD71vOZGX8/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240619163823.png)

ThinkAny 产品的长期发展方向，会走 AI Search + Anything 的平台化路线。

允许用户挂载自定义信息源（Sources）/ 创建自定义智能体（Agents）/ 实现自定义的流程编排（Workflows）

ThinkAny 要保证基础能力的完备性，结合第三方的创意，实现一个更智能的 AI 搜索平台，覆盖更多的搜索场景。

## ThinkAny 的运营情况

ThinkAny 于 2024/03/20 正式发布上线，当天获得 ProductHunt 日榜第四的成绩。

3 个月累计用户 170k，日均 UV 3k，日均 PV 20k，日均搜索 6000 次。

![20240619181257](https://proxy-prod.omnivore-image-cache.app/0x0,sSu_wTo1GoF2XSfG1FMfZHhxC4M24iDbAsWRnTTa4z1E/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240619181257.png)

主要用户分布在埃及 / 日本 / 印度 / 美国 / 中国和其他中东地区。

![20240619181548](https://proxy-prod.omnivore-image-cache.app/0x0,sjFoJtXuOsQxIuJ3GjGgs23cCXPYEfHiVvnqs0tDau_c/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240619181548.png)

月访问量 580k（基于 similarweb 数据估算），5 月实际访问量较 4 月份增长 90%。

![20240619181354](https://proxy-prod.omnivore-image-cache.app/0x0,sxNYe4LO_CmRQ2m8dtFmLzk78tutKKC3jQ6oQRqEkv9A/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240619181354.png)

根据 YouTube / Twitter 等平台的用户反馈，用户最喜爱的功能是 ThinkAny 对搜索结果的思维导图摘要功能。

5 月份发布的第二个大版本，上线了用户增值付费功能，然而目前统计到的支付率比较低，仅为 0.03% 左右。

主要支出在于搜索 API 和大模型 API 的成本，当前还未实现营收平衡。

**第二部分：关于 AI 搜索的认知分享**

## AI 搜索的标准流程

AI 搜索，一般有两个流程：一个是初次检索， 另一个是检索后追问。

用一张流程图表示如下👇

![20240625165151](https://proxy-prod.omnivore-image-cache.app/0x0,srpWrlFg4bzH0oLT29nWjvlJnga9TAWt2z0IFNZUMs6Y/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240625165151.png)

对于初次检索的处理，大部分的 AI 搜索引擎产品都是一致的步骤。

而对于追问的处理，不同的 AI 搜索产品可能会有不同的处理方案。

比如 Perplexity 的追问模式，会继续走联网检索的流程，拿到新的引用信息后，再进行回答。

ThinkAny 目前的版本，只在初次搜索的时候联网检索，后续的追问不再重新检索。

主要考虑的是，大部分场景下，用户追问是针对初次回答的补充性提问，初次检索的结果作为回答参考已经足够，重新联网检索没有太大的必要性，浪费时间，浪费成本，也更容易造成幻觉。

然而，有时候追问也需要联网检索新的参考内容，只检索初次 query 的方案并不适用于所有场景。

后续的版本，ThinkAny 打算通过 Context Pool 来改写追问逻辑，允许联网检索新的引用内容，通过链接过滤降低 Context Pool 中引用内容的重复度，最大可能提升多轮问答的准确度，降低幻觉。

## AI 搜索如何提升准确度

上面讲到了，AI 搜索的第一要义是准确度。影响搜索准确度的两个关键因素是：挂载的上下文信息密度 + 基座模型的智能程度。

对于一个 AI 应用层产品，项目前期不太需要关心模型层面的事情，我们也没有太多精力去从模型层面进行突破。

在基座模型的选择上，如果不考虑成本的问题，优先使用 gpt-4-turbo / claude-3-opus 等模型，暴力传输所有的检索内容，也能有比较好的效果。然而，有时候也会有比较大的幻觉问题。如果支持追问，对话轮数多了之后，会面临 context 长度的瓶颈问题。

提升 AI 搜索引擎的准确度，另一个方向是优化检索得到的上下文信息密度。主要包括以下几个措施：

1. 意图识别 Intent Detection

在联网检索之前，先对用户的 query 进行意图识别（Intent Detection）。意图识别的目的是对用户的搜索意图进行分类，路由到合适的信息源，召回更精准的参考信息。

首先，可以判断用户 query，是否需要联网。

比如，用户输入：“你好”，“你是谁”，“10 的 9 次方等于多少”之类的问题时，可以不联网检索参考信息，直接用大模型训练好的知识库进行回答。一些数学问题 / 编程问题 / 生活常识问题，有标准答案的，就不需要再联网检索。

判断是否联网，可以节省一次搜索成本，也能更快速的响应用户提问，提升搜索效率。

主要实现方案有两种：

第一种是内置问题库，把无需联网的常见问题缓存起来，再跟用户提问做相似度匹配，如果用户提问命中关键词库，就直接大模型回复，不联网检索。

第二种是设置提示词，请求大模型判断是否需要联网。

第一种方案会有枚举无法穷尽的问题，第二种方案主要问题在于大模型的识别准确度不够高。

意图识别另一个关键作用，是对用户提问进行分类，比如可以把用户的搜索意图分为：

* 导航类：用户希望找到特定的网站或网页。例如：搜索“ThinkAny”，是为了打开 ThinkAny 官网；
* 信息查询类：用户希望找到某个问题的答案或关于某个事物的详细信息。例如：搜索“什么是 AI 搜索引擎”，是为了了解这类产品或这个行业；
* 交易类：用户希望进行某种交易。例如：搜索“笔记本电脑”是为了找到电脑相关的产品信息和价格信息，并进入推荐的电商网站购买。
* 本地信息类：用户希望根据特定地理位置查找本地信息。例如：搜索“附近的烤肉店”是为了找到附近的餐馆。

还有其他一些分类，包括多级子分类。照样面临枚举无法穷尽的问题。

对搜索意图进行分类，可以匹配更准的信息源和更好的回复提示词。

比如搜索“笔记本电脑”，如果能提取出一个“shopping”意图，就可以挂载亚马逊 / 淘宝 / 京东等电商平台的信息源进行更小范围内的搜索，召回的信息会更加精准。同时也可以加载跟此类搜索意图匹配的提示词模板，来控制搜索后的大模型回答内容。

意图分类是搜索前一个非常关键的步骤，可以很大程度提升检索召回率，通过不同的提示词模板总结输出，保证了搜索结果的个性化。

目前主流的实现方案，主要是通过提示词，请求大模型完成识别。不管是成熟的大模型，还是微调的小模型，准确度都不够高。

大模型提供的 `Function Calling` 能力也可以理解为一种意图识别。

1. 问题改写 Query Rewrite

在完成意图识别，确认需要联网检索之后。可以对用户的 query 进行改写（Rewrite）。Query Rewrite 的目的，是为了得到更高的检索召回率。

Query Rewrite 可以通过设置提示词请求大模型完成。

主要包括三个维度的改写：

* 让提问有更精准 / 更专业的表达

比如用户搜索：“ThinkAny”，改写后的 query 可以是：“ThinkAny 是什么？”，再把问题翻译成英文：“What is ThinkAny”，同一个问题，双语分别检索一次，得到更多的参考信息。

* 补全上下文，做指代消解

比如用户搜索：“ThinkAny 是什么？”，得到第一次回复后继续追问：“它有什么特点？”，用历史对话内容作为上下文，把第二次 query 改写成：“ThinkAny 有什么特点？”，指代消解后再去检索，会有更高的召回率。

* 名词提取

比如用户搜索：“ThinkAny 和 Perplexity 有什么区别？”，可以把 “ThinkAny” 和 “Perplexity” 两个名词提取出来，分别检索。

1. 多信息源聚合 Multi Source

提升 AI 搜索准确度，另一个关键措施就是做多信息源整合。

结合上面提到的意图识别和问题改写，假设用户搜索：“ThinkAny 和 Perplexity 的区别是什么？”，根据意图识别，判断需要联网，并且是信息查询类的搜索意图。

在问题改写阶段，提取出来 “ThinkAny” 和 “Perplexity” 两个概念名词，除谷歌检索之外，还可以检索 Wikipedia / Twitter 等信息源，拿到百科词条内容和 Twitter 的用户反馈信息，可以更好的回答这个问题。

> AI 搜索最大的壁垒在于数据。

多信息源的整合，可能会涉及到海量数据的处理，包括自建信息源索引等技术，传统搜索厂商做这件事会更有优势。

依靠 UGC 建立数据飞轮的超级 App，在垂类数据的整合上，也会更有优势。比如腾讯元宝整合的公众号数据，小红书自身的衣食住行攻略类数据，知乎的时事评论数据等，都有比较深的护城河。

1. 搜索结果重排 Reranking

AI 搜索如果要做多信息源整合，免不了要对多信息源的检索结果做重排（Reranking）。

重排的目的主要是两个：

* 过滤掉跟搜索 query 不相关的参考信息
* 对参考信息的相关性进行排序，便于做上下文挂载时，有限截取权重最高的 top\_k 条记录作为引用参考

第一点很好理解，多信息源的检索内容受限于信息源自身的搜索实现，有可能出现搜出来的结果不太匹配的情况。就算是谷歌这种聚合信息源，也会受到 SEO 的干扰，返回跟搜索 query 并不匹配的结果。

第二点主要考虑到 context 长度问题，我们可能不太愿意暴力传输所有的检索结果，而是选择其中的 top\_k 条结果，获取详情，再作为上下文挂载内容。Reranking 的目的就是为了让最有可能包含准确信息的结果排到最前面，不至于出现信息遗漏。

做重排的方案有很多，ThinkAny 尝试过的方案有两种：

* 使用 zilliz 向量数据库 + llamaindex 框架做相似度匹配
* 使用 FlashRank 开源框架

第一种方案主要问题是效率比较低，第二种方案测试下来准确度不够高。

1. 搜索内容读取 Read Content

很多的信息源（比如谷歌）返回的检索结果，只包含链接 + 摘要信息。如果要保证足够的信息密度，免不了要获取链接对应的详情页内容（Read Content）。

上一步的 Reranking 让我们可以选择其中最匹配的 top\_k 条数据，而不至于获取全部内容导致 context 超限。

为了保证获取详情内容的效率，我们需要做一定的并行处理。比如通过 goroutine 或者 python 的协程并行读取 top\_k 条链接，在一次请求耗时内拿到 top\_k 条链接的全部内容。

获取链接详情内容有很多方案，包括网页爬虫 / 无头浏览器抓取 / 第三方 Reader 读取等。

ThinkAny 目前使用的是 `jina.ai` 的 Reader 方案。做了一个开关，控制是否获取链接详情，为了保证响应速度，线上的版本暂时未开。

1. 构建上下文内容池 Context Pool

提高 AI 搜索的准确度，上下文的控制也是一个非常重要的手段。

比如可以构建一个上下文内容池（Context Pool） = 历史搜索结果（Search Results）+ 历史对话消息（Chat Messages）

每次搜索后追问，都带上这个 Context Pool 做意图识别 / 问题改写，拿到新的检索结果后更新这个 Context Pool，并带上最新的 Context Pool 内容作为上下文请求大模型回答。

Context Pool 里的 Search Results 可以根据链接做去重，Chat Messages 可以根据相似度匹配做过滤。

需要保证 Context Pool 的内容有较高的信息密度，同时要控制 Context Pool 的内容长度，不要超过大模型的 context 极限。

对 Context Pool 的构建和动态更新，是一个非常有挑战性的事情，如果能做好，对搜索结果的准确度提升也能起到非常大的帮助。

1. 提示词工程 Prompt Engineering

提升 AI 搜索的准确度，在提示词的设计和调试方面也需要花很大的功夫。

上述的很多个环节，都需要用到提示词，比如：

* 通过提示词请求大模型判断是否需要联网
* 通过提示词请求大模型改写问题，提取关键词
* 通过提示词请求大模型回答问题，标注引用来源
* 通过提示词请求大模型以思维导图的形式输出答案
* 通过提示词请求大模型做 Function Calling 判断使用的 Agents

提示词工程是一个很系统的学科，有实操指南，有方法论。不能一招通吃，只有经过大量调试，才能设计出一套适合自身业务的提示词。

1. 多模态检索 Multi Mode

提升 AI 搜索的关键步骤是保证检索到的信息密度。只拿信息源检索返回的摘要内容肯定不够，前面我们也提到了要并行获取多个链接的详情内容。

多模态检索是提升信息密度的一个重要措施。随着 5G 的发展，互联网上的信息越来越多元化，图片/视频/音频占了很大的比重。多模态检索就是为了尽可能多的获取不同形式的信息，再聚合起来作为引用参考。

多模态检索的实现是非常困难的。涉及到海量信息源的处理和识别。现阶段可以在谷歌搜索的基础上完成多模态检索的需求。

第一步我们可以使用谷歌的图片/视频检索 API，拿到跟 query 匹配的图片/视频内容。第二步要做的工作是通过 OCR 图片识别 / 音视频转录等方法，拿到多模态信息的文本内容。

第一步检索多模态内容很简单，有现成的 API 可以用。第二步提取多模态内容要麻烦一些，可以在 huggingface / modelscope 等平台找到可用的图片识别 / 音视频转录模型。或者使用 gpt-4-o / gemini-1.5-pro 等模型做多模态内容识别和信息提取。

作为一个应用层产品，现阶段我们在多模态信息处理层面能做的事情是非常有限的。随着基座模型的能力提升，后续对多模态的处理会越来越简单。

## AI 搜索如何提升可玩性

AI 搜索引擎，最重要的是准确度。

在保证较高准确度的前提下，也要尽可能提升 AI 搜索产品的可玩性。让 AI 搜索集成更多的能力，允许第三方创作，覆盖到更多的使用场景。

提升 AI 搜索可玩性的关键是让 AI 搜索平台化。走 AI Search + Anything 路线。

AI 搜索平台化主要包括以下几个层面：

1. 开放接口 API

AI 搜索相比于 ChatBot 类应用，普遍的感知是加上了联网检索功能，再由大模型完成回答。

AI 搜索类产品，可以把联网判断 / 意图识别 / 问题改写 / 信息源检索等步骤封装进一个黑盒，导出一套标准 API，让 ChatBot 类产品可以快速集成。

最常见的做法是定义一个 /chat/completions 接口，请求参数跟响应参数与 OpenAI 的 /chat/completions 接口完全兼容。

开放 API 之后，ChatBot 类应用只需要修改 API 的域名前缀，就可以快速集成联网检索功能。

对于 AI 搜索产品自身，也多了一条 to 小 B 的路子，在增加营收方面会有帮助。

1. 自定义信息源 Source

前面讲到了多个信息源的整合检索，是提升 AI 搜索准确度的一种有效手段。

信息是海量的，遍布在各个孤岛。依靠 AI 搜索产品自身去整合所有的信息源肯定不现实。AI 搜索平台化的关键之一是允许用户自定义信息源，满足更加个性化的搜索需求。

比如，允许第三方创作者自定义信息源，通过 Form 表单填写信息源的域名 / 路由信息 / 参数信息 / 鉴权方式等内容，调试通过后完成对自定义信息源的集成。

普通用户使用 AI 搜索的时候，可以通过主动选择或者意图识别的方式路由到自定义信息源，检索得到更加精准的数据。

自定义信息源甚至可以挂载私域数据，比如通过 Oauth2 协议让用户授权对 Notion 笔记 / Github 代码仓库的访问，拿到用户的私有数据。

当然这里最大的挑战是隐私问题和用户信任问题，需要设计安全的鉴权方式，同时要让用户点击隐私协议，允许对私域数据的访问。

1. 自定义提示词 Prompt

前面讲到了 Prompt Engineering 在提升 AI 搜索准确度方面的重要性。

Prompt Engineering 在 AI 搜索平台化和个性化方面也能发挥很大的作用。

用户可以通过提示词自定义 AI 搜索的输出格式。比如有人喜欢简短直接的答案，有人需要长篇大论的研究报告，有人喜欢结构化的输出。通过自定义提示词，控制大模型最后的回复格式，把提示词保存为个人喜好，可以做到搜索回答千人千面，极具个性化。

AI 搜索平台要做的，是提供一个好用的提示词调试面板，和示例的提示词参考，降低用户创建 / 调试提示词的门槛，保存用户的个性化设置。

1. 自定义插件 Plugin

可以在 AI 搜索平台预置一些钩子 Hook，用来挂载插件 Plugin 做能力补齐和自定义输出。

比如，可以预置一个 before\_retrieve 钩子，在发起信息源检索请求之前，把用户 query 发给一个第三方插件，由第三方插件来做意图识别和问题改写。

比如，可以预置一个 after\_answer 钩子，在大模型回答完用户 query 之后，把请求大模型的上下文信息和大模型的回答内容一起发给第三方插件，第三方插件可以把内容整理成文章 / 思维导图等格式，再同步到第三方笔记软件。

在整个搜索回答的全流程，有很多节点可以做 Hook 埋点，每个 Hook 可以挂载零至多个插件，多个插件构成了 AI 搜索的可插拔架构，这套架构让 AI 搜索的全流程变得高度可定制，可玩性更高。

一些常用的功能，可以由 AI 搜索平台自身或第三方创作者抽离成标准插件，用在AI 搜索主流程或者智能体 / 工作流等辅助流程。

比如，自定义一个思维导图摘要插件，输入内容是一段文本，输出内容是基于 toc（table of contents）构成的思维导图。用户可以在搜索的步骤中选择这个自定义插件，实现用思维导图输出搜索结果。

1. 自定义智能体 Agent

智能体是现阶段 ChatBot 类产品经常用到的一种辅助产品形态。

智能体一般是对一些自定义操作的封装，用于解决某个场景的某类问题。

以 ChatGPT 的 GPTs 举例，一个智能体应用由以下几部分自定义操作组成：

* 提示词：描述智能体的作用，定义智能体的回复格式
* 知识库：上传私有文件作为回答参考
* 外挂 API：请求第三方 API 获取实时数据
* 个性化配置：是否联网 / 是否使用图片生成 / 是否使用数据分析等

AI 搜索的智能体也大体如此，外挂 API 的操作实际上就是挂载自定义信息源做检索。

以 Kimi+ 的“什么值得买”智能体举例，假设用户输入“我想买个笔记本电脑”，智能体会先做 Query Rewrite 提取出“笔记本电脑”关键词，再通过“什么值得买”的 API 检索对应的商品信息，拿到检索结果后，跟智能体内置的提示词组装成上下文，请求大模型回答。于是这个智能体便成了一个电商导购类的垂直搜索应用，在商品推荐方面有更好的回答效果。

1. 工作流 Workflow

工作流 Workflow 也可以理解为多智能体协作 Multi-Agents，通过多个智能体的组装，解决一些复杂场景的搜索问题。

比如：给新产品取名，我习惯的步骤是

* 告诉大模型新产品是做什么的，大模型推荐几个可取的名字
* 选择其中一个名字，去谷歌检索，是否有同名
* 去 Twitter 检索是否有同名
* 去 Github 检索是否有同名
* 选择一个域名，去 Namecheap 搜索是否已被注册
* 全部检测通过，确定产品名，注册域名

这里涉及到一个回溯的问题，也就是在其中某个步骤发现产品名不可用，要回到第一步重新选择名字，再继续走后面的检测步骤。

人工去做这件事，毫无疑问是很费时间的。

AI 搜索 + Workflow 的模式，可以有效解决这个问题。

首先定义几个智能体，每个智能体完成一项功能。比如 A 智能体只负责给出建议的名字，B 智能体负责检索谷歌是否有同名，C 智能体负责检索 Twitter 是否有同名，D 智能体负责检测 Github 是否有同名，E 智能体负责检测可用的域名…

另外还需要有一个调度中枢，协调每个智能体的工作，需要做决策，决定是继续下一步还是回溯到之前的步骤。

工作流编排除了有很复杂的逻辑判断之外，也会有很复杂的前端交互。比如多个智能体的拖拽 / 排序 / 连线等。

工作流编排让 AI 搜索的可玩性最大化，能够覆盖到足够多，足够复杂的场景，想象空间很大。

## AI 搜索与内容生态

对于 AI 搜索，还有一个普遍的认知是：仅靠单边检索，用大模型问答来做检索信息的整合摘要，价值点是非常低的，也很难实现颠覆传统搜索引擎的目标。

因此 AI 搜索 + 内容生态也是目前很多产品在探索的一个方向。

比如 Perplexity 推出了 Pages 功能，允许用户把搜索结果整理成一个内容页面，作为文章发表。比如最近进入国内用户视野的 Genspark，主打一个 Sparkpage 功能，也是基于用户的搜索行为，用 AI 生成结构化的内容（包括文字 / 图片等多模态内容），并允许用户编辑，导出成 Page。

> AI 搜索产品发展自己的内容生态，是一个非常有价值的方向，内容自产自销，形成一个有效的闭环，依靠数据飞轮构建产品的护城河。

这里的关键问题，在于 AI 生成的内容质量要高，有一个用户信任的建立过程。

关于 AI 搜索的另一个思考，要从我们与信息打交道的全流程做拆解：

包括信息获取 / 信息摘要 / 信息生产 / 信息分发这几个步骤。

AI 搜索的单边检索，解决的是信息获取 + 信息摘要的问题。

AI 搜索通过 Pages 生成内容，允许用户编辑内容，解决的是信息生产的问题。

AI 搜索平台化，允许把内容同步到第三方平台，解决的是信息分发的问题。

用户订阅关键词获取某类信息的定时推送，可以理解为信息匹配与信息分发的结合，是一个双边操作。

充分理解用户与信息之间的关系与交互流程，用高质量的内容满足用户需求，能够进一步提升 AI 搜索产品的价值。

## AI 搜索当前的竞争格局

AI 搜索无疑是今年开年以来最卷的一个赛道。

Perplexity 被认为是全球市场的第一个 AI 搜索产品，起步于 2022 年 12 月，在 ChatGPT 还没有席卷全球之前，率先以搜索 + 模型问答作为切入点，做出了 AI 搜索的产品雏形。

经过一年多的发展，Perplexity 已经成长为全球市场最大的 AI 搜索引擎产品，最新估值高达 30 亿美金。

在 Perplexity 之后，AI 搜索领域不断有新的产品涌现。我主要从以下几个维度对这个市场的竞争格局做一个简单的分析。

* 产品形态

AI 搜索目前主要有两类产品形态。

一类是大模型厂商或第三方推出的 ChatBot，主要交互是一个对话框 + RAG 联网检索。

这类产品包括 ChatGPT / Kimi Chat 等。

另一类是专门做 AI 搜索的产品，主要交互是一个搜索框 + 搜索详情页。

这类产品包括 Perplexity / 秘塔 等。

以上两类产品形态，除了在交互形式上有所差异。在产品侧重点方面也有所不同。ChatBot 类产品依赖的是大模型的理解能力提供问答服务，RAG 检索作为一个补充手段，弥补大模型在实时信息获取方面的不足。

而专门做 AI 搜索的产品，主要侧重点在检索，优先保证检索召回的信息质量，在首次回答的准确度方面有所要求。而对话（Chat）则作为一个补充步骤，方便用户对检索结果进行追问或二次检索。

很难下结论这两种产品形态哪种更好，跟用户的喜好和使用习惯有关，因人而异。

这两类产品都可以归类于 AI 搜索的大赛道，在做竞争分析的时候，难免要对比分析大模型厂商推出的 ChatBot 应用。

* 市场定位（出海 or 国内）

从今年二月份以来，AI 搜索赛道不断有新的产品出来，在市场定位有所差异。

我们看到的，大部分聚焦在国内。比如大模型厂商推出的 ChatBot 产品（智谱清言 / Kimi Chat / 百小应 / 海螺 AI 等），比如搜索厂商或创业团队推出的 AI 搜索产品（360 AI 搜索 / 秘塔 / 博查 AI / Miku 等）

海外也有很多成熟的和新出的泛 AI 搜索产品（Perplexity / You / Phind 等）

中国公司和团队也有面向全球市场的出海产品（ThinkAny / GenSpark / Devv 等）

关于市场定位的问题，跟创始团队的背景或认知有关，没有绝对的好坏。

ThinkAny 选择出海做全球市场，主要考虑的是：

1. 国内竞争太激烈，卷不过
2. 国内用户付费意愿不高，不太好做商业化
3. 国内有些政策风险，没有成熟的法务合规团队，不太敢尝试
* 通用搜索与垂直搜索

除了市场定位，从解决的需求或面向的群体分类，可以分成通用搜索和垂直搜索两类。

比如 Perplexity / ThinkAny 是通用搜索。

Phind / Devv / Reportify 是垂直搜索。

通用搜索一般可以认为，没有明显的受众倾向，任何人可以搜任何问题，都能得到一个相对还不错的搜索结果。

垂直搜索跟通用搜索比，一般会面向特定的人群或特定的领域，对特定的信息源做索引和优化，在某类问题的搜索上会有更好的结果。比如 Devv 主要面向的是开发者人群，问编程相关的问题，搜索结果和回复准确度都比较高，问旅游或其他类型的问题，回答质量则不如通用搜索。

通用搜索和垂直搜索的好坏，也没有客观的评判标准。普遍的认知是：

通用搜索覆盖的场景更多，面向的人群更广，天花板更高，能做到更大的规模。

垂直搜索面对的市场相对小众，但是可以更加聚焦，在数据源整合 / 回复优化方面实现起来更容易，对某类特定的问题回答的更好，会有更强的用户粘性和付费意愿。

可以拿独立的滴滴打车 App，和在微信钱包里的滴滴打车小程序做一个类比。用户在需要打车的时候可能更习惯使用滴滴打车 App，但是回到移动互联网初期，创业者会更想要做一个微信。

* 商业搜索与开源搜索

AI 搜索赛道不断有新的产品出现，竞争非常激烈。

对于后来者，为了抢占市场，会选择开源的路线。比如 Perplexica / LLM-Anser-Engine 等项目。

开源是一种有效的增长手段，可以短时间内积累大量用户，依靠口碑传播，对品牌曝光 / 流量增长都有很大的促进作用。

ThinkAny 选择了走商业搜索的路线，同时也开源了一个 RAG-Search 项目，把 API 能力开源了，积累了一定的影响力，对 ThinkAny 的品牌曝光也起到了一定的促进作用。

后续的计划，还是会持续迭代 ThinkAny SaaS 产品。同时也会保持开源项目的更新，把通用能力抽离出来，赋能到更多的 AI 搜索场景。

* 投融资环境与资本态度

ThinkAny 四月份数据出来之后，增长还不错。因此我有了找投资的想法。

最近一个多月也陆陆续续聊了一些投资机构。总结了一些投资人对 AI 搜索赛道的看法，以及当前的资本环境。

1. 大环境恶化，经济下行，基金的数量和规模都大不如前了；
2. 基座模型拿走了太多的钱，资本在应用层领域出手非常谨慎；
3. 资本很关注大厂的竞争，AI 搜索是传统大厂（谷歌 / 百度 / 360）和大模型厂商的战略方向，必定会重点投入的，小规模团队没什么优势，面临的竞争非常大；
4. 资本比较关注团队配置，个人独立开发不太行得通，这是一场比较大的仗，需要精兵强将；
5. AI 搜索最大的壁垒在于数据，拼的是资源整合能力。所有人都在明牌，讲故事的逻辑行不通了；
6. 打铁还需自身硬，比起讲故事，最重要的还是自身做增长，尽快找到 PMF，自给自足；
7. 资本雪中送炭的概率更低了，更多的是锦上添花的作用；

## 我对 AI 搜索的看法

之前传出 ChatGPT 要做 AI 搜索引擎，有人问我对这件事情的看法，我在社交平台分享了一些个人观点：

1. AI 搜索引擎的第一要义是准确度。

准确度的决定性因素主要是两个：问答底座模型的智能程度 + 挂载上下文的信息密度。

做好 AI 搜索引擎的关键，选用最智能的问答底座模型，再对 RAG 的检索结果进行排序去重，保证信息密度。

第一个步骤容易，第二个步骤很难。所以现在市面上大部分的 AI 搜索引擎，包括 Perplexity，准确度也就 60% 左右。

1. ChatGPT自己做搜索，首先保证了问答底座模型的智能程度。

其次在检索联网信息层面会做黑盒优化，包括 Query Rewrite / Intent Detection / Reranking 这些措施。

最终依赖自身模型的 Long Context 特性，效果就能做到比其他纯 Wrapper 类型的 AI Search Engine 要好一点。

1. 我并不觉得大模型厂商自己做 AI 搜索 就一定会比第三方做的好。

比如我做 ThinkAny， 首先接入 claude-3-opus，在模型底座智能程度方面，就不会输 gpt-4，第三方甚至能有更多的选择，针对不同的场景切换不同的模型。

其次，Long Context 也有很多模型能够保证。

再者，工程层面对 RAG 挂载上下文内容的优化，ChatGPT 能做，第三方也可以做。

1. 做好 AI 搜索引擎，最重要的三点是准 / 快 / 稳，即回复结果要准，响应速度要快，服务稳定性要高。

其次要做差异化创新，错位竞争。比如对问答结果以 outline / timeline 等形式输出，支持多模态搜索问答，允许挂载自定义信息源等策略。

1. AI 搜索引擎是一个持续雕花的过程。

特别是在提升准确度这个问题上，就有很多事情可以做，比如 Prompt Engineering / Query Rewrite/ Intent Detection / Reranking 等等，每个步骤都有不少坑。

其中用 function calling 去做 Intent Detection 就会遇到识别准确度很低的问题。

用 llamaindex + embedding + Vector DB 做 Reranking 也会遇到排序效率低下的问题。

1. AI Search + Agents + Workflows 是趋势。

AI Search 做通用场景，通过 Agents 做垂直场景，支持个性化搜索需求。

通过 Workflows 实现更加复杂的流程编排，有机会把某类需求解决的更好。

使用 GPTs 做出的提示词应用或知识库挂载型应用，价值点还是太薄。

1. 我个人不是太看好垂直搜索引擎。

一定程度上，垂直搜索引擎可以在某个场景做深做透，但是用户的搜索需求是非常多样的，我不太可能为了搜代码问题给 A 产品付费，再为了搜旅游攻略给 B 产品付费。

垂直搜索引擎自建 index 索引，工程投入比较大，效果不一定比接 Google API 要好，而且接入的信息源太有限。

1. AI 搜索是一个巨大的市场，短时间内很难形成垄断。

海外 Perplexity 一家独大，国内 Kimi/秘塔小范围出圈。各家的产品体验，市场占有率还没有达到绝对的领先，后来者依然有机会。

1. AI 搜索引擎需要尽早考虑成本优化。

主要支出在于大模型的 token 成本和搜索引擎的 API 请求费用。

成本优化是个持续的过程，比如可以自行部署 SearXNG 来降低搜索的成本，部署开源模型来降低大模型的 API 调用成本。

day one payment，趁早向用户收费也许是一种 cover 成本的好办法，但是也要考虑用户流失的问题。

## 总结

以上内容分享了 ThinkAny 这款产品的发展历程以及我对 AI 搜索这件事的一些看法和认知。

AI 搜索是一个很性感的赛道，很多的创意可以加上，也有机会做大做强。

ThinkAny 接下来的重点投入方向主要两个：

1. 提升 AI 搜索的准确度；
2. 提升 AI 搜索平台的可玩性；

个人能力有限，认知不足，很难完全 cover 住，希望能找到一些志同道合的朋友一起来做这件有意思的事情。

![20240625155143](https://proxy-prod.omnivore-image-cache.app/0x0,sWjAt86Dq9hSEir1X9xnZrCa2aLUPcOysNKm8m9AJDqY/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240625155143.png)

> 做难而正确的事情，长期主义。
> 
> 虽然前路艰险，依然砥砺前行。
> 
> The only limit to our realization of tomorrow is our doubts of today.

![20240625160249](https://proxy-prod.omnivore-image-cache.app/0x0,smariHOBWcOCx7LO1d7tpKOwHYYs95Rvmv0TBPeB4ZAQ/https://zknown-1251007641.cos.ap-guangzhou.myqcloud.com/images/20240625160249.png)

