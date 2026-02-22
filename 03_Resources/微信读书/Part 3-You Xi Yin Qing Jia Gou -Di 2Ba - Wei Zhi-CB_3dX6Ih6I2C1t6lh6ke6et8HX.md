---
doc_type: weread-highlights-reviews
bookId: CB_3dX6Ih6I2C1t6lh6ke6et8HX
reviewCount: 0
noteCount: 4
author: jiajiewu
cover: https://res.weread.qq.com/wrepub/CB_3dX6Ih6I2C1t6lh6ke6et8HX_parsecover
progress: 97%
readingTime: 1小时28分钟
readingDate: 1970-01-01
isbn:
category:
lastReadDate: 2024-01-17
parent: "[[微信读书]]"

---
>[!rnb|noicon] 
># Part 3-You Xi Yin Qing Jia Gou -Di 2Ba - Wei Zhi
>` jiajiewu`

>[!nb|noicon]
>

>[!weread1|noicon] 
> 


>[!weread2|noicon] [![cover|100](https://res.weread.qq.com/wrepub/CB_3dX6Ih6I2C1t6lh6ke6et8HX_parsecover)](https://res.weread.qq.com/wrepub/CB_3dX6Ih6I2C1t6lh6ke6et8HX_parsecover)
> - 作者： jiajiewu
> - 出版时间： 
> - ISBN： 
> - 分类： 
> - 出版社： 
> - 划线数量：4
> - 笔记数量： 0

>[!nb|noicon]
>

>[!rnb|noicon] 
>## 笔记


>[!nb|noicon]
>



   
      
  



### 第5章游戏支持系统



###### 高亮

>[!weread4] 要应对此问题，可使用一个C++的小技巧:在函数内声明的静态变量并不会于main()之前构建，而是在第一次调用该函数时才构建的。因此，若把全局单例改为静态变量，我们就 可以控制全局单例的构建次序。
 >- 2024-01-16 21:47:24
 >---

>[!weread4] 游戏程序员总希望让代码运行得更快。任何软件的效能,不仅受算法的选择和算法编码的效率所影响,程序如何运用内存(RAM)也是重要因素。内存对效能的影响有两方面。
   1.以malloc() 或C++的全局new运算符进行动态内存分配(dynamic memory allocation),这是非常慢的操作。要提升效能，最佳方法是尽量避免动态分配内存，不然也可利用自制的内存分配器来大大减低分配成本。
   2.许多时候，在现代的CPU上,软件的效能受其内存访问模式(memoryaccess pattern) 主 宰。我们将看到,把数据置于细小连续的内存块,相比把数据分散至广阔的内存地址，CPU对前者的操作会高效得多。就算采用最高效的算法，并且极小心地编码,若其操作的数据并非高效地编排于内存中,算法的效能也会被搞垮。本节会介绍如何从这两个方面优化内存的运用。
 >- 2024-01-16 21:59:56
 >---

>[!weread4] 通过malloc () /free() 或C++的全局new/delete运算符动态分配内存-又称为 堆分配(heap allocation)-通常是非常慢的。低效主要来自两个原因。首先,堆分配器(heapallocator) 是通用的设施，它必须处理任何大小的分配请求，从1字节至1000兆字节。这需要大量的管理开销，导致malloc()/free()函数变得缓慢。其次，在多数操作系统中,malloc()/free()必然会从用户模式(usermode)切换至内核模式(kernel mode)处理请求,再切换至原来的程序。这些上下文切换(context-switch)可能会耗费非常多的时间。因此，游戏开发中一个常见的经验法则是:
   维持最低限度的堆分配，并且永不在紧凑循环中使用堆分配。
   当然,任何游戏引擎都无法完全避免动态内存分配，所以多数游戏引擎会实现一个或多个 定制分配器(custom allocator)。定制分配器能享有比操作系统分配器更优的性能特征,原因有二。第一,定制分配器从预分配的内存中完成分配请求(预分配的内存来自malloc()、new,或声明为全局变量)。这样,分配过程都在用户模式下执行,完全避免了进入操作系统的上下文切换。第二,通过对定制分配器的使用模式(usage pattern)做出多个假设，定制分配器便可以 比通用的堆分配器高效得多。
 >- 2024-01-16 22:00:18
 >---

>[!weread4] 使用堆栈和/或池分配器,可以避免一些内存碎片带来的问题。
   ·堆栈分配器完全避免了内存碎片的产生。这是由于,用堆栈分配器分配到的内存块总是连
   续的,并且内存块必然以反向次序释放,如图5.5所示。
   ·池分配器也无内存碎片问题。虽然实际上池会产生碎片，但这些碎片不会像一般的堆，提
   前引发内存不足的情况。向池分配器做分配请求时，不会因缺乏足够大的连续内存块，而造成分配失败,因为池内所有内存块是完全一样大的。
 >- 2024-01-17 22:11:54
 >---






