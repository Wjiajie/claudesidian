---
doc_type: weread-highlights-reviews
bookId: CB_2MkEUEEVtAYh6lL6ke4vcArf
reviewCount: 0
noteCount: 2
author: ""
cover: https://res.weread.qq.com/wrepub/CB_3VM96C97KG0S6kW6kw9zb2j1_parsecover
readingStatus: 读完
progress: 99%
totalReadDay: 14
readingTime: 5小时1分钟
readingDate: 2023-12-30
finishedDate: 2023-12-30
isbn: 
category: 
lastReadDate: 2024-04-14
parent: "[[微信读书索引]]"

---
>[!rnb|noicon] 
># RTR4-CN
>` `

>[!nb|noicon]
>

>[!weread1|noicon] 
> 


>[!weread2|noicon] [![cover|100](https://res.weread.qq.com/wrepub/CB_3VM96C97KG0S6kW6kw9zb2j1_parsecover)](https://res.weread.qq.com/wrepub/CB_3VM96C97KG0S6kW6kw9zb2j1_parsecover)
> - 作者： 
> - 出版时间： 
> - ISBN： 
> - 分类： 
> - 出版社： 
> - 划线数量：2
> - 笔记数量： 0

>[!nb|noicon]
>

>[!rnb|noicon] 
>## 笔记


>[!nb|noicon]
>



   
      
  

   
      
  



### 3.3 可编程着⾊器阶段



###### 高亮

>[!weread4] 现代的着⾊器程序都使⽤了统⼀的着⾊器设计，这意味着顶点着⾊器、像素着⾊器、⼏何着⾊器以及与曲⾯细分相关的着⾊器，都共享⼀个通⽤的编程模型，它们内部的指令集架构（instruction set architecture，ISA）都是相同的。在 DirectX 中，实现这个模型的处理器叫做公共着⾊器核⼼（common-shader core），具有这个核⼼的 GPU 被称作拥有⼀个统⼀的着⾊器架构。这种架构背后的思想是，这些着⾊处理器可以⽤于执⾏很多的任务，⽽ GPU 可以视情况来对这些处理器进⾏分配。
 >- 2024-04-14 13:23:01
 >---








### 3.4 可编程着⾊及其 API 的演变





###### 高亮

>[!weread4] AMD 将⾃身 Mantle 的⼯作贡献给了 Khronos 组织，后者于 2016 年推出了新⼀代
   的 API，叫做 Vulkan。与 OpenGL ⼀样，Vulkan 可以⽤于多个操作系统。Vulkan 使⽤了⼀种被称为 SPIR-V 的全新⾼级中间语⾔，它可以同时⽤于着⾊器表示和通⽤ GPU 计算。这些预编译的着⾊器代码是可移植的，因此可以在任何⽀持该功能特性的 GPU 上进⾏使⽤[885]。Vulkan 也可以被⽤于⾮图形的 GPU 计算，这些计算通常并没有⼀个⽤于显示画⾯的窗⼝[946]。与其他低开销驱动的 API 相⽐，Vulkan 的⼀个显著区别在于，它具有⼗分强⼤的跨平台特性，可以在从⼯作站到移动设备的很多系统上进⾏使⽤。
   在移动设备上⼀般会使⽤ OpenGL ES，其中“ES”代表的是嵌⼊式系统（embedded system），因为这个 API 是针对移动设备进⾏开发的；这是由于标准 OpenGL 中的⼀些调⽤结构⼗分臃肿和缓慢，并且还需要对其中很少使⽤到的功能进⾏⽀持。
 >- 2024-04-14 14:03:09
 >---






