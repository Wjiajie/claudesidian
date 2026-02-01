---
id: bacf1ab1-4080-4b42-bd48-b8877748d1be
---

# DataGemma | 连接 LLM 与现实世界数据，应对 "幻觉" 挑战
#Omnivore

## collectedBy
[[omnivore汇总]]

[Read on Omnivore](https://omnivore.app/me/data-gemma-llm-1922a0de0f6)
[Read Original](https://mp.weixin.qq.com/s?__biz=MzAwODY4OTk2Mg%3D%3D&abtest_cookie=AAACAA%253D%253D&ascene=56&chksm=81cf8f4184472a11d34b21e68582a2191acdc6ae67adc7a561e749b51ab2fd0e12260f9f17f5&clicktime=1727281807&countrycode=CN&devicetype=android-34&enterid=1727281807&exportkey=n_ChQIAhIQDpqi9OrOedLr4Vqja26xZBLxAQIE97dBBAEAAAAAAED5GeksnCwAAAAOpnltbLcz9gKNyK89dVj09UOYIbcRn1B88YwUkHxDdI%252BJjJEKblTd9fzZjS4NSfPAmhPB%252Bi7QyswXZZ4hvsAnRq4vgql2d%252FgZ983b%252BfVQdwzfQiEj19VIv6FUhTTAmEirXoR345bJlgMvtloRDBfy46LrwrQPM%252BAr1E0aEZ7YRxBo%252FMV3HuRL9Jv%252Brjf9DtrwJv5iiXv6ojS1debtabAvuGf48eHoUM08js0L7hdKutlwRikW6edbBmBaaVFDZskmA7NBw8d%252F0J6hDW8U5Krwq00jkH5s4KuhU7I%253D&fasttmpl_flag=0&fasttmpl_fullversion=7399309-zh_CN-zip&fasttmpl_type=0&finder_biz_enter_id=4&flutter_pos=0&idx=1&lang=zh_CN&mid=2652148507&nettype=3gnet&pass_ticket=rreKFjB38D%252F9boxNArXnAtlbcJUq%252BASyznTYvm7HRoDspwFTR%252BwJYmLG7%252BdCJeHx&ranksessionid=1727281788&realreporttime=1727281807731&scene=90&session_us=gh_3aaf766c705c&sessionid=1727281803&sn=6e87543fd27b10c017f33ea79ccd3494&subscene=93&version=28003334&wx_header=3&xtrack=1)

## Highlights

> <mark class="omni omni-green">Data Commons 是一个公开可用的知识图谱，包含超过 2,400 亿个丰富的数据点，涵盖数十万个统计变量。该知识图谱从联合国 (UN)、世界卫生组织 (WHO)、疾病控制与预防中心 (CDC) 和人口普查局等可信组织获取公开信息。将这些数据集整合成一套统一的工具和 AI 模型，可以帮助政策制定者、研究人员和组织获得准确的见解。</mark> [⤴️](https://omnivore.app/me/data-gemma-llm-1922a0de0f6#0ffabb66-1ec2-422f-8e04-daa5d31c2818) 

真实的世界经验数据库

> <mark class="omni omni-green">1\. **RIG (检索交错生成，Retrieval-Interleaved Generation)** 可主动查询可信任来源并根据 Data Commons 中的信息进行事实核查，从而增强语言模型 Gemma 2 的功能。通过编程，当用户输入提示词并让 DataGemma 生成响应时，该模型可识别统计数据的实例并从 Data Commons 检索回答。虽然 RIG 不是最近才出现的方法，但在 DataGemma 框架中应用该方法是一种独特的实践。</mark>
>
><mark class="omni omni-green"> ![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sL0rD_TEjBR_BFqA9hEECn_xwT6ox7UhklvWNSFY16y8/https://mmbiz.qpic.cn/mmbiz_gif/rFWVXwibLGtxBFx3HNzoXDhRBfQPCDTzcAKuUKTwGUHG4eRuXenTCl0icErYkMVhXHGYauvxJOe1oL2zkqIB9Y9A/640?wx_fmt=gif&from=appmsg)</mark>
>
><mark class="omni omni-green"> △ 查询示例: "全球可再生能源的使用量是否增加了？"。此问题采用 DataGemma RIG 方法，运用 Data Commons (DC) 来获得权威的数据。</mark>
>
><mark class="omni omni-green"> 2\. **RAG (检索增强生成，Retrieval-Augmented Generation)** 让语言模型能整合超出其训练数据范围之外的相关信息，并汲取更多上下文信息，从而生成更全面、信息量丰富的输出。对于 DataGemma，此功能则是通过利用 Gemini 1.5 Pro 的长上下文窗口实现的。DataGemma 会在模型开始生成响应之前，从 Data Commons 检索相关上下文信息，从而将出现幻觉的风险降到最低，同时提升响应的准确率。</mark> [⤴️](https://omnivore.app/me/data-gemma-llm-1922a0de0f6#6ab1df55-046d-4c7f-8b39-a969e26aa56b) 

RIG 用于检索现有数据，RAG 用于生成增强检索，两个合并兼顾真实性和拓展性

> <mark class="omni omni-green">研究人员和开发者还可以使用这些适用于 RIG 和 RAG 方法的快速入门手册，即刻体验 DataGemma。如需详细了解 Data Commons 和 Gemma 如何协同工作，请参阅我们的研究博文。</mark>
>
><mark class="omni omni-green"> * RIG  </mark>
><mark class="omni omni-green"> https://colab.research.google.com/github/datacommonsorg/llm-tools/blob/master/notebooks/datagemma\_rig.ipynb</mark>
><mark class="omni omni-green"> * RAG  </mark>
><mark class="omni omni-green"> https://colab.research.google.com/github/datacommonsorg/llm-tools/blob/master/notebooks/datagemma\_rag.ipynb</mark> [⤴️](https://omnivore.app/me/data-gemma-llm-1922a0de0f6#55ddd362-b03d-4340-bd72-85ee089c566b)  #编码架构 

RIG 和 RAG 的研究文章


## content
![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sOlrNwCFcTAkwmGa_rJy73VUw3UtnngdnNWvBdMb_96o/https://mmbiz.qpic.cn/mmbiz_png/rFWVXwibLGtxBFx3HNzoXDhRBfQPCDTzcQpeDB2eHOBic1mCLMEC2Xb6WQrSzBGcqEC86uPdWvkMTuTokKSnxbmw/640?wx_fmt=png&from=appmsg)

_作者 / Data Commons 负责人 Prem Ramaswami; 技术与社会高级副总裁 James Manyika_

驱动当下 AI 创新的大语言模型 (LLM) 正日趋复杂。这些模型可以梳理大量文本并生成摘要，提出新的创意方向，甚至提供代码草稿。然而，尽管 LLM 拥有这些惊人的能力，有时也会信誓旦旦地提供不准确的信息。我们称这种现象为 "幻觉"，这是生成式 AI 的关键挑战。

我们将在本文中与您分享一些极具前景的研究进展，通过让 LLM 利用现实世界的统计信息去帮助减少幻觉，从而直接应对幻觉挑战。除了这些研究进展以外，我们也很高兴能发布 DataGemma，这是首个旨在将 LLM 与来自 Google Data Commons 的大量现实世界数据连接起来的开放模型。

**Data Commons: 可信任的公开数据大型存储库**

==Data Commons== ==是一个公开可用的知识图谱，包含超过 2,400 亿个丰富的数据点，涵盖数十万个统计变量。该知识图谱从联合国 (UN)、世界卫生组织 (WHO)、疾病控制与预防中心 (CDC) 和人口普查局等可信组织获取公开信息。将这些数据集整合成一套统一的工具和 AI 模型，可以帮助政策制定者、研究人员和组织获得准确的见解。==

* Data Commons  
https://datacommons.org/

我们可以把 Data Commons 当成一个庞大且持续扩展的数据库，包含从健康和经济到人口统计和环境等各种主题的可靠公开信息。您可以通过我们由 AI 驱动的自然语言界面，用自己的话术与这一数据库交互。例如，您可以查询非洲哪些国家的电力供应增长最多、美国各县居民收入与患糖尿病的关联性，或查询您想了解的相关数据问题。

* 由 AI 驱动的自然语言界面  
https://blog.google/technology/ai/google-data-commons-ai/?utm\_campaign=tech-content&src=Online/LinkedIn/linkedin\_page&utm\_medium=linkedin\_post&utm\_source=linkedin
* 非洲哪些国家的电力供应增长最多  
https://datacommons.org/explore#q=Which%20countries%20in%20Africa%20have%20had%20the%20greatest%20increase%20in%20electricity%20access%3F
* 美国各县居民收入与患糖尿病的关联性  
https://datacommons.org/explore#q=How%20does%20income%20correlate%20with%20diabetes%20in%20US%20counties%3F

**Data Commons 如何帮助应对幻觉**

随着生成式 AI 的应用日益广泛，我们的目标是通过将 Data Commons 整合进 Gemma，为上述体验奠定基础。Gemma 是 Google 最先进的轻量级、开放模型系列，采用与打造 Gemini 模型相同的研究和技术构建而成。这些 DataGemma 模型现在可供研究人员和开发者使用。

* Gemma  
https://ai.google.dev/gemma
* Gemini  
https://gemini.google.com/corp/app?hl=en
* 现在可供研究人员和开发者使用  
https://huggingface.co/collections/google/datagemma-release-66df7636084d2b150a4e6643

DataGemma 将通过利用 Data Commons 的知识，使用两种不同的方法来增强 LLM 的事实性和推理能力，从而扩展 Gemma 模型的功能:

==1.== **==RIG (检索交错生成，Retrieval-Interleaved Generation)==** ==可主动查询可信任来源并根据 Data Commons 中的信息进行事实核查，从而增强语言模型 Gemma 2 的功能。通过编程，当用户输入提示词并让 DataGemma 生成响应时，该模型可识别统计数据的实例并从 Data Commons 检索回答。虽然 RIG 不是最近才出现的方法，但在 DataGemma 框架中应用该方法是一种独特的实践。==

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sL0rD_TEjBR_BFqA9hEECn_xwT6ox7UhklvWNSFY16y8/https://mmbiz.qpic.cn/mmbiz_gif/rFWVXwibLGtxBFx3HNzoXDhRBfQPCDTzcAKuUKTwGUHG4eRuXenTCl0icErYkMVhXHGYauvxJOe1oL2zkqIB9Y9A/640?wx_fmt=gif&from=appmsg)

==△ 查询示例: "全球可再生能源的使用量是否增加了？"。此问题采用 DataGemma RIG 方法，运用 Data Commons (DC) 来获得权威的数据。==

==2.== **==RAG (检索增强生成，Retrieval-Augmented Generation)==** ==让语言模型能整合超出其训练数据范围之外的相关信息，并汲取更多上下文信息，从而生成更全面、信息量丰富的输出。对于 DataGemma，此功能则是通过利用 Gemini 1.5 Pro 的长上下文窗口实现的。DataGemma 会在模型开始生成响应之前，从 Data Commons 检索相关上下文信息，从而将出现幻觉的风险降到最低，同时提升响应的准确率。==

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sbYtIpKDxSxVIn259BaItQkV0tRFn7--qtmci6Jjie2g/https://mmbiz.qpic.cn/mmbiz_gif/rFWVXwibLGtxBFx3HNzoXDhRBfQPCDTzcW7ic5nXHPgUTKCfql8BicCjibSu3NlfynA9oUBdFfEib028giaLKUhhaylg/640?wx_fmt=gif&from=appmsg)

△ 查询示例: "全球可再生能源的使用量是否增加了？"。此问题采用的 DataGemma RAG 方法展现出更强的推理能力并包含了脚注。

**极具前景的成果和未来方向**

我们对使用 RIG 和 RAG 的研究成果仍属早期阶段，但也足以令人振奋。我们发现，语言模型在处理有关数字的事实时，准确率得到显著提升。这表明用户在为开展研究、制定决策或仅仅是为了满足好奇心而使用模型时，面临的幻觉挑战将会减小。您可以在我们的研究论文中探索这些结果。

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,s2mEBhvUpgxf11_GVELNqpfvWm5jo8ZyByKboXWZ4Hnw/https://mmbiz.qpic.cn/mmbiz_png/rFWVXwibLGtxBFx3HNzoXDhRBfQPCDTzc3N2PIpibGVjFUv70gnOYhxuZ1x7XsPLQpOSppcViaYv7JB6oUpUSNg6A/640?wx_fmt=png&from=appmsg)

△ RAG 查询和响应的示例。支持的真实统计数据引用自 Data Commons 提供的表格。\*为了简洁起见，此处仅显示部分响应。

* 研究论文  
http://datacommons.org/link/DataGemmaPaper

我们的研究仍在持续推进。最初研究时采用了分阶段的限定访问方式，后续我们将致力于进一步完善本文所述的两种方法，将这项工作扩展开来，进行严格的测试，最终将这些经过增强的功能整合到 Gemma 和 Gemini 模型中。

我们希望通过分享研究结果和让这一最新 Gemma 模型变体再次成为 "开放" 模型，促使更多人采用这些由 Data Commons 主导的技术，让 LLM 以事实数据为基础。只有让 LLM 更加可靠、可信，才能确保它成为每个人不可或缺的工具，同时让 AI 在未来能为人们提供准确的信息，帮助人们作出明智的决策，并加深人们对周围世界的理解。

==研究人员和开发者还可以使用这些适用于== ==RIG== ==和== ==RAG== ==方法的快速入门手册，即刻体验 DataGemma。如需详细了解 Data Commons 和 Gemma 如何协同工作，请参阅我们的====研究博文====。==

* ==RIG==  
==https://colab.research.google.com/github/datacommonsorg/llm-tools/blob/master/notebooks/datagemma_rig.ipynb==
* ==RAG==  
==https://colab.research.google.com/github/datacommonsorg/llm-tools/blob/master/notebooks/datagemma_rag.ipynb==
* 研究博文  
https://research.google/blog/grounding-ai-in-reality-with-a-little-help-from-data-commons

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sjMh9lY89sqeCS6OaxOSMyfHx895aFSmVy-RnHYB5Yg4/https://mmbiz.qpic.cn/mmbiz_png/rFWVXwibLGtxyfWyHaZAp4GesHdNPC6mibiaeWncr9Tx8Aib6er4xw0P73s6BwLBn5zJzluFbN14UBsSG5JVRUlwuw/640?wx_fmt=png&from=appmsg)

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sgNWzQ5BEV1vzgzYVfS0iCZhQmrTISDwFHF9AcohVgwg/https://mmbiz.qpic.cn/mmbiz_png/rFWVXwibLGtxyfWyHaZAp4GesHdNPC6mibju0cfaV2vXmYYs4IVojH9oDbh7slWAsyeaOWicyv3uuH8DAuicBAeFpw/640?wx_fmt=png&from=appmsg)

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sOEqxVQKXiAzhH-RVlYKyYnD_3akaZC1odgi3v5xKz7M/https://mmbiz.qpic.cn/mmbiz_png/rFWVXwibLGtxyfWyHaZAp4GesHdNPC6mibOROgng8qTqia9U9OsD7ePibvH6qvzJ3C5ICYYTibFjTrybkFp7TtDeMqA/640?wx_fmt=png&from=appmsg)

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sgsmzp5Or_7ZoFvjskTquKDyL6jZMfgr1C5Uza5CWnJo/https://mmbiz.qpic.cn/mmbiz_png/rFWVXwibLGtxyfWyHaZAp4GesHdNPC6mibicHTVHaA6OI54mrK6T4BCALVialcQKHTaaiaCvNAuRXZTDAuUWjEG4kiaA/640?wx_fmt=png&from=appmsg)

**谷歌开发者**[**特别招募活动**](http://mp.weixin.qq.com/s?%5F%5Fbiz=MzAwODY4OTk2Mg==&mid=2652122867&idx=1&sn=61a16048d3d53e54332be1f158ca8686&chksm=808b8eb6b7fc07a0b9e8d0d48aae569df3a5e32ceb7de49d8f5553bc3278d55d8501e6fec6b6&scene=21#wechat%5Fredirect)**进行中**

**诚邀热爱技术的你** **加入**  

通过多种形式 (文章/视频/coding 等) 创作与 **Google 技术**相关的讲解分享、实践案例或活动感受等内容，以及分享您应用 **AI 技术**的故事经历与成果。我们将为您提供平台和资源，助力您在分享中提升技能。更有惊喜权益等您领取，快来报名参与吧！

---

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,s7b5z--Hvf-rnxGiovN_YltQ3tEat2ZTAOcken1GOAy0/https://mmbiz.qpic.cn/mmbiz_gif/rFWVXwibLGty0S5JgMN8PpBib2631p7cDvlvTEaxFBzljBX9qWcVMSOymhkTd6ZmanRibYWsh0HmccjGWkadiaLwAA/640?wx_fmt=gif) 点击屏末 **|** **阅** **读** **原** **文** **| 即刻体验 DataGemma**

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sla0UzXHcy8weemUzNgMD2JOAyyN0PC5McdECwfEtsBI/https://mmbiz.qpic.cn/mmbiz_png/rFWVXwibLGtz8OGvWKfTib36xjRAc6tFCNzVVPJhwuBnoV2j8GXYpytVWJa2FCZjylGsNgG6LiaiasHIbmJlKhASrg/640?wx_fmt=png)

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,s6ZyVqRxk7TDejowkb-SHluMtO7jYRhHa2wBbYsFbmRs/https://mmbiz.qpic.cn/mmbiz_png/rFWVXwibLGtxLmhuj0u7YfGbwokn3jKabAAWGYIziaBgj994ckU90gRKpuHfRwQfMhardJHoYmI94gno9ToVGNDw/640?wx_fmt=png)

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sEwRaleW05AT-TsQU9_ahvzyeLI9zpwVBQ71lj53BPvY/https://mmbiz.qpic.cn/mmbiz_png/rFWVXwibLGtz8OGvWKfTib36xjRAc6tFCNXVrWNoLC1jVhSicibYsTXKcYwTib6KKCriaUz3qgCia2LDM9ylXsBVRrNtQ/640?wx_fmt=png)

