---
标题: GPU 内存混叠。重叠 GPU 资源并节省... |作者 Pavlo Muratov |升级编码 --- GPU Memory Aliasing. Overlapping GPU resources and saving… | by Pav
url: https://levelup.gitconnected.com/gpu-memory-aliasing-45933681a15e
创建时间: 2024-12-16 11:54
更新时间: 2024-12-16 11:54
笔记ID: HM8B658
收藏: false
划线数量: 3
标签: 
obsidianUIMode: preview
---

# GPU 内存混叠。重叠 GPU 资源并节省... |作者 Pavlo Muratov |升级编码 --- GPU Memory Aliasing. Overlapping GPU resources and saving… | by Pav 

## collectedBy
[[wucai汇总]]

> [阅读原文](https://levelup.gitconnected.com/gpu-memory-aliasing-45933681a15e)
> [在五彩中查看](https://marker.dotalk.cn/#/?nx=HM8B658&vs=1)


## 划线列表

> [!Annotation]
> <font color="#A6FFE9">◇  </font> 解决此问题的常见方法是使用具有兼容属性的资源池：在需要时提取未使用的资源，并在完成工作时将其放回原处，以便可能被其他人使用，然后通过这样做来跳过分配。这适用于后期处理阶段，例如，因为它们通常实现为全屏渲染通道，所有渲染通道都读取和写入具有相同属性的纹理。基本上，我们只能为整个后处理管道分配两个纹理。从本质上讲，这是一个高级内存混叠。

> ^b6kmd69
> 
> ---
> 🦊 此问题指的是：
此处的观察结果是，某个阶段产生的资源可能仅由少数其他阶段使用。后处理渲染通道就是一个很好的示例：泛光通道可以生成其输出，该输出将仅由下一阶段使用，即色调映射，而不需要帧中的其他任何位置。我们可以看到，资源的有效生命周期可能很小，但很可能是预先分配的，并在整个帧中占用其内存。大型 pipeline 可能具有大量生成的资源，这些资源都将位于其永久占用的内存区域中，并消耗大量 VRAM。除非我们对此有所作为。

> [!Annotation]
> <font color="#A6FFE9">◇  </font> 当我们使用 API 为内存设置别名时，我们不再关心资源类型，而只关心它们的大小和内存地址。我们仍然可以事先分配一次资源，以避免性能下降，但我们也可以比在池示例中更有效地将它们打包到内存中，方法是将不相交时间段内使用的资源放在同一个内存区域中，而不考虑资源类型，因为在低级别，它们只是 VRAM 中的一堆字节。

> ^b6kmmk3
> 
> ---
> 🦊 在低级别，不同类型的资源也是字节流，可以把它们放到同一个内存池子中，而不关心资源的类型

> [!Highlight] 
> <font color="#A6FFE9">◇  </font> 现在回到内存打包。我们希望尽可能减少内存占用，但是我们能降到多低呢？如果我们查看示例资源，我们会看到最大的资源是大小为 15 MB 的 D，因此即使我们将每个资源放在彼此之上，而不考虑生命周期，我们也将使用 15 MB 的内存，这意味着在最佳情况下，内存总量至少是最大资源所需的内存量。

> ^b6kmm99


