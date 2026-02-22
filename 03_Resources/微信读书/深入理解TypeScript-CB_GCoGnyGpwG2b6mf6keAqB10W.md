---
doc_type: weread-highlights-reviews
bookId: CB_GCoGnyGpwG2b6mf6keAqB10W
reviewCount: 0
noteCount: 14
author: chenjin5.com
cover: https://res.weread.qq.com/wrepub/CB_2FcGEiGCnAf26jQ6kfDIp1uu_parsecover
readingStatus: 未标记
progress: 36%
totalReadDay: 7
readingTime: 2小时53分钟
readingDate: 2024-03-02
isbn: 
category: 
lastReadDate: 2024-03-25
parent: "[[微信读书]]"

---
>[!rnb|noicon] 
># 深入理解TypeScript
>` chenjin5.com`

>[!nb|noicon]
>

>[!weread1|noicon] 
> 


>[!weread2|noicon] [![cover|100](https://res.weread.qq.com/wrepub/CB_2FcGEiGCnAf26jQ6kfDIp1uu_parsecover)](https://res.weread.qq.com/wrepub/CB_2FcGEiGCnAf26jQ6kfDIp1uu_parsecover)
> - 作者： chenjin5.com
> - 出版时间： 
> - ISBN： 
> - 分类： 
> - 出版社： cj5
> - 划线数量：14
> - 笔记数量： 0

>[!nb|noicon]
>

>[!rnb|noicon] 
>## 笔记


>[!nb|noicon]
>



   
      
  

   
      
  

   
      
  



### 第2章 JavaScript常见语法



###### 高亮

>[!weread4] 与==和===类似，！=和！==也存在同样的问题。因此，除了空检查，推荐使用===和！==，接下来我们将会讲解它们。
 >- 2024-03-02 13:05:52
 >---

>[!weread4] 推荐使用==null来检查undefined和null，因为你通常并不希望区分它们。
 >- 2024-03-02 13:05:20
 >---










### 第3章 JavaScript新语法特性





###### 高亮

>[!weread4] 如果未指定访问修饰符，则默认是public的，因为它符合JavaScript方便的特性。
 >- 2024-03-02 17:07:00
 >---

>[!weread4] 4.抽象（abstract）
   abstract也可以被认为是一个访问修饰符，之所以单独介绍它，是因为与前面提到的修饰符不同，abstract 可以作用在类及类的任何成员上。拥有一个 abstract 修饰符意味着该函数不能直接被调用，并且子类必须实现这个功能。
   ● abstract类不能直接被实例化，用户必须创建一个类来继承abstract 类。
   ● abstract成员不能直接被访问，子类必须实现这个功能。
 >- 2024-03-02 17:13:47
 >---

>[!weread4] var变量在JavaScript中是函数作用域。这与其他许多语言（C＃、Java等）不同，它们的变量是块作用域。
 >- 2024-03-03 12:49:26
 >---

>[!weread4] 这是因为在if块内并没有创建一个新的变量作用域。变量foo在if块内外都是相同的（它在块外有一个相同的定义）。这是 JavaScript 编程中常见的错误来源，也是TypeScript和ES6推荐你在一个真实的块作用域内使用let来定义变量的原因。用let代替var，可以让你得到一个与外界变量相隔离的、真实的、唯一的元素
 >- 2024-03-03 12:49:38
 >---

>[!weread4] 我们发现，无论何时，使用let都会更好一些，因为它会给新的或现有的多语言开发人员带来更少的意外。
 >- 2024-03-03 12:51:14
 >---

>[!weread4] 在这里，函数关闭了局部变量（通常被命名为local）的访问（由此被称为闭包），并使用这个而不是循环变量i。请注意，闭包会对性能产生影响（它们需要存储周围的状态）
 >- 2024-03-03 12:58:59
 >---

>[!weread4] let对绝大多数代码都非常有用。它可以极大地加强代码的可读性，并能降低发生错误的概率。
 >- 2024-03-03 12:59:56
 >---

>[!weread4] const创建的块作用域与let相似。
 >- 2024-03-03 13:04:21
 >---

>[!weread4] const也可以处理对象字面量，以保护变量引用。[插图]然而，它仍然允许对象的子属性的改变。
 >- 2024-03-03 13:06:32
 >---

>[!weread4] 建议尽量使用const，除非你计划延迟初始化变量，或者重新分配（这种情况请使用let）。
 >- 2024-03-05 11:54:55
 >---

>[!weread4] JavaScript开发人员经常遇到的一个错误是：for...in不能迭代数组成员。但是，它会迭代传入对象的键名。如下面的例子所示，你期望得到9，2，5，但是实际得到了索引0，1，2。
 >- 2024-03-18 22:34:25
 >---








### 第4章 TypeScript项目构成







###### 高亮

>[!weread4] 在 bar.ts 文件里使用 import 时，它不仅允许你使用从其他文件导入的内容，还会将此文件 bar.ts标记为一个模块，在文件内定义的声明也不会“污染”全局命名空间。
 >- 2024-03-25 15:33:00
 >---






