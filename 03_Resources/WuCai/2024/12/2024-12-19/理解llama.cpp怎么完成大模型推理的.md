---
标题: 理解llama.cpp怎么完成大模型推理的
url: http://mp.weixin.qq.com/s?__biz=Mzg3ODc5NTI0Mg==&mid=2247485932&idx=2&sn=4b294ac5360cb5317ca173591edef48c&chksm=ce70b3c72de30a8895a3ab117549653b98d170c6c695bfa60dcd9f9224fb621d386455285d2e&mpshare=1&scene=1&srcid=1218bfuGLg85knkjMhOIdl54&sharer_shareinfo=ca560039ee466de729e41b0714857ac8&sharer_shareinfo_first=ca560039ee466de729e41b0714857ac8#rd
创建时间: 2024-12-19 21:27
更新时间: 2024-12-19 21:27
笔记ID: HM75BF6
收藏: false
划线数量: 0
标签: 
obsidianUIMode: preview
---

# 理解llama.cpp怎么完成大模型推理的 

## collectedBy
[[wucai汇总]]

> [阅读原文](http://mp.weixin.qq.com/s?__biz=Mzg3ODc5NTI0Mg==&mid=2247485932&idx=2&sn=4b294ac5360cb5317ca173591edef48c&chksm=ce70b3c72de30a8895a3ab117549653b98d170c6c695bfa60dcd9f9224fb621d386455285d2e&mpshare=1&scene=1&srcid=1218bfuGLg85knkjMhOIdl54&sharer_shareinfo=ca560039ee466de729e41b0714857ac8&sharer_shareinfo_first=ca560039ee466de729e41b0714857ac8#rd)
> [在五彩中查看](https://marker.dotalk.cn/#/?nx=HM75BF6&vs=1)


## 划线列表



---


## 全文剪藏 %% fold %%
 LiteAI  LiteAI 2024年12月11日 22:25 

点击下方卡片，关注“LiteAI”公众号

> 作者：hugulas@知乎（作者已授权转载）
> 
> 来源：https://zhuanlan.zhihu.com/p/996110863 原文：https://www.omrimallis.com/posts/understanding-how-llm-inference-works-with-llama-cpp/

译者的话: llama.cpp出道以来，很少有官方文档，但是本文通过代码驱动的讲解， 讲清楚了llama.cpp的原理，个人推荐一读。

在这篇文章中，我们将深入探讨大型语言模型（LLMs）的内部结构，以便更好地理解它们是如何工作的。为帮助我们进行这次探索，我们将使用 llama.cpp 的源码，它是 Meta 的 LLaMA 模型的纯 C++ 实现。作者个人认为，llama.cpp 是理解 LLM 深层原理的一个优秀学习工具，它的代码简洁明了，不涉及过多的抽象。我们将使用特定的提交版本。

  
本文的重点是 LLM 的推理部分，即：已训练好的模型如何基于用户输入的提示生成响应。这篇文章主要写给那些非机器学习和人工智能领域的工程师，旨在帮助他们更好地理解 LLM，**本文从工程角度而非 AI 角度探讨 LLM 的内部工作原理，因此不要求读者具备深厚的数学或深度学习知识** 。（译者：这正是本文最妙的地方）在文章中，我们将从头到尾介绍 LLM 的推理过程，涵盖以下主题：

1. 张量：概述数学运算如何以张量的形式实现， 并可能潜在转移到 GPU 上处理。
2. 分词：将用户输入的提示分解为令牌列表，LLM 使用这些令牌作为输入。
3. **嵌入Embedding：将令牌转换为高维向量的过程。**
4. Transformer：大语言模型架构的核心部分，负责实际的推理过程，我们将重点介绍自注意力机制。
5. 采样：选择下一个预测令牌的过程，我们将探讨两种采样技术。
6. KV 缓存：一种常见的优化技术，用于加快长提示的推理速度，我们将介绍一个基本的 kv 缓存实现。

通过阅读本文，你将有望对 LLM 的工作过程有一个端到端的理解，并且能够探索更高级的主题，这些主题将在最后一节中详细说明。

## 从提示到输出的高级流程

作为一个大型语言模型（LLM），LLaMA 的工作原理是接收一个输入文本（即“提示”），并预测下一个应该生成的标记（token）或词汇。

  
为了说明这个过程，我们以维基百科量子力学条目中的第一句话为例。我们的提示是：

> **Quantum mechanics is a fundamental theory in physics that** 

LLM 会尝试根据训练时学到的知识继续这句话。使用 llama.cpp，我们得到如下的续写：

> **provides insights into how matter and energy behave at the atomic scale.** 

让我们先来看一下这个过程的高级流程。LLM 的核心功能是每次只预测一个标记。生成完整的句子（或更多内容）是通过反复应用 LLM 模型到相同的提示上，并将之前的输出标记附加到提示后形成的。这种模型被称为自回归模型。因此，我们主要关注单个标记的生成，流程可以简化为以下高级图所示：  
LLM 通过每次迭代生成一个标记，然后将其添加到输入提示中，不断重复该过程，直到生成完整的输出。这就是 LLM 如何从输入提示生成文本的基础。

![图片](https://g1proxy.wimg.site/styIWyocuuYpU6W-N8WNmBZUoURPP_WFEUMxxXREuB6Y/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJq3K8FvELvnGmEyB8xOnMaPxClodoBRO8l62zoWgXZKSrTq0Rc2nghGw/640?wx_fmt=jpeg&from=appmsg)

从用户提示生成单个标记的完整流程包括多个阶段，如分词、嵌入、Transformer 神经网络和采样。本文将介绍这些阶段。

根据图示，整个流程如下：

1. **分词：分词器将提示分解为一个标记列表。根据模型的词汇表，某些单词可能会被分解成多个标记。每个标记由一个唯一的数字表示。**
2. **嵌入embedding转换：每个数字标记被转换为一个嵌入向量。嵌入是一个固定大小的向量，以一种更适合 LLM 处理的方式表示标记。所有嵌入向量组合在一起形成嵌入矩阵。**
3. **输入 Transformer：嵌入矩阵作为 Transformer 的输入。Transformer 是 LLM 的核心神经网络，由多层链组成。每一层接收输入矩阵，并利用模型参数执行各种数学运算，最主要的是自注意力机制。该层的输出作为下一层的输入。**
4. **logits 生成：最后的神经网络将 Transformer 的输出转换为 logits。每个可能的下一个标记都有一个相应的 logits，表示该标记作为句子“正确”延续的概率。**
5. **采样：使用多种采样技术之一，从 logits 列表中选择下一个标记。**
6. **生成输出：所选标记作为输出返回。要继续生成更多的标记，所选标记会被附加到第 1 步的标记列表中，然后重复该过程。这可以一直进行，直到生成所需数量的标记，或者 LLM 发出特殊的结束流（EOS）标记。**

接下来的部分将详细探讨这些步骤。但在此之前，我们需要熟悉张量的概念。

## 理解张量及其在 ggml 中的应用

张量是神经网络中执行数学运算的主要数据结构。**llama.cpp**  使用的是 **ggml** ，这是一种纯 C++ 实现的张量库，相当于 Python 生态系统中的 **PyTorch**  或 **TensorFlow** 。我们将通过 ggml 来理解张量是如何操作的。

张量可以表示一个多维数组的数值。它可能包含一个单一的数值（标量）、一个向量（一维数组）、一个矩阵（二维数组）甚至是三维或四维数组。通常，实际应用中不需要使用更多维度。

理解两种类型的张量是非常重要的：

1. **数据张量：这些张量持有实际数据，包含一个多维数组的数值。**
2. **运算张量：这些张量仅表示一个或多个其他张量之间运算的结果，只有在实际计算时才会包含数据。**

我们接下来将详细探讨这两类张量之间的区别。

### 张量的基本结构

在 **ggml**  中，张量由 `ggml_tensor` 结构体表示。为便于理解，我们稍微简化了一下它的结构，简化后的样子如下：


```
// ggml.hstructggml_tensor{enumggml_typetype;enumggml_backendbackend;intn_dims;//张量的维度数量，例如一维向量、二维矩阵等// number of elementsint64_tne[GGML_MAX_DIMS];// stride in bytessize_tnb[GGML_MAX_DIMS];enumggml_opop;// 表示张量是哪个操作的结果（例如加法、乘法等）structggml_tensor*src[GGML_MAX_SRC];// 张量的输入源（如果它是计算结果）void*data;//指向实际数据的指针，可能是 NULL，如果该张量仅代表一个操作的结果charname[GGML_MAX_NAME];};
```


前几个字段比较容易理解：

* **type：包含张量元素的基本类型。例如，`GGML_TYPE_F32` 表示每个元素是一个 32 位浮点数， 也可以是F16或者其他整形量化。**
* **ggml\_backend：指示张量是基于 CPU 还是基于 GPU 存储的。我们稍后会讨论这一点。**
* **n\_dims：张量的维度数量，可以是 1 到 4 维。**
* **ne：表示每个维度中的元素数量。ggml 采用行优先顺序，意味着 `ne[0]` 表示每行的大小，`ne[1]` 表示每列的大小，依此类推。**
* **nb：这个字段稍微复杂一些，它包含步长信息，即每个维度中连续元素之间的字节数。在第一个维度中，步长等于元素的大小；在第二个维度中，它等于每行的大小乘以元素的大小，以此类推。**
   * 例如，对于一个 4x3x2 的张量：

![图片](https://g1proxy.wimg.site/sViTi71QBZCgvXD10PJhqCQVmd90MDmOk_p3Owu1NlTQ/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqBJHC0B45AYicQSKZe6ceu5W9gcciarIN9N4eiapibiaBkWVEcvmmQcMkYTA/640?wx_fmt=jpeg&from=appmsg)

一个 32 位浮点数张量的例子，维度为 {4, 3, 2}，步长为 {4, 16, 48}。

使用步长的目的是为了在进行某些张量操作时无需复制任何数据。例如，在二维张量上执行转置操作，将行转换为列时，只需要交换 `ne`（维度大小）和 `nb`（步长），而指向相同的底层数据即可实现这个操作，无需对数据本身进行复制。


```
// ggml.c (the function was slightly simplified).structggml_tensor*ggml_transpose(structggml_context*ctx,structggml_tensor*a){// Initialize `result` to point to the same data as `a`structggml_tensor*result=ggml_view_tensor(ctx,a);result->ne[0]=a->ne[1];result->ne[1]=a->ne[0];result->nb[0]=a->nb[1];result->nb[1]=a->nb[0];result->op=GGML_OP_TRANSPOSE;result->src[0]=a;returnresult;}
```


在上述函数中，`result` 是一个新张量，它被初始化为指向与源张量 `a` 相同的多维数值数组。通过交换 `ne`（维度大小）和 `nb`（步长），可以执行转置操作，而无需复制任何数据。

译者注：这里ggml\_view\_tensor和GGML\_OP\_TRANSPOSE发挥了重要作用， **ggml\_view\_tensor** ： `ggml_view_tensor`函数创建了一个新的张量`result`，这个张量指向原始张量`a`的相同数据。这意味着`result`和`a`共享相同的内存空间，但它们的维度和步长可以不同。将 `result->op` 设置为 `GGML_OP_TRANSPOSE` 之后，`ggml` 系统知道这个张量是通过转置另一个张量得到的，而不是一个直接包含数据的张量。这个标记在后续的计算中很重要，因为 `ggml` 在需要计算时会按照这个操作类型来执行相应的计算逻辑。这在后面会马上讲到。

### 张量操作与视图

正如之前提到的，有些张量包含实际数据，而另一些张量则表示其他张量之间运算的理论结果。回到 `ggml_tensor` 结构体：

* **`op`**  
：可以是张量之间支持的任何操作。如果设置为 `GGML_OP_NONE`，则表示张量包含数据。其他值表示不同的操作。例如，`GGML_OP_MUL_MAT` 表示该张量不包含数据，而是表示两个其他张量之间矩阵乘法的结果。
* **`src`**  
：这是一个指向要进行运算的张量的指针数组。例如，如果 `op == GGML_OP_MUL_MAT`，那么 `src` 将包含指向两个要相乘的张量的指针。如果 `op == GGML_OP_NONE`，则 `src` 为空。
* **`data`**  
：指向实际张量数据的指针，如果该张量表示一个操作，则为 `NULL`。它也可能指向另一个张量的数据，在这种情况下，它被称为视图。例如，在上面的 `ggml_transpose()` 函数中，结果张量就是原始张量的视图，只是维度和步长被交换了。`data` 指向相同的内存位置。

矩阵乘法函数很好地展示了这些概念：通过指向相同的数据并修改维度和步长，张量可以通过视图避免数据复制。


```
// ggml.c (simplified and commented)structggml_tensor*ggml_mul_mat(structggml_context*ctx,structggml_tensor*a,structggml_tensor*b){// Check that the tensors' dimensions permit matrix multiplication.GGML_ASSERT(ggml_can_mul_mat(a,b));// Set the new tensor's dimensions// according to matrix multiplication rules.constint64_tne[4]={a->ne[1],b->ne[1],b->ne[2],b->ne[3]};// Allocate a new ggml_tensor.// No data is actually allocated except the wrapper struct.structggml_tensor*result=ggml_new_tensor(ctx,GGML_TYPE_F32,MAX(a->n_dims,b->n_dims),ne);// Set the operation and sources.result->op=GGML_OP_MUL_MAT;result->src[0]=a;result->src[1]=b;returnresult;}
```


在上述函数中，`result` 不包含任何数据。它只是表示矩阵 `a` 和 `b` 相乘后的理论结果。

### 计算张量

上面的 `ggml_mul_mat()` 函数或其他任何张量操作，都不会立即进行计算，它只是为操作准备好张量。换一种方式理解，它是在构建一个计算图，其中每个张量操作都是一个节点，操作的来源是该节点的子节点。在矩阵乘法的情况下，计算图会有一个父节点，其操作为 `GGML_OP_MUL_MAT`，同时有两个子节点。

在 `llama.cpp` 中的一个实际例子中，下面的代码实现了自注意力机制，这是每个 Transformer 层的一部分，后续会对此进行更深入的探讨：


```
// llama.cppstaticstructggml_cgraph*llm_build_llama(/* ... */){// ...// K,Q,V are tensors initialized earlierstructggml_tensor*KQ=ggml_mul_mat(ctx0,K,Q);// KQ_scale is a single-number tensor initialized earlier.structggml_tensor*KQ_scaled=ggml_scale_inplace(ctx0,KQ,KQ_scale);structggml_tensor*KQ_masked=ggml_diag_mask_inf_inplace(ctx0,KQ_scaled,n_past);structggml_tensor*KQ_soft_max=ggml_soft_max_inplace(ctx0,KQ_masked);structggml_tensor*KQV=ggml_mul_mat(ctx0,V,KQ_soft_max);// ...}
```


这段代码是一系列张量操作，并构建了一个计算图，与原始 Transformer 论文中描述的计算图完全一致。

![图片](https://g1proxy.wimg.site/sB31pMxeWNjd9qPE-c8_bef9DnbASyzVCvzjuVGjnm_M/https://mmbiz.qpic.cn/mmbiz_png/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqjDibw2H4ibPjKQGuURUwOicF72RukbvRzklAxUD2Wico01OobJf7bfgcaw/640?wx_fmt=png&from=appmsg)

要实际计算结果张量（这里是 KQV），需要执行以下步骤：

1. **加载数据：数据被加载到每个叶子张量的 `data` 指针中。在这个例子中，叶子张量是 K、Q 和 V。**
2. **构建计算图：使用 `ggml_build_forward()` 函数将输出张量（KQV）转换为计算图。这个函数比较简单，以深度优先顺序排列节点。**
3. **运行计算图：通过 `ggml_graph_compute()` 运行计算图，该函数对每个节点执行 `ggml_compute_forward()` 操作，按深度优先顺序计算。`ggml_compute_forward()` 负责主要的数学计算，完成数学运算并将结果填充到张量的 `data` 指针中。**
4. **结果输出：在这个过程结束时，输出张量的 `data` 指针指向最终计算结果。**

### 将计算任务转移到 GPU

由于 GPU 的高度并行性，许多张量操作（如矩阵加法和乘法）可以在 GPU 上更高效地完成。当 GPU 可用时，可以将张量标记为 `tensor->backend = GGML_BACKEND_GPU`。在这种情况下`ggml_compute_forward()` 会尝试将计算任务转移到 GPU 进行。GPU 会执行张量操作，并将结果存储在 GPU 的内存中（而不是张量的 `data` 指针中）。

例如，在之前的自注意力计算图中，假设 K、Q、V 是固定的张量，计算可以转移到 GPU 上完成。

![图片](https://g1proxy.wimg.site/sXHrY_r4Xgc95dIchkOGxWt2RJN22rKLiTV-ykm4kbxQ/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqTX6Mbk9jlv0E3Cz1uy7LhKIHGAIKfUdCu10757qfNMpTq6gLz0765g/640?wx_fmt=jpeg&from=appmsg)

这个过程首先将 K、Q、V 复制到 GPU 内存中。然后由 CPU 按照张量逐个驱动计算，但实际的数学运算会被转移到 GPU 进行。当计算图中的最后一个操作完成时，结果张量的数据会从 GPU 内存复制回 CPU 内存。

**注意** ：在实际的 Transformer 中，K、Q、V 并不是固定的，KQV 也不是最终的输出。后面我们将对此进行详细说明。

在理解了张量的工作机制之后，我们可以回到 LLaMA 的流程。

## 分词Tokenization

推理的第一步是分词。分词是将提示（prompt）拆分为称为“词元”的较短字符串列表的过程。词元必须是模型词汇表的一部分，词汇表是LLM（大型语言模型）在训练时使用的词元列表。例如，LLaMA的词汇表由32,000个词元组成，随模型一同分发。

对于我们的示例提示，分词将提示拆分为11个词元（空格被替换为特殊的元符号‘▁’ (U+2581)）：

> |Quant|um|▁mechan|ics|▁is|▁a|▁fundamental|▁theory|▁in|▁physics|▁that|

在分词过程中，LLaMA使用了基于字节对编码（BPE）算法的SentencePiece分词器。这种分词器非常有趣，因为它是基于子词的，这意味着一个词可能由多个词元表示。例如，在我们的提示中，‘Quantum’被拆分为‘Quant’和‘um’。在训练过程中，词汇表的生成通过BPE算法保证常用词作为单个词元包含在词汇表中，而罕见词则被分解为子词。在上面的示例中，单词‘Quantum’不在词汇表中，但‘Quant’和‘um’作为两个独立的词元存在。空格不会被特殊处理，它们如果足够常见，也会作为元字符包含在词元中。

基于子词的分词具有多种优势：

它允许LLM学习像‘Quantum’这样的罕见词的含义，同时通过将常见的后缀和前缀表示为独立词元，保持词汇表的相对小型化。 它无需使用语言特定的分词方案即可学习语言特定的特性。引用BPE编码论文中的例子： 考虑德语的复合词如Abwasser|behandlungs|anlange（污水处理厂），分段的、可变长度的表示形式比将该词编码为固定长度的向量更加直观。

同样，这种分词方式在解析代码时也非常有用。例如，一个名为model\_size的变量将被分词为model|\_|size，这使得LLM能够“理解”该变量的用途（这也是为变量赋予有意义名称的另一个原因！）。 在llama.cpp中，分词是通过llama\_tokenize()函数完成的。该函数接受提示字符串作为输入，并返回词元列表，其中每个词元由一个整数表示。


```
// llama.htypedefintllama_token;// common.hstd::vector<llama_token>llama_tokenize(structllama_context*ctx,// the promptconststd::string&text,booladd_bos);
```


分词过程首先将提示拆分为单个字符的词元。接着，它会迭代地尝试将每两个连续的词元合并为一个更大的词元，只要合并后的词元是词汇表的一部分。这样可以确保生成的词元尽可能大。对于我们的示例提示，分词步骤如下：


```
Q|u|a|n|t|u|m|▁|m|e|c|h|a|n|i|c|s|▁|i|s|▁a|▁|f|u|n|d|a|m|e|n|t|a|l| Qu|an|t|um|▁m|e|ch|an|ic|s|▁|is|▁a|▁f|u|nd|am|en|t|al| Qu|ant|um|▁me|chan|ics|▁is|▁a|▁f|und|am|ent|al| Quant|um|▁mechan|ics|▁is|▁a|▁fund|ament|al| Quant|um|▁mechan|ics|▁is|▁a|▁fund|amental| Quant|um|▁mechan|ics|▁is|▁a|▁fundamental|
```


请注意，每个中间步骤都符合模型词汇表的有效分词规则。然而，只有最后一步会被用作LLM（大型语言模型）的输入。

## 嵌入embedding

这些词元将作为LLaMA的输入，用于预测下一个词元。此处的关键函数是llm\_build\_llama()函数：


```
// llama.cpp (simplified)staticstructggml_cgraph*llm_build_llama(llama_context&lctx,constllama_token*tokens,intn_tokens,intn_past);
```


该函数接受由`tokens`和`n_tokens`参数表示的词元列表作为输入。然后，它构建LLaMA的完整张量计算图，并将其作为`ggml_cgraph`结构返回。在此阶段实际上并不会进行任何计算。目前可以忽略`n_past`参数，它目前设置为零。稍后我们在讨论`kv cache`时将再次提到它。

  
除了词元，该函数还使用模型权重或模型参数。这些是LLM（大型语言模型）在训练过程中学习的固定张量，作为模型的一部分包含在内。这些模型参数在推理开始前预先加载到`lctx`中。

现在我们将开始探索计算图结构。该计算图的第一部分涉及将词元转换为嵌入。嵌入是每个词元的固定向量表示，它比纯整数更适合深度学习，因为它捕捉到了单词的语义意义。该向量的大小是模型维度，不同模型之间有所不同。例如，在LLaMA-7B中，模型维度为`n_embd=4096`。模型参数包括一个将词元转换为嵌入的词元嵌入矩阵。由于我们的词汇大小为`n_vocab=32000`，因此这是一个32000 x 4096的矩阵，每一行都包含一个词元的嵌入向量：

![图片](https://g1proxy.wimg.site/sQl8slZR6mHnbgL2peX3as4SmngS2FVfXvt0xgaQ-jUY/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqf6KmrrwSfawfbBibBFz14ic0hAACOibiayiaZVJVeEa4RVqcVNFepRFfYpg/640?wx_fmt=jpeg&from=appmsg)

每个词元都有一个在训练过程中学习到的关联嵌入，可以通过词元嵌入矩阵进行访问。

计算图的第一部分从词元嵌入矩阵中提取每个词元的相关行：


```
// llama.cpp (simplified)staticstructggml_cgraph*llm_build_llama(/* ... */){// ...structggml_tensor*inp_tokens=ggml_new_tensor_1d(ctx0,GGML_TYPE_I32,n_tokens);memcpy(inp_tokens->data,tokens,n_tokens*ggml_element_size(inp_tokens));inpL=ggml_get_rows(ctx0,model.tok_embeddings,inp_tokens);}//
```


代码首先创建一个名为`inp_tokens`的新的一维整数张量，用于存储数值化的词元。接着，它将词元值复制到该张量的数据指针中。最后，它创建了一个新的`GGML_OP_GET_ROWS`张量操作，将词元嵌入矩阵`model.tok_embeddings`与我们的词元组合起来。

当稍后计算该操作时，它将从嵌入矩阵中提取相应的行，如上图所示，创建一个新的`n_tokens x n_embd`矩阵，仅包含按原始顺序排列的词元嵌入：

![图片](https://g1proxy.wimg.site/sBpBIekBhB4ELI0QN_2zKQyTVcHc0srCPWIgilbNqS5w/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqalYR7UpB2J3XSibib4FWYyJVvqo3aB5ianz6Lgib2trBYcEZEGkTVRZhLw/640?wx_fmt=jpeg&from=appmsg)

嵌入过程为每个原始词元创建一个固定大小的嵌入向量。当这些向量堆叠在一起时，它们构成了提示（prompt）的嵌入矩阵。

## Transformer

计算图的主要部分被称为Transformer。Transformer是一种神经网络架构，是大型语言模型（LLM）的核心，负责执行主要的推理逻辑。在接下来的部分中，我们将从工程角度探讨Transformer的一些关键方面，重点关注自注意力机制。如果你想对Transformer架构有直观的了解，我建议阅读《The Illustrated Transformer》。

### 自注意力机制

我们首先深入了解下什么是自注意力机制，然后再回顾它在整体Transformer架构中的作用。

自注意力机制是一种机制，它接收一系列词元，并生成该序列的紧凑向量表示，考虑到词元之间的关系。这是LLM架构中唯一计算词元间关系的地方，因此它构成了语言理解的核心，涵盖了对词汇关系的理解。由于涉及跨词元的计算，从工程角度来看，它也是最有趣的部分，尤其是对于较长序列来说，计算量可能会非常大。

自注意力机制的输入是`n_tokens x n_embd`的嵌入矩阵，其中每一行或向量表示一个独立的词元。这些向量中的每一个都将被转换为三个不同的向量，分别称为“键”（key）、“查询”（query）和“值”（value）向量。这种转换通过将每个词元的嵌入向量与固定的`wk`、`wq`和`wv`矩阵（这些矩阵是模型参数的一部分）相乘来实现：

![图片](https://g1proxy.wimg.site/sRZPRqgW4l-zBoY1xUD3JaV-FQqDs_QyCURcXU4ZW3e4/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqQ7InmNfzOINiae3JeyBjeDKCspSlSRlyn9kbvicjxbQEaWwGFc6GP3IQ/640?wx_fmt=jpeg&from=appmsg)

将词元的嵌入向量与wk、wq和wv参数矩阵相乘，会为该词元生成“键”（key）、“查询”（query）和“值”（value）向量。

这个过程会对每个词元重复进行，也就是执行n\_tokens次。理论上可以通过循环来完成，但为了提高效率，所有行会通过矩阵乘法在一次操作中进行转换，矩阵乘法正是实现这一点的。相关代码如下所示：


```
// llama.cpp (simplified to remove use of cache)// `cur` contains the input to the self-attention mechanismstructggml_tensor*K=ggml_mul_mat(ctx0,model.layers[il].wk,cur);structggml_tensor*Q=ggml_mul_mat(ctx0,model.layers[il].wq,cur);structggml_tensor*V=ggml_mul_mat(ctx0,model.layers[il].wv,cur);
```


最终，我们得到三个矩阵 K、Q 和 V，它们的大小均为 `n_tokens x n_embd`，分别包含每个词元的键（key）、查询（query）和值（value）向量堆叠在一起。

自注意力机制的下一步是将包含查询向量的矩阵 Q 与包含键向量的矩阵 K 的转置相乘。对于不太熟悉矩阵操作的人来说，此操作实际上是为每对查询和键向量计算一个联合得分。我们使用符号 S(i,j) 来表示查询 i 与键 j 的得分。

这个过程生成了 `n_tokens^2` 个得分，每个查询-键对都有一个得分，并将其打包在一个称为 KQ 的矩阵中。随后，该矩阵会进行掩码操作，以移除对角线以上的元素：

![图片](https://g1proxy.wimg.site/sFyW6tf_UL3ZKHWwj1DwmhdQYc2erfinpiUEpf8qKiis/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqZibRkXUEpA5H5gEkkicibkwe6nYx3Dic6PS6ic1iaKSDuWLGWU8uhtjZuDibw/640?wx_fmt=jpeg&from=appmsg)

通过将矩阵 Q 与 K 的转置相乘，计算每个查询-键对的联合得分 S(i,j)。此处显示的是前四个词元的结果，以及每个得分所对应的词元。掩码步骤确保仅保留每个词元与其前面词元之间的得分。为了简化说明，省略了中间的缩放操作。

掩码操作是一个关键步骤。对于每个词元，它只保留与其前面词元之间的得分。在训练阶段，这一约束确保LLM仅根据之前的词元预测当前词元，而不是未来的词元。此外，正如我们稍后将更详细探讨的，它还允许在预测未来词元时进行显著优化。

自注意力机制的最后一步是将掩码后的得分矩阵`KQ_masked`与之前的值向量相乘。这样的矩阵乘法操作会生成所有前面词元值向量的加权和，其中权重是得分`S(i,j)`。例如，对于第四个词元“ics”，它会生成“Quant”、“um”、“▁mechan”和“ics”这几个词元的值向量的加权和，权重为`S(3,0)`到`S(3,3)`，这些得分是由“ics”的查询向量与之前所有词元的键向量计算出来的。

![图片](https://g1proxy.wimg.site/si-5rSALb4nvOU34cMFAMLaQDsjoRCM3BwopP4Df1EvA/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqu737WMicicBW5Vy5nLpNib8z2CNFsichm8bqFeC48niabjJFJfKjZaLObeg/640?wx_fmt=jpeg&from=appmsg)

KQV矩阵包含了值向量的加权和。例如，突出显示的最后一行是前四个值向量的加权和，权重为对应的突出显示的得分。

KQV矩阵标志着自注意力机制的结束。之前我们已经在一般张量计算的上下文中介绍了实现自注意力机制的相关代码，但现在你能够更好地理解它。

### Transformer的层

自注意力机制是Transformer层的一个组成部分。每一层除了自注意力机制外，还包含多个其他的张量操作，主要是矩阵加法、乘法和激活函数操作，这些都是前馈神经网络的一部分。我们不会详细探讨这些操作，只需要注意以下几点：

* 前馈网络中使用了大型、固定的参数矩阵。在LLaMA-7B中，这些矩阵的大小为`n_embd x n_ff = 4096 x 11008`。
* 除了自注意力机制之外，其他所有操作都可以看作是逐行或逐词元进行的。正如之前提到的，只有自注意力机制包含跨词元的计算。这一点在后面讨论kv缓存时会非常重要。
* 输入和输出的大小始终为`n_tokens x n_embd`：每个词元对应一行，每行的大小等于模型的维度。

为完整起见，我还包含了LLaMA-7B中单个Transformer层的图示。请注意，未来的模型架构可能会稍有不同。

![图片](https://g1proxy.wimg.site/sUQiLccnpdStnbUjQZtQ-FqHXPAi3erdJIw-7RmUfUvM/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJq7f2coCkFjhNpaBZcRx5X0L81uFTEJga1gveeA5tqNQDMsAq57zsaIA/640?wx_fmt=jpeg&from=appmsg)

LLaMA-7B中一个Transformer层的完整计算图，包含自注意力机制和前馈机制。每一层的输出作为下一层的输入。在自注意力阶段和前馈阶段都使用了大型参数矩阵，这些矩阵构成了该模型的大部分70亿个参数。

在Transformer架构中有多个层。例如，在LLaMA-7B中有32个层（n\_layers=32）。这些层是相同的，除了每层都有自己的一组参数矩阵（例如用于自注意力机制的各自的`wk`、`wq`和`wv`矩阵）。第一层的输入是上文描述的嵌入矩阵。第一层的输出随后被用作第二层的输入，依此类推。我们可以将其看作每一层都生成了一组嵌入，但这些嵌入不再直接与单个词元相关，而是与词元关系的某种更复杂的理解相关联。

### 计算logits

Transformer的最后一步是计算logits。logit是一个浮点数，表示某个特定词元是“正确”下一个词元的概率。logit值越高，表示相应词元是“正确”词元的可能性越大。

logits的计算是通过将最后一个Transformer层的输出与一个固定的`n_embd x n_vocab`参数矩阵（在`llama.cpp`中也称为`output`）相乘来完成的。这个操作为词汇表中的每个词元生成一个logit。例如，在LLaMA中，它会生成`n_vocab=32000`个logits：

![图片](https://g1proxy.wimg.site/s1x8BiQT6BuLS9s3B0GzrrpwL9hecXXg1aIb3yj4AWgY/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqgFXRuDcncHr94KbIWxJtwo0g6VQW2ad1Qcp3szC8eV0eRgxicJicbUew/640?wx_fmt=jpeg&from=appmsg)

Transformer的最后一步通过将最后一层的输出与一个固定的参数矩阵（也称为&#39;output&#39;）相乘来计算logits。这里只关注结果的最后一行，它包含词汇表中每个可能的下一个词元的logit值。

Logits是Transformer的输出，告诉我们最可能的下一个词元是什么。至此，所有的张量计算都已结束。以下是简化和带注释的`llm_build_llama()`函数版本，总结了本节中描述的所有步骤：


```
// llama.cpp (simplified and commented)staticstructggml_cgraph*llm_build_llama(llama_context&lctx,constllama_token*tokens,intn_tokens,intn_past){ggml_cgraph*gf=ggml_new_graph(ctx0);structggml_tensor*cur;structggml_tensor*inpL;// Create a tensor to hold the tokens.structggml_tensor*inp_tokens=ggml_new_tensor_1d(ctx0,GGML_TYPE_I32,N);// Copy the tokens into the tensormemcpy(inp_tokens->data,tokens,n_tokens*ggml_element_size(inp_tokens));// Create the embedding matrix.inpL=ggml_get_rows(ctx0,model.tok_embeddings,inp_tokens);// Iteratively apply all layers.for(intil=0;il<n_layer;++il){structggml_tensor*K=ggml_mul_mat(ctx0,model.layers[il].wk,cur);structggml_tensor*Q=ggml_mul_mat(ctx0,model.layers[il].wq,cur);structggml_tensor*V=ggml_mul_mat(ctx0,model.layers[il].wv,cur);structggml_tensor*KQ=ggml_mul_mat(ctx0,K,Q);structggml_tensor*KQ_scaled=ggml_scale_inplace(ctx0,KQ,KQ_scale);structggml_tensor*KQ_masked=ggml_diag_mask_inf_inplace(ctx0,KQ_scaled,n_past);structggml_tensor*KQ_soft_max=ggml_soft_max_inplace(ctx0,KQ_masked);structggml_tensor*KQV=ggml_mul_mat(ctx0,V,KQ_soft_max);// Run feed-forward network.// Produces `cur`.// ...// input for next layerinpL=cur;}cur=inpL;// Calculate logits from last layer's output.cur=ggml_mul_mat(ctx0,model.output,cur);// Build and return the computation graph.ggml_build_forward_expand(gf,cur);returngf;}
```


为了实际执行推理，返回的计算图通过`ggml_graph_compute()`函数进行计算，如前所述。然后将最后一个张量的数据指针中的logits复制到一个浮点数组中，为下一步“采样”做好准备。

## 采样

拿到logits列表后，下一步是根据它们选择下一个词元。这个过程称为采样。针对不同的使用场景，有多种采样方法可用。在本节中，我们将介绍两种基本的采样方法，稍后会在未来的文章中讨论更高级的采样方法，如语法采样。

### 贪婪采样

贪婪采样是一种简单直接的方法，它选择与最高logit值相关联的词元。

对于我们的示例提示，以下词元具有最高的logit值：

| token      | logit  |
| ---------- | ------ |
| ▁describes | 18.990 |
| ▁provides  | 17.871 |
| ▁explains  | 17.403 |
| ▁de        | 16.361 |
| ▁gives     | 15.007 |

因此，贪婪采样将确定性地选择`▁describes`作为下一个词元。贪婪采样在重新评估相同的提示时，最适合需要确定性输出的场景。

### **温度采样** 

温度采样是一种概率性方法，这意味着相同的提示在重新评估时可能会产生不同的输出。它使用一个称为温度（temperature）的参数，这个浮点值介于0到1之间，影响结果的随机性。过程如下：

1. 对logits按从高到低排序，并使用**softmax** 函数进行归一化，确保它们的总和为1。这种变换将每个logit转换为一个概率值。Softmax 的作用是将logits**转换为概率** ：Softmax 将模型的输出（logits）转换为可以解释为概率的值。这在多分类问题中尤为重要，模型预测的结果可以解释为每个类别的概率。Softmax 函数确保所有输出值的和为 1，满足概率的定义。
2. 应用一个阈值（默认设置为0.95），只保留概率累加值低于阈值的前几个词元。这一步有效地移除了低概率的词元，防止“坏”或“错误”的词元被采样。
3. 剩余的logits除以温度参数并再次归一化，使它们的总和为1并代表概率。
4. 根据这些概率随机采样一个词元。例如，在我们的提示中，词元`▁describes`的概率为p=0.6，这意味着它大约有60%的概率被选择。在重新评估时，可能会选择不同的词元。

第3步中的温度参数用于增加或减少随机性。较低的温度值会抑制低概率词元，使得在重新评估时更有可能选择相同的词元。因此，较低的温度值减少了随机性。相反，较高的温度值会使概率分布趋于“平坦”，增加低概率词元的影响，从而增加每次重新评估时选择不同词元的可能性，增加随机性。他是softmax函数的一个参数。

![图片](https://g1proxy.wimg.site/sxsTcQPc-sUKPfIojZ52FmaHxbpb3u4wHQSGXEZLuRAo/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqMmDJzRiaXvCcI16S9amtFnUsZsu9Xuib3PC9ic77AyY5ibXLlV5Nu1foicQ/640?wx_fmt=jpeg&from=appmsg)

我们的示例提示的归一化下一个词元概率。较低的温度抑制低概率词元，而较高的温度则强调这些低概率词元。\`temp=0\`与贪婪采样基本相同。

采样一个词元标志着LLM（大型语言模型）一次完整迭代的结束。在初始词元被采样后，它会被添加到词元列表中，整个过程再次运行。输出会随着每次迭代增加一个词元，逐步成为LLM的输入。

理论上，后续的迭代可以以相同方式进行。然而，随着词元列表的增长，性能可能会下降，因此需要采用一些优化技术。这些技术将在接下来介绍。

## **优化推理** 

随着输入给LLM的词元列表增长，Transformer的自注意力阶段可能成为性能瓶颈。词元列表越长，意味着相乘的矩阵越大。每次矩阵乘法都由许多较小的数值运算组成，这些运算称为浮点运算，其性能受限于GPU的每秒浮点运算能力（FLOPS）。在Transformer推理计算中，计算得出对于一个52B参数的模型，在A100 GPU上，当词元数量达到208时，性能开始因为过多的浮点运算而下降。为解决这一瓶颈，最常用的优化技术是**kv缓存** 。

### **KV缓存** 

回顾一下，每个词元都有一个关联的嵌入向量，该嵌入向量通过与参数矩阵`wk`和`wv`相乘进一步转化为键（key）和值（value）向量。**KV缓存** 是用来缓存这些键和值向量的，通过缓存它们，我们可以节省每次迭代重新计算所需的浮点运算。

缓存的工作方式如下：

1. 在初始迭代期间，所有词元的键和值向量都会按照之前的描述进行计算，并保存到KV缓存中。
2. 在后续迭代中，仅需要计算最新词元的键和值向量。缓存的键值向量与新词元的键值向量一起被拼接，形成K和V矩阵。这避免了重新计算所有先前词元的键值向量，从而大大提高了效率。

![图片](https://g1proxy.wimg.site/sz5hOGhJN_8ia6no8e_ZmGlazNx07xC2wPKgXzdsvNJE/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqu9I7n6mMmHdyd0AP8PDzYBB6algWPpcvOkI0PHEyKRjQRd9VNPnKtw/640?wx_fmt=jpeg&from=appmsg)

在后续迭代中，只计算最新词元的键向量，其他的从缓存中提取，并与新计算的键向量一起组成K矩阵。新计算的键向量也会被保存到缓存中。对于值向量，同样的过程也适用。

能够使用键和值向量的缓存，是因为这些向量在迭代之间保持不变。例如，如果我们首先处理四个词元，然后处理五个词元，而最初的四个词元没有变化，那么前四个键和值向量在第一次和第二次迭代中将保持相同。因此，在第二次迭代中不需要重新计算前四个词元的键和值向量。

  
这一原则在Transformer的所有层中都成立，而不仅仅是在第一层。在所有层中，每个词元的键和值向量仅依赖于先前的词元。因此，当在后续迭代中添加新词元时，现有词元的键和值向量保持不变。

对于第一层，这一概念相对容易验证：词元的键向量是通过将词元的固定嵌入向量与固定的`wk`参数矩阵相乘确定的。因此，无论引入了多少新词元，在后续迭代中，它都保持不变。同样的道理也适用于值向量。

对于第二层及后续层，这一原则虽然不那么显而易见，但仍然成立。为了理解其原因，我们可以考虑第一层自注意力阶段的KQV矩阵的输出。KQV矩阵中的每一行是一个加权和，取决于：

* 前面词元的值向量。
* 由前面词元的键向量计算的得分。

因此，KQV矩阵中的每一行仅依赖于之前的词元。经过一些基于行的操作后，这个矩阵作为第二层的输入。这意味着，除了新增的行外，第二层的输入在未来的迭代中将保持不变。通过归纳法，这一逻辑可以延伸到剩余的各层。

![图片](https://g1proxy.wimg.site/srzUeZsJ9nbRYfn1aS3aNbaqGv9YTf74yYHHEuQjlRro/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJq4oS7PcEhqYQ9qqCj8cuMLSCRxJTXFu5r4rG8TYxKOOW6lH9urlyseg/640?wx_fmt=jpeg&from=appmsg)

再来看看KQV矩阵的计算方式。突出显示的第三行仅由第三个查询向量以及前三个键和值向量（同样突出显示）决定。后续的词元不会对其产生影响。因此，在未来的迭代中，它将保持不变。

###   
进一步优化后续迭代

你可能会疑惑，既然我们缓存了键和值向量，为什么不缓存查询向量呢？答案是，实际上，除了当前词元的查询向量外，后续迭代中不再需要之前词元的查询向量。有了**kv缓存** 后，我们实际上只需要将最新词元的查询向量传入自注意力机制即可。这个查询向量将与缓存的K矩阵相乘，计算最后一个词元与所有之前词元的联合得分。然后，它与缓存的V矩阵相乘，只计算KQV矩阵的最新一行。

事实上，在所有层中，我们现在传递的是大小为`1 x n_embd`的向量，而不是在第一次迭代中计算的`n_token x n_embd`矩阵。为了说明这一点，可以对比下图中显示的后续迭代与之前的图示：

![图片](https://g1proxy.wimg.site/s6ivj-r5jf3qsp_5S_1E4RhHuWFHbxaSM-pbT9V4Qem0/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicqibNNcroH8lbOIW5eic8WJqhVhKVdEvABJXNxG70pqSOfTqe7RJUF0uFE1mj1TKqqPK1JuJoia5rVw/640?wx_fmt=jpeg&from=appmsg)

后续迭代中的自注意力机制。在这个示例中，第一次迭代中有四个词元，第二次迭代中添加了第五个词元‘▁is’。最新词元的键、查询和值向量与缓存的键和值向量一起，用于计算KQV矩阵的最后一行，这也是预测下一个词元所需的全部内容。

这个过程在所有层中重复，利用每一层的**kv缓存** 。因此，在这种情况下，Transformer的输出是一个包含`n_vocab`个logit的向量，用于预测下一个词元。

通过这种优化，我们节省了在KQ和KQV矩阵中计算不必要行的浮点运算，这种节省在词元列表增大时尤为显著。

### **KV缓存的实际应用** 

我们可以深入研究`llama.cpp`的代码，了解KV缓存是如何在实践中实现的。不出意外，它是使用张量构建的，一个用于键向量，一个用于值向量：


```
// llama.cpp (simplified)structllama_kv_cache{// cache of key vectorsstructggml_tensor*k=NULL;// cache of value vectorsstructggml_tensor*v=NULL;intn;// number of tokens currently in the cache};
```


在初始化缓存时，为每一层分配足够的空间，以容纳512个键和值向量：


```
// llama.cpp (simplified)// n_ctx = 512 by defaultstaticboolllama_kv_cache_init(structllama_kv_cache&cache,ggml_typewtype,intn_ctx){// Allocate enough elements to hold n_ctx vectors for each layer.constint64_tn_elements=n_embd*n_layer*n_ctx;cache.k=ggml_new_tensor_1d(cache.ctx,wtype,n_elements);cache.v=ggml_new_tensor_1d(cache.ctx,wtype,n_elements);// ...}
```


回顾一下，在推理过程中，计算图是通过`llm_build_llama()`函数构建的。这个函数有一个之前忽略的参数`n_past`。在第一次迭代中，`n_tokens`参数包含词元的数量，而`n_past`被设置为0。在后续迭代中，`n_tokens`被设置为1，因为只处理最新的词元，而`n_past`包含之前的词元数量。`n_past`用于从kv缓存中提取正确数量的键和值向量。

以下是该函数的相关部分，展示了如何使用缓存来计算K矩阵。我稍微简化了一下，忽略了多头注意力机制，并为每一步添加了注释：


```
// llama.cpp (simplified and commented)staticstructggml_cgraph*llm_build_llama(llama_context&lctx,constllama_token*tokens,intn_tokens,intn_past){// ...// Iteratively apply all layers.for(intil=0;il<n_layer;++il){// Compute the key vector of the latest token.structggml_tensor*Kcur=ggml_mul_mat(ctx0,model.layers[il].wk,cur);// Build a view of size n_embd into an empty slot in the cache.structggml_tensor*k=ggml_view_1d(ctx0,kv_cache.k,// sizen_tokens*n_embd,// offset(ggml_element_size(kv_cache.k)*n_embd)*(il*n_ctx+n_past));// Copy latest token's k vector into the empty cache slot.ggml_cpy(ctx0,Kcur,k);// Form the K matrix by taking a view of the cache.structggml_tensor*K=ggml_view_2d(ctx0,kv_self.k,// row sizen_embd,// number of rowsn_past+n_tokens,// strideggml_element_size(kv_self.k)*n_embd,// cache offsetggml_element_size(kv_self.k)*n_embd*n_ctx*il);}}
```


首先，计算新的键向量。接着，使用`n_past`找到缓存中的下一个空位，并将新的键向量复制到那里。最后，通过在缓存中取一个包含正确数量词元（`n_past + n_tokens`）的视图来构建K矩阵。

**KV缓存** 是LLM推理优化的基础。值得注意的是，目前在`llama.cpp`中实现的版本（截至撰写本文时）并不是最优化的。例如，它提前分配了大量内存来容纳支持的最大数量的键和值向量（此处为512个）。一些更高级的实现，如vLLM，旨在提高内存使用效率，并可能提供进一步的性能提升。这些高级技术将留待后续讨论。此外，随着该领域的快速发展，未来可能会出现新的、更优的优化技术。

**脚注** 

1. `ggml`  
还提供了 `ggml_build_backward()`，它通过从输出到输入的反向方式计算梯度。此函数仅在模型训练期间用于反向传播，而在推理中从未使用。↩
2. 这篇文章描述的是编码器-解码器模型。LLaMA 是一个仅解码器模型，因为它一次只预测一个词元。但核心概念是相同的。↩
3. 为简化起见，我在此描述了单头自注意力机制。LLaMA 使用的是多头自注意力机制。除了使张量运算稍微复杂一些外，这并不影响本节中的核心思想。↩
4. 更准确地说，嵌入向量首先经过一个归一化操作，缩放其值。我们忽略了这个步骤，因为它不影响核心思想的表达。↩
5. 得分还会经过**softmax** 操作，缩放后每一行得分的总和为1。↩

您的点赞、在看、关注是我坚持的最大动力！

https://

---

## 扫码加我，或添加微信（ID：LiteAI01）,进行技术、职场及职业规划交流，备注“研究方向+学校/地区+姓名”

![图片](https://g1proxy.wimg.site/sF1SMf3XNYp2LILNcUWfWfn9sRP2hIjUldbHSW20NwqI/https://mmbiz.qpic.cn/mmbiz_jpg/3ZPwf3VnyOicudwnicicU8SUAX06ex96q3WhMnoC1Edo9okoQiat6GwKF0jy86WnJerKnm915o1BcFoo0D4YLoy6eA/640?wx_fmt=jpeg&from=appmsg)
