---
doc_type: weread-highlights-reviews
bookId: CB_AKo8Kw8LVAy56q56op15u13I
reviewCount: 1
noteCount: 1
author: ""
cover: https://res.weread.qq.com/wrepub/CB_AKo8Kw8LVAy56q56op15u13I_parsecover
readingStatus: 未标记
progress: 5%
totalReadDay: 3
readingTime: 0小时27分钟
readingDate: 2024-08-10
isbn: 
category: 
lastReadDate: 2024-08-15
parent: "[[微信读书索引]]"

---
>[!rnb|noicon] 
># RTR4-CN
>` `

>[!nb|noicon]
>

>[!weread1|noicon] 
> 


>[!weread2|noicon] [![cover|100](https://res.weread.qq.com/wrepub/CB_AKo8Kw8LVAy56q56op15u13I_parsecover)](https://res.weread.qq.com/wrepub/CB_AKo8Kw8LVAy56q56op15u13I_parsecover)
> - 作者： 
> - 出版时间： 
> - ISBN： 
> - 分类： 
> - 出版社： 
> - 划线数量：1
> - 笔记数量： 1

>[!nb|noicon]
>

>[!rnb|noicon] 
>## 笔记


>[!nb|noicon]
>



   
      
  


   


### 3.2 GPU 管线概述



###### 高亮

>[!weread4] 另⼀个影响整体运⾏效率的因素是由“if”语句和循环语句导致的动态分⽀（dynamic branching）。假设现在我们的着⾊器程序中遇到了⼀个“if”语句，如果所有线程都进⼊了相同的分⽀，那么这个 warp 可以不⽤管其他的分⽀，继续执⾏进⼊的那个分⽀即可。但是，如果其中有⼏个线程，甚⾄是只有⼀个线程进⼊了其他的分⽀，那么这个 warp 就必须把两个分⽀都执⾏⼀遍，然后再根据每个线程的具体情况，丢弃不需要的结果[530, 945]。这个问题叫做线程发散（thread divergence），它意味着有的“if”分⽀，这会导致其他的线程空转。
 >- 2024-08-15 21:33:25
 >---






###### 评论

 >[!weread3] 另⼀个影响整体运⾏效率的因素是由“if”语句和循环语句导致的动态分⽀（dynamic branching）。假设现在我们的着⾊器程序中遇到了⼀个“if”语句，如果所有线程都进⼊了相同的分⽀，那么这个 warp 可以不⽤管其他的分⽀，继续执⾏进⼊的那个分⽀即可。但是，如果其中有⼏个线程，甚⾄是只有⼀个线程进⼊了其他的分⽀，那么这个 warp 就必须把两个分⽀都执⾏⼀遍，然后再根据每个线程的具体情况，丢弃不需要的结果[530, 945]。这个问题叫做线程发散（thread divergence），它意味着有的“if”分⽀，这会导致其他的线程空转。 
 > - 尽量避免在 shader 中使用 if 逻辑判断，这会导致一个 wrap 中的线程发散，一些线程在空转。
 > - 2024-08-15 21:34:27
 >---




