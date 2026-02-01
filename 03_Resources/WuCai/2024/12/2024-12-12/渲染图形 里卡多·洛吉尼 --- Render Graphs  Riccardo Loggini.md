---
标题: 渲染图形 |里卡多·洛吉尼 --- Render Graphs | Riccardo Loggini
url: https://logins.github.io/graphics/2021/05/31/RenderGraphs.html
创建时间: 2024-12-12 11:20
更新时间: 2024-12-12 11:20
笔记ID: HM8K566
收藏: false
划线数量: 4
标签: 
obsidianUIMode: preview
---

# 渲染图形 |里卡多·洛吉尼 --- Render Graphs | Riccardo Loggini 

## collectedBy
[[wucai汇总]]

> [阅读原文](https://logins.github.io/graphics/2021/05/31/RenderGraphs.html)
> [在五彩中查看](https://marker.dotalk.cn/#/?nx=HM8K566&vs=1)


## 划线列表

> [!Highlight] 
> <font color="#A6FFE9">◇  </font> Having engine render code directed by a render graph brings many properties.
> 让引擎渲染代码由渲染图指导会带来许多属性。
> First of all, it brings a much more clear order of execution to the graphics operations: each render operation gets abstracted to a single way to produce render code.
> 首先，它为图形操作带来了更清晰的执行顺序：每个渲染操作都被抽象为一种生成渲染代码的方式。

> ^b65h6bh

> [!Annotation]
> <font color="#FFC7BA">◇  </font> 那么我们需要在两个通道之间进行资源转换以渲染目标

> ^b65heb2
> 
> ---
> 🦊 资源转换指的是什么？

> [!Highlight] 
> <font color="#A6FFE9">◇  </font> 使用渲染图时，我们可以确定 3 个步骤：
> 
> Setup phase: declares which render passes will exist and what resources will be accessed by them.
> Setup phase：声明将存在哪些渲染通道以及它们将访问哪些资源。
> Compile phase: figure out resources lifetime and make resource allocations accordingly.
> 编译阶段：计算资源生命周期并相应地进行资源分配。
> Execute phase: all the graph nodes get executed.
> Execute phase：执行所有 graph 节点。

> ^b65h5ah

> [!Highlight] 
> <font color="#A6FFE9">◇  </font> 要构建图形，我们可以使用 GraphBuilder 类型对象，我们可以从中静态检索用于推送所有渲染通道的实例。
> 
> GraphBuilder::Get().AddPass(
> “MyPassName”,
> Flags,
> MyPassParameters,
> [MyPassParameters](){
> 	/* My lambda function body where we will use the PassParameters (and possibly other information) to send dispatch or draw commands */
> } ); 
> Each pass will be created from:
> 每张通行证将由以下来源创建：
> 
> Name 名字
> Flags (e.g. if the pass is to be considered a graphics or compute one)
> 标志（例如，如果将通道视为图形或计算通道）
> Pass parameters: used to understand the needed resource transitions, lifetimes and aliasing.
> Pass parameters：用于了解所需的资源转换、生命周期和别名。
> Execution lambda: where we are still going to capture the parameters just declared to use them on the drawing or dispatch commands.
> 执行 lambda：我们仍将捕获刚刚声明的参数，以便在绘图或调度命令中使用它们。

> ^b65h578


