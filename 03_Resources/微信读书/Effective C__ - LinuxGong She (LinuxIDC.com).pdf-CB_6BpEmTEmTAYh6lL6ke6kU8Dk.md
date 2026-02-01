---
doc_type: weread-highlights-reviews
bookId: CB_6BpEmTEmTAYh6lL6ke6kU8Dk
reviewCount: 1
noteCount: 16
author: Linux公社（LinuxIDC.com）
cover: https://res.weread.qq.com/wrepub/CB_7hsBhcBiXFcP6lF6kf4i76Ir_parsecover
readingStatus: 未标记
progress: 72%
totalReadDay: 32
readingTime: 13小时1分钟
readingDate: 2023-12-30
isbn: 
category: 
lastReadDate: 2024-04-08
parent: "[[微信读书索引]]"

---
>[!rnb|noicon] 
># Effective C__ - LinuxGong She (LinuxIDC.com).pdf
>` Linux公社（LinuxIDC.com）`

>[!nb|noicon]
>

>[!weread1|noicon] 
> 


>[!weread2|noicon] [![cover|100](https://res.weread.qq.com/wrepub/CB_7hsBhcBiXFcP6lF6kf4i76Ir_parsecover)](https://res.weread.qq.com/wrepub/CB_7hsBhcBiXFcP6lF6kf4i76Ir_parsecover)
> - 作者： Linux公社（LinuxIDC.com）
> - 出版时间： 
> - ISBN： 
> - 分类： 
> - 出版社： 
> - 划线数量：16
> - 笔记数量： 1

>[!nb|noicon]
>

>[!rnb|noicon] 
>## 笔记


>[!nb|noicon]
>



   
      
  

  

  

  

   
      
  

  

   
      
  

   
      
  

   
      
  

   
      
  

   
      
  

  


   


### www.linuxidc.com



###### 高亮

>[!weread4] 幸运的是你不需要对这种无聊事情提供温床。你可以获得宏带来的效率以及一般函数的所有可预料行为和类型安全性(type safety)一只要你写出template inline函数(见条款30):
 >- 2024-01-14 14:04:09
 >---




###### 高亮

>[!weread4] const 语法虽然变化多端，但并不莫测高深。如果关键字const出现在星号左 边，表示被指物是常量:如果出现在星号右边，表示指针自身是常量;如果出现在星号两边，表示被指物和指针两者都是常量。
 >- 2024-01-14 14:09:22
 >---




###### 高亮

>[!weread4] 解决办法很简单:利用C++的一个与const相关的摆动场:mutable(可变的)。
   mutable释放掉non-static成员变量的bitwise constness约束
 >- 2024-01-14 20:00:29
 >---




###### 高亮

>[!weread4] 这个构造函数和上一个的最终结果相同，但通常效率较高。基于赋值的那个版
   本(本例第一版本)首先调用default构造函数为theName, theAddress和thePhones设初值，然后立刻再对它们赋予新值。default构造函数的一切作为因此浪费了。成员初值列(member initialization list)的做法(本例第二版本)避免了这一问题，因为初值列中针对各个成员变量而设的实参，被拿去作为各成员变量之构造函数的实参。
 >- 2024-01-15 09:34:19
 >---

>[!weread4] 既然这样，为避免在对象初始化之前过早地使用它们，你需要做三件事。第一，手工初始化内置型non-member对象。第二，使用成员初值列(member initializationlists)对付对象的所有成分。最后，在“初始化次序不确定性”(这对不同编译单
   元所定义的non-local static对象是一种折磨)氛围下加强你的设计。
   请记住
   ■为内置型对象进行手工初始化，因为C++不保证初始化它们。
   构造函数最好使用成员初值列(member initialization list)，而不要在构造函数本体内使用赋值操作(assignment)。初值列列出的成员变量，其排列次序应该和它们在class中的声明次序相同。
   为免除“跨编译单元之初始化次序”问题，请以local static对象替换non-local
   static对象。
 >- 2024-01-15 13:21:24
 >---






###### 高亮

>[!weread4] 啊呀，阻止这一类代码的编译并不是很直观。通常如果你不希望class支持某一
   特定机能，只要不声明对应函数就是了。但这个策略对copy构造函数和copyassignment操作符却不起作用，因为条款5已经指出，如果你不声明它们，而某些
   人尝试调用它们，编译器会为你声明它们。
   这把你逼到了一个困境。如果你不声明copy构造函数或copy assignment操作符，编译器可能为你产出一份，于是你的class支持copying。如果你声明它们，你的class
   还是支持copying。但这里的目标却是要阻止copying!答案的关键是,所有编译器产出的函数都是public。为阻止这些函数被创建出来，你得自行声明它们，但这里并没有什么需求使你必须将它们声明为public。因此你可以将copy构造函数或copy assignment操作符声明为private。借由明确声明一个成员函数，你阻止了编译器暗自创建其专属版本;而令这些函数为private，使你得以
   成功阻止人们调用它。
 >- 2024-01-20 16:16:23
 >---














###### 高亮

>[!weread4] 如果成员函数是个non-virtual函数，意味是它并不打算在derived classes中有
   不同的行为。实际上一个non-virtual成员函数所表现的不变性(invariant)凌驾其特异性(specialization)，因为它表示不论derived class变得多么特异化，它的行为
   都不可以改变。就其自身而言:
   声明non-virtual 函数的目的是为了令derived classes继承函数的接口及一份强制性实现。
   你可以把Shape::objectID的声明想做是:“每个Shape对象都有一个用来产
   生对象识别码的函数;此识别码总是采用相同计算方法，该方法由Shape::objectID的定义式决定，任何derived class都不应该尝试改变其行为”。由于non-virtual函数代表的意义是不变性(invariant)凌驾特异性(specialization)，所以它绝不该在derived class中被重新定义。
 >- 2024-03-27 00:15:55
 >---

>[!weread4] 实际上任何时候当你将class内的某个机能(也许取道自某个成员函数)替换为class外部的某个等价机能(也许取道自某个non-member non-friend函数或另一个class的non-friend成员函数)，这都是潜在争议点。这个争议将持续至本条款其余篇幅，因为我们即将考
   虑的所有替代设计也都涉及使用GameCharacter继承体系外的函数。一般而言，唯一能够解决“需要以non-member函数访问class 的non-public成
   分”的办法就是:弱化class的封装。例如class可声明那个non-member函数为friends，或是为其实现的某一部分提供public访问函数(其他部分则宁可隐藏起来)。运用函数指针替换virtual 函数，其优点(像是“每个对象可各自拥有自己的健康计算函数”和“可在运行期改变计算函数”)是否足以弥补缺点(例如可能必
   须降低GameCharacter封装性)，是你必须根据每个设计情况的不同而抉择的。
 >- 2024-04-08 22:04:13
 >---

>[!weread4] 如你所见，HealthCalcFunc是个typedef，用来表现tr1::function的某个具现体，意味该具现体的行为像一般的函数指针。现在我们靠近一点瞧瞧HealthCalcFunc是个什么样的typedef:
   std::tr1::function<int (const GameCharacter&)>
   这里我把tr1:;function具现体(instantiation)的目标签名式(target signature )
   以不同颜色强调出来。那个签名代表的函数是“接受一个reference指向constGameCharacter，并返回int”。这个trl::function类型(也就是我们所定义的HealthCalcFunc类型)产生的对象可以持有(保存)任何与此签名式兼容的可调用物(callable entity)。所谓兼容,意思是这个可调用物的参数可被隐式转换为const
   GameCharacter&，而其返回类型可被隐式转换为int。
   和前一个设计(其GameCharacter持有的是函数指针)比较，这个设计几乎相
   同。唯一不同的是如今GameCharacter 持有一个tr1::function对象，相当于一个指向函数的泛化指针。这个改变如此细小，我总说它没有什么外显影响，除非客
   户在“指定健康计算函数”这件事上需要更惊人的弹性
 >- 2024-04-08 22:11:58
 >---

>[!weread4] 就我个人而言，当我发现tr1::function允许我们做的事时，非常吃惊。它让我浑身震颤。如果你没有这样的感觉，也许是你早已曾经惊叹tr1::bind所发生的事情。
 >- 2024-04-08 22:12:07
 >---








### 构造/析构/赋值运算











###### 高亮

>[!weread4] C++的响应是拒绝编译那一行赋值动作。如果你打算在一个“内
   含 reference 成员”的class内支持赋值操作(assignment)，你必须自己定义copyassignment操作符。面对“内含const成员”(如本例之objectValue)的classes，编译器的反应也一样。更改const成员是不合法的，所以编译器不知道如何在它自己生成的赋值函数内面对它们。最后还有一种情况:如果某个base classes将copyassignment操作符声明为private，编译器将拒绝为其derived classes生成一个copyassignment操作符。毕竟编译器为derived classes所生的copy assignment操作符想象中可以处理base class成分(见条款12)，但它们当然无法调用derived class 无权
   调用的成员函数。编译器两手一摊，无能为力。
 >- 2024-01-15 23:25:55
 >---






















### 资源管理















###### 高亮

>[!weread4] 所谓资源就是，一旦用了它，将来必须还给系统。如果不这样，糟糕的事情就会发生。C++程序中最常使用的资源就是动态分配内存(如果你分配内存却从来不曾归还它，会导致内存泄漏)，但内存只是你必须管理的众多资源之一。其他常见的资源还包括文件描述器(file descriptors)、互斥锁(mutexlocks)、图形界面中的字型和笔刷、数据库连接、以及网络sockets。不论哪一种资源，重要的是，当你
   不再使用它时，必须将它还给系统。
 >- 2024-01-23 00:10:30
 >---


















### 设计与声明

















###### 高亮

>[!weread4] 好的接口很容易被正确使用，不容易被误用。你应该在你的所有接口中努力达成这
   些性质。
   ■“促进正确使用”的办法包括接口的一致性，以及与内置类型的行为兼容。
   “阻止误用”的办法包括建立新类型、限制类型上的操作，束缚对象值，以及消除
   客户的资源管理责任。
   tr1::shared ptr支持定制型删除器(custom deleter)。这可防范DLL问题，可被
   用来自动解除互斥锁(mutexes;见条款14)等等。
 >- 2024-02-02 00:56:49
 >---
















### 条款 29:为“异常安全”而努力是值得的



















###### 高亮

>[!weread4] 有个一般化的设计策略很典型地会导致强烈保证，很值得熟悉它。这个策略被称为copy and swap。原则很简单:为你打算修改的对象(原件)做出一份副本，然后在那副本身上做一切必要修改。若有任何修改动作抛出异常，原对象仍保持未改变状态。待所有改变都成功后，再将修改过的
   那个副本和原对象在一个不抛出异常的操作中置换(swap)。
 >- 2024-02-29 22:44:23
 >---














### 条款 30:透彻了解inlining 的里里外外





















###### 高亮

>[!weread4] 大部分编 译器拒绝将太过复杂(例如带有循环或递归)的函数inlining，而所有对virtual 函数的调用(除非是最平淡无奇的)也都会使inlining落空。这不该令你惊讶，因为virtual 意味“等待，直到运行期才确定调用哪个函数”，而inline意味“执行前，先将调用动作替换为被调用函数的本体”。如果编译器不知道该调用哪个函数，你就很难责备它们拒绝将函数本体inlining。
 >- 2024-03-10 15:35:31
 >---












### 条款 33:避免遮掩继承而来的名称























###### 高亮

>[!weread4] 编译
   器的做法是查找各作用域，看看有没有某个名为mf2的声明式。首先查找local 作用域(也就是mf4覆盖的作用域)，在那儿没找到任何东西名为mf2。于是查找其外围作用域，也就是class Derived覆盖的作用域。还是没找到任何东西名为mf2,于是再往外围移动，本例为base class。在那儿编译器找到一个名为mf2的东西了，于是停止查找。如果Base内还是没有mf2，查找动作便继续下去，首先找内含Base
   的那个namespace(s)的作用域(如果有的话)，最后往global作用域找去。
 >- 2024-03-24 22:22:19
 >---








###### 评论

 >[!weread3] 编译
器的做法是查找各作用域，看看有没有某个名为mf2的声明式。首先查找local 作用域(也就是mf4覆盖的作用域)，在那儿没找到任何东西名为mf2。于是查找其外围作用域，也就是class Derived覆盖的作用域。还是没找到任何东西名为mf2,于是再往外围移动，本例为base class。在那儿编译器找到一个名为mf2的东西了，于是停止查找。如果Base内还是没有mf2，查找动作便继续下去，首先找内含Base
的那个namespace(s)的作用域(如果有的话)，最后往global作用域找去。 
 > - 能local 尽量 local ，涉及到查找效率
 > - 2024-03-24 22:22:52
 >---




