---
标题: C/C++中最最快的Json库
url: https://mp.weixin.qq.com/s?__biz=MzkyODU5MTYxMA==&mid=2247494384&idx=1&sn=dc49c11bef7f189a330321c824318680&chksm=c310f688196060d7f8c908ba1ef6cf0e314f0190a4022d17abef8d1141468b5e630a91412438&xtrack=1&scene=90&subscene=93&sessionid=1734929004&flutter_pos=5&clicktime=1734930189&enterid=1734930189&finder_biz_enter_id=4&ranksessionid=1734929024&ascene=56&fasttmpl_type=0&fasttmpl_fullversion=7521716-zh_CN-zip&fasttmpl_flag=0&realreporttime=1734930189465&devicetype=android-34&version=28003734&nettype=3gnet&abtest_cookie=AAACAA%3D%3D&lang=zh_CN&session_us=gh_6498c2229751&countrycode=CN&exportkey=n_ChQIAhIQIjbOrnqHxF0AtcBPBZUS1BLxAQIE97dBBAEAAAAAAB8eI5OM9zsAAAAOpnltbLcz9gKNyK89dVj01arZn%2FW3z1XjXWZYFWsbwTWnM4phgliiOvdepsl%2Fl9Ol2vIxjUj%2BDl9UIHStKXOIcZb612d9bZVzsRa5PCYzEb6VH%2Biwhx7pW37mV4vKv2vk85QSqOv68o7jHC5NA5lN4%2FWxIVNrUZwcTm55I6HZm9GxeGGN8ea1OJKzYA%2FZWMuImpTKrNqpbe9s0HK%2BANGWe0MCjVPSbcBgwb07oetueq%2Fwv2zR56HyxfCRILlEH0dU3%2FXiZ6RMD1Dv6pmmlV1GV87kNau%2BY6XHXIM%3D&pass_ticket=4%2BFcgSPUW1TuMIh07hj6eN58JnHTPr%2Fn92g8ghWY7IhTrUaVay8srmO%2BVyG3F6Bl&wx_header=3
创建时间: 2024-12-23 13:03
更新时间: 2024-12-23 13:03
笔记ID: HM79DD8
收藏: false
划线数量: 1
标签: 
obsidianUIMode: preview
---

# C/C++中最最快的Json库 

## collectedBy
[[wucai汇总]]

> [阅读原文](https://mp.weixin.qq.com/s?__biz=MzkyODU5MTYxMA==&mid=2247494384&idx=1&sn=dc49c11bef7f189a330321c824318680&chksm=c310f688196060d7f8c908ba1ef6cf0e314f0190a4022d17abef8d1141468b5e630a91412438&xtrack=1&scene=90&subscene=93&sessionid=1734929004&flutter_pos=5&clicktime=1734930189&enterid=1734930189&finder_biz_enter_id=4&ranksessionid=1734929024&ascene=56&fasttmpl_type=0&fasttmpl_fullversion=7521716-zh_CN-zip&fasttmpl_flag=0&realreporttime=1734930189465&devicetype=android-34&version=28003734&nettype=3gnet&abtest_cookie=AAACAA%3D%3D&lang=zh_CN&session_us=gh_6498c2229751&countrycode=CN&exportkey=n_ChQIAhIQIjbOrnqHxF0AtcBPBZUS1BLxAQIE97dBBAEAAAAAAB8eI5OM9zsAAAAOpnltbLcz9gKNyK89dVj01arZn%2FW3z1XjXWZYFWsbwTWnM4phgliiOvdepsl%2Fl9Ol2vIxjUj%2BDl9UIHStKXOIcZb612d9bZVzsRa5PCYzEb6VH%2Biwhx7pW37mV4vKv2vk85QSqOv68o7jHC5NA5lN4%2FWxIVNrUZwcTm55I6HZm9GxeGGN8ea1OJKzYA%2FZWMuImpTKrNqpbe9s0HK%2BANGWe0MCjVPSbcBgwb07oetueq%2Fwv2zR56HyxfCRILlEH0dU3%2FXiZ6RMD1Dv6pmmlV1GV87kNau%2BY6XHXIM%3D&pass_ticket=4%2BFcgSPUW1TuMIh07hj6eN58JnHTPr%2Fn92g8ghWY7IhTrUaVay8srmO%2BVyG3F6Bl&wx_header=3)
> [在五彩中查看](https://marker.dotalk.cn/#/?nx=HM79DD8&vs=1)


## 划线列表

> [!Annotation]
> <font color="#A6FFE9">◇  </font> Glaze概述
> 
> Glaze是一个专为现代C++设计的高性能JSON库，以其超高的性能著称。它不仅支持标准的JSON格式，还扩展了对BEVE（二进制高效通用编码）和CSV（逗号分隔值）格式的支持，使其在多种数据处理场景中都能大显身手。Glaze的核心技术在于其编译时反射机制，支持MSVC、Clang和GCC等主流编译器。通过编译时反射，Glaze能够自动处理聚合可初始化的结构体，无需用户编写任何元数据或宏，这种设计不仅提高了代码的可读性和维护性，还显著提升了运行时的性能。
> 
> Glaze提供了丰富的特性，包括但不限于：
> 
>     纯编译时反射：自动反射结构体，无需额外元数据。
>     JSON RFC 8259合规：支持UTF-8验证，确保数据格式的正确性。
>     标准C++库支持：与标准库无缝集成，简化开发流程。
>     头文件库：轻量级设计，便于集成和使用。
>     直接内存序列化/反序列化：高效处理大数据量，减少内存开销。
>     编译时映射：提供常量时间查找和完美哈希，优化数据访问速度。
>     强大的包装器：灵活修改读写行为，满足多样化需求。
>     自定义读写函数：允许用户定义自己的读写逻辑，增强灵活性。
>     快速处理未知键：灵活应对JSON中的未知键，确保数据处理的健壮性。
>     JSON指针语法：通过JSON指针语法直接访问内存，简化数据操作。
>     二进制数据支持：通过同一API处理二进制数据，最大化性能。
>     无异常设计：支持无异常编译，减少运行时开销。
>     快速错误处理：短路机制，迅速响应错误情况。
>     JSON-RPC 2.0支持：简化远程过程调用，提升系统集成能力。
>     JSON Schema生成：自动生成JSON Schema，简化数据验证流程。
>     高度可移植：采用SWAR（寄存器内SIMD）技术，确保广泛的兼容性。
>     部分读写支持：灵活处理部分数据，适应复杂应用场景。
>     CSV读写支持：扩展对CSV格式的支持，增强数据处理能力。

> ^b6ace85
> 
> ---
> 🦊 高效json 库 glaze


