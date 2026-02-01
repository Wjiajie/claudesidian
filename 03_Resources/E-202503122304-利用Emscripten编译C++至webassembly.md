---
标题: 利用Emscripten编译C++至webassembly
tags:
  - 编程
author:
  - 吴家杰
parent: "[[技术栈]]"
---

# 利用Emscripten编译C++至webassembly

type: Post
collectedBy: 核心能力/编程语言
slug: emscripten_intro
summary: 最近我希望能将实现的python算子通过taichi封装后打包成C++静态库，结合C++代码形成应用，并希望这个应用能在web上自由地运行，用户不需要关心具体平台，登录任何小程序就可以体验到发布的程序，于是有了这篇文章的尝试。选择从C++编译至webassembly主要是出于性能上的考量，这条链路应该是一个比较成熟的方案了。
tags: C++, 编码架构
date: 2024年8月17日
status: Published

## 方案选择

C++编译至webassembly的方案有挺多的。

- Emscripten 是一个 LLVM 到 JavaScript 编译器，它可以将 C/C++ 代码编译成 JavaScript 代码，以便在浏览器中运行。它通过模拟 POSIX 环境，为编译的代码提供了一个可移植的运行环境。
- PNaCl：PNaCl 是一个插件，可以将 C/C++ 代码编译成适用于 Native Client 平台的代码。PNaCl 为您提供了比 Emscripten 更好的性能和可移植性。
- LLJS：LLJS 是一个 JavaScript 实现的 LLVM 编译器，可以将 LLVM 的 IR 代码编译成 JavaScript 代码。
- Cheerp：Cheerp 是一个 C++ 到 JavaScript 编译器，专门针对高性能的要求进行了优化。

这些工具的选择取决于个人的具体需求，如果需要高性能，那么 PNaCl 和 Cheerp 可能是更好的选择；如果需要高度可移植性，那么 Emscripten 和 PNaCl 可能是更好的选择。

综合考虑，还是选择了目前最为主流的Emscripten。

## Emscripten配置

参考[Download and install](https://emscripten.org/docs/getting_started/downloads.html)的安装步骤安装即可， Emscripten使用emsdk来管理依赖包环境，程序更新，相当于一个隔离的虚拟环境。可以使用emsdk拉去 Emscripten最新代码，安装激活依赖库。

- 安装好环境以后，可以使用emsdk/emcmdprompt终端激活虚拟环境，并在终端内完成其他操作。
- emsdk list 可以查看安装依赖库详情
- emsdk install xxx 安装具体依赖库

Emscripten推荐使用Cmake[^1](notion://www.notion.so/jiajiewu/%5B*CMakeTutorial*%5D(%3Chttps://github.com/BrightXiaoHan/CMakeTutorial%3E))来组织C++工程结构，Emscripten使用`emcmake`和`emmake`命令生成makefile和最终构建产物，注意生成makefile不是必要的，使用：

```c
emcmake cmake . -B cmake-build-emscripten -G Ninja
cmake --build cmake-build-emscripten

```

则不需要生成makefile，如果想生成makefile，可以使用：

```c
emcmake cmake . -B cmake-build-emscripten -G "CodeBlocks - MinGW Makefiles"
cmake --build cmake-build-emscripten

```

注意MinGW和Ninja都可以通过emsdk install 安装[^2](notion://www.notion.so/jiajiewu/%5Bemcmake-with-emscripten%5D(%3Chttps://badlydrawnrod.github.io/posts/2020/05/19/emcmake-with-emscripten/%3E))。

## C++转webassembly的一个例子

在这里以一个[yaml-cpp](https://github.com/jbeder/yaml-cpp)调用作为例子,首先进入你的`demo工程根目录`，执行下面命令

```
mkdir thirdpart && cd thirdpart
git clone git@github.com:jbeder/yaml-cpp.git
cd yaml-cpp && mkdir build && cd build
cmake -G "CodeBlocks - MinGW Makefiles" ..
make -j

```

这会pull yaml-cpp并在build目录编译好静态库libyaml-cpp.a。回到`demo工程根目录`， 新增
`CmakeLists.txt`:

```c
cmake_minimum_required(VERSION 3.15) # 根据你的需求进行修改
project(main)

set(CMAKE_CXX_STANDARD 11) # 根据你的C++编译器支持情况进行修改
# 如果要编译纯C++工程，把该行命令注释掉
set(CMAKE_EXECUTABLE_SUFFIX ".html") # 编译生成.html

include_directories(thirdpart) # 使得我们能引用第三方库的头文件
add_subdirectory(thirdpart/yaml-cpp)

add_executable(main main.cpp)

# 设置Emscripten的编译链接参数，我们等等会讲到一些常用参数
# 如果要编译纯C++工程，把该行命令注释掉
set_target_properties(main PROPERTIES LINK_FLAGS "-s EXIT_RUNTIME=1")

target_link_libraries(main yaml-cpp) # 将第三方库与主程序进行链接

```

新增`main.cpp`:

```c
#include <iostream>
#include "yaml-cpp/yaml.h"

int main()
{
    YAML::Node lineup = YAML::Load("{1B: Prince Fielder, 2B: Rickie Weeks, LF: Ryan Braun}");
    for(YAML::const_iterator it=lineup.begin();it!=lineup.end();++it) {
    std::cout << "Playing at " << it->first.as<std::string>() << " is " << it->second.as<std::string>() << "\\n";
    }

    lineup["RF"] = "Corey Hart";
    lineup["C"] = "Jonathan Lucroy";
    return 0;
}

```

编译：

```
emcmake cmake . -B cmake-build-emscripten -G Ninja
cmake --build cmake-build-emscripten

```

注意这里用上了`emcmake`，如果只想编译纯C++工程，除了上述的CmakeLists需要改动以外，编译命令可以改为：

```
cmake . -B cmake-build-emscripten -G Ninja
cmake --build cmake-build-emscripten

```

编译的产物是：*.html, *.js, *.wasm， *.html可以通过静态服务器程序启动(NPM中的static-server, http-server,)。比如我可以通过http-server启动刚刚的yaml-cpp的demo:

![](https://s2.loli.net/2023/02/12/IjOclK8pTAhPNMt.png)

## 推荐阅读

[快速上手WebAssembly应用开发：Emscripten使用入门](https://cloud.tencent.com/developer/news/690454)

[为什么说 WebAssembly 是 Web 的未来？](https://juejin.cn/post/7056612950412361741#heading-8)

## 参考文献