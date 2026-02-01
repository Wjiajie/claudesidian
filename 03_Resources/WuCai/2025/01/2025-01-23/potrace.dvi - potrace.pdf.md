---
标题: potrace.dvi - potrace.pdf
url: https://app.immersivetranslate.com/pdf/
创建时间: 2025-01-23 11:31
更新时间: 2025-01-23 11:31
笔记ID: HMDA27K
收藏: false
划线数量: 0
标签: 
obsidianUIMode: preview
---

# potrace.dvi - potrace.pdf 

## collectedBy
[[wucai汇总]]

> [阅读原文](https://app.immersivetranslate.com/pdf/)
> [在五彩中查看](https://marker.dotalk.cn/#/?nx=HMDA27K&vs=1)


## 划线列表



---


## 全文剪藏 %% fold %%
Potrace: a polygon-based tracing algorithm  
Peter Selinger  
September 20, 2003  
1 Introduction  
Black-on-white images can be represented either as a bitmap or as a vector outline.  
A bitmap represents an image as a grid of black or white pixels. A vector outline  
describes an image via an algebraic description of its contours, typically in the form  
of Bezier curves. The advantage of representing an image as a vector outline is that  
it can be scaled to any size without loss of quality. Outline images are independent  
of the resolution of any particular output device. They are particularly popular in the  
description of fonts, which must be reproducible at many different sizes. Examples  
of outline font formats include PostScript Type 1 fonts, TrueType, and Metafont. On  
the other hand, most actual input and output devices, such as scanners, displays, and  
printers, ultimately produce or consume bitmaps. The process of converting a vector  
outline to a bitmap is called rendering. The converse process of turning bitmaps into  
outlines is called tracing.  
It is clear that no tracing algorithm can be perfect in an absolute sense, as there are  
in general many possible outlines that can give rise to the same bitmap. The process  
of tracing cannot be used to generate information that is not already present. On the  
other hand, out of the many possible outlines that could give rise to a given bitmap,  
clearly some are more plausible or aesthetically pleasing than others. For example, a  
common way of rendering bitmaps at a high resolution is to draw each black pixel as  
a precise square, which gives rise to “jaggies” or staircase patterns. Clearly, jaggies  
are neither pleasant to look at, nor are they particularly plausible interpretations of  
the original image. There is probably no absolute measure of what constitutes a good  
tracing algorithm, but it seems clear that some algorithms give better results than others.  
In this paper, we describe a tracing algorithm that is simple, efﬁcient, and tends to  
produce excellent results. The algorithm is called Potrace, which stands for polygon  
tracer. However, the output of the algorithm is not a polygon, but a smooth contour  
made from Bezier curves. The name of the algorithm derives from the fact that it uses  
polygons as an intermediate representation of images.  
The Potrace algorithm is designed to work well on high resolution images. Thus, a  
typical application is to produce a vector outline from a company or university logo that  
has been scanned at a high resolution. Another possible application is the conversion of  
bitmapped fonts to outline fonts, if the original bitmapped fonts are available at a high  
enough resolution. No tracing algorithm will work well on very small scales, such as  
1

Potrace: a polygon-based tracing algorithm  
Peter Selinger  
September 20, 2003  
1 Introduction  
Black-on-white images can be represented either as a bitmap or as a vector outline.  
A bitmap represents an image as a grid of black or white pixels. A vector outline  
describes an image via an algebraic description of its contours, typically in the form  
of Bezier curves. The advantage of representing an image as a vector outline is that  
it can be scaled to any size without loss of quality. Outline images are independent  
of the resolution of any particular output device. They are particularly popular in the  
description of fonts, which must be reproducible at many different sizes. Examples  
of outline font formats include PostScript Type 1 fonts, TrueType, and Metafont. On  
the other hand, most actual input and output devices, such as scanners, displays, and  
printers, ultimately produce or consume bitmaps. The process of converting a vector  
outline to a bitmap is called rendering. The converse process of turning bitmaps into  
outlines is called tracing.  
It is clear that no tracing algorithm can be perfect in an absolute sense, as there are  
in general many possible outlines that can give rise to the same bitmap. The process  
of tracing cannot be used to generate information that is not already present. On the  
other hand, out of the many possible outlines that could give rise to a given bitmap,  
clearly some are more plausible or aesthetically pleasing than others. For example, a  
common way of rendering bitmaps at a high resolution is to draw each black pixel as  
a precise square, which gives rise to “jaggies” or staircase patterns. Clearly, jaggies  
are neither pleasant to look at, nor are they particularly plausible interpretations of  
the original image. There is probably no absolute measure of what constitutes a good  
tracing algorithm, but it seems clear that some algorithms give better results than others.  
In this paper, we describe a tracing algorithm that is simple, efficient, and tends to  
produce excellent results. The algorithm is called Potrace, which stands for polygon  
tracer. However, the output of the algorithm is not a polygon, but a smooth contour  
made from Bezier curves. The name of the algorithm derives from the fact that it uses  
polygons as an intermediate representation of images.  
The Potrace algorithm is designed to work well on high resolution images. Thus, a  
typical application is to produce a vector outline from a company or university logo that  
has been scanned at a high resolution. Another possible application is the conversion of  
bitmapped fonts to outline fonts, if the original bitmapped fonts are available at a high  
enough resolution. No tracing algorithm will work well on very small scales, such as  
1

黑白色图像可以表示为位图或矢量轮廓。位图将图像表示为黑白像素的网格。矢量轮廓通过其轮廓的代数描述来描述图像，通常以贝塞尔曲线的形式。将图像表示为矢量轮廓的优势在于它可以无失真地缩放到任何大小。轮廓图像不受任何特定输出设备的分辨率影响。它们在字体描述中特别受欢迎，因为字体必须在许多不同的大小上可重现。轮廓字体格式的例子包括 PostScript Type 1 字体、TrueType 和 Metafont。另一方面，大多数实际输入和输出设备，如扫描仪、显示器和打印机，最终产生或消耗位图。将矢量轮廓转换为位图的过程称为渲染。将位图转换为轮廓的过程称为追踪。

显然，在绝对意义上，没有任何追踪算法是完美的，因为通常有众多可能的轮廓可以产生相同的位图。追踪过程不能用来生成原本不存在的信息。另一方面，在众多可能导致给定位图的轮廓中，显然有些比其他轮廓更合理或更美观。例如，在高质量渲染位图时，通常将每个黑色像素绘制成一个精确的方块，这会产生“锯齿”或阶梯状图案。显然，锯齿既不美观，也不是对原始图像的特别合理的解释。可能没有绝对的标准来衡量什么是好的追踪算法，但很明显，某些算法比其他算法给出更好的结果。

本文描述了一种简单、高效且往往能产生优秀结果的追踪算法。该算法名为 Potrace，意为多边形追踪器。然而，该算法的输出并非多边形，而是一条由贝塞尔曲线构成的平滑轮廓。该算法的名称来源于它使用多边形作为图像的中间表示形式。

Potrace 算法旨在在高分辨率图像上良好工作。因此，一个典型的应用是从扫描的高分辨率公司或大学标志中生成矢量轮廓。另一个可能的应用是将位图字体转换为轮廓字体，如果原始位图字体具有足够高的分辨率。没有任何追踪算法能在非常小的尺度上良好工作，例如

(a) (b) (c) (d)  
Figure 1: Corner detection. (a) the original bitmap; (b) too many corners; (c) too few  
corners; (d) good corner detection.  
bitmaps for a typical 10pt screen font rendered at 75dpi. However, it will do a decent  
job of tracing non-exact shapes, such as scanned handwriting or cartoon drawings, even  
at relatively moderate resolutions.  
Any good tracing algorithm has to perform several functions. Two of these func-  
tions are to ﬁnd the most plausible curve that approximates a given outline, and to  
detect corners. There is a tradeoff between these two goals. If too many corners are  
detected, the output will look like a polygon and will no longer be smooth. If too  
few corners are detected, the output will look smooth but too rounded. An example is  
shown in Figure 1.  
Another important function performed by a tracing algorithm is to decide which  
features of the bitmapped image are relevant, and which features are artifacts of the  
scanning or rendering process. Those features that can be explained as artifacts should  
be ﬁltered out completely, because if even a slight hint of these features remains, this  
can lead to visible imperfections in the output. Consider a straight line of positive,  
but very small, slope. When rendered as a bitmap, such a line will lead to a staircase  
pattern, where the individual steps of the stair could be far apart. No matter how far the  
steps are apart, the output should be a straight line, or else it will be visually annoying.  
This example also shows that tracing is not in general a local operation, i.e., it cannot  
be based on merely looking at ﬁxed-size neighborhoods of a point.  
Although the Potrace algorithm is very efﬁcient, it produces nicer output than other  
comparable algorithms. For instance, Figure 2 compares the output of Potrace 1.0,  
with its standard settings, to that of AutoTrace 0.31.1, another freely available tracing  
program (see http://autotrace.sourceforge.net/). In addition to its superior graphical  
output, Potrace also compares favorably to AutoTrace in terms of speed and ﬁle size:  
The bitmap in Figure 2 took Potrace 0.27 seconds to process, compared to 1.69 seconds  
for AutoTrace. Potrace produces an EPS ﬁle of 15790 bytes, compared to 39788 bytes  
for AutoTrace.  
2 Description of the Potrace algorithm  
The Potrace algorithm transforms a bitmap into a vector outline in several steps. In the  
ﬁrst step, the bitmap is decomposed into a number of paths, which form the boundaries  
2

(a) (b) (c) (d)  
Figure 1: Corner detection. (a) the original bitmap; (b) too many corners; (c) too few  
corners; (d) good corner detection.  
bitmaps for a typical 10pt screen font rendered at 75dpi. However, it will do a decent  
job of tracing non-exact shapes, such as scanned handwriting or cartoon drawings, even  
at relatively moderate resolutions.  
Any good tracing algorithm has to perform several functions. Two of these func-  
tions are to find the most plausible curve that approximates a given outline, and to  
detect corners. There is a tradeoff between these two goals. If too many corners are  
detected, the output will look like a polygon and will no longer be smooth. If too  
few corners are detected, the output will look smooth but too rounded. An example is  
shown in Figure 1.  
Another important function performed by a tracing algorithm is to decide which  
features of the bitmapped image are relevant, and which features are artifacts of the  
scanning or rendering process. Those features that can be explained as artifacts should  
be filtered out completely, because if even a slight hint of these features remains, this  
can lead to visible imperfections in the output. Consider a straight line of positive,  
but very small, slope. When rendered as a bitmap, such a line will lead to a staircase  
pattern, where the individual steps of the stair could be far apart. No matter how far the  
steps are apart, the output should be a straight line, or else it will be visually annoying.  
This example also shows that tracing is not in general a local operation, i.e., it cannot  
be based on merely looking at fixed-size neighborhoods of a point.  
Although the Potrace algorithm is very efficient, it produces nicer output than other  
comparable algorithms. For instance, Figure 2 compares the output of Potrace 1.0,  
with its standard settings, to that of AutoTrace 0.31.1, another freely available tracing  
program (see http://autotrace.sourceforge.net/). In addition to its superior graphical  
output, Potrace also compares favorably to AutoTrace in terms of speed and file size:  
The bitmap in Figure 2 took Potrace 0.27 seconds to process, compared to 1.69 seconds  
for AutoTrace. Potrace produces an EPS file of 15790 bytes, compared to 39788 bytes  
for AutoTrace.  
2 Description of the Potrace algorithm  
The Potrace algorithm transforms a bitmap into a vector outline in several steps. In the  
first step, the bitmap is decomposed into a number of paths, which form the boundaries  
2

另一种可能的应用是将位图字体转换为轮廓字体。图 1：角点检测。（a）原始位图；（b）角点过多；（c）角点过少；（d）良好的角点检测。

位图用于典型 10pt 屏幕字体，以 75dpi 渲染。然而，它也能很好地追踪非精确形状，如扫描的手写或卡通插图，即使在相对适中的分辨率下。

任何好的追踪算法都必须执行几个功能。其中两个功能是找到最合理的曲线来逼近给定的轮廓，并检测角点。这两个目标之间存在权衡。如果检测到太多的角点，输出将看起来像多边形，并且不再平滑。如果检测到的角点太少，输出将看起来平滑但过于圆润。图 1 中展示了示例。

另一个追踪算法执行的重要功能是决定位图图像的哪些特征是相关的，哪些特征是扫描或渲染过程的伪影。那些可以解释为伪影的特征应该被完全过滤掉，因为即使这些特征的轻微痕迹仍然存在，这也可能导致输出可见的缺陷。考虑一条正斜率但非常小的直线。当作为位图渲染时，这样的线会导致阶梯图案，其中阶梯的各个步骤可能相隔很远。无论步骤相隔多远，输出都应该是一条直线，否则将视觉上令人烦恼。这个例子还表明，追踪通常不是一个局部操作，即它不能仅仅基于观察一个点的固定大小的邻域。

尽管 Potrace 算法非常高效，它产生的输出比其他类似算法更美观。例如，图 2 比较了 Potrace 1.0（使用其标准设置）与 AutoTrace 0.31.1 的输出，后者也是一个免费的可用追踪程序（见 http://autotrace.sourceforge.net/）。除了其优越的图形输出外，Potrace 在速度和文件大小方面也优于 AutoTrace：图 2 中的位图用 Potrace 0.27 秒处理完成，而 AutoTrace 需要 1.69 秒。Potrace 生成的 EPS 文件为 15790 字节，而 AutoTrace 为 39788 字节。

The Potrace 算法通过几个步骤将位图转换为矢量轮廓。在第一步中，位图被分解成多个路径，这些路径形成边界

Figure 2: A detail from the seal of Stanford University; the original scanned image,  
left; the output of AutoTrace, center; the output of Potrace, right.  
between black and white areas. In the second step, each path is approximated by an op-  
timal polygon. In the third step, each polygon is transformed into a smooth outline. In  
an optional fourth step, the resulting curve is optimized by joining consecutive Bezier  
curve segments together where this is possible. Finally, the output is generated in the  
required format. The following subsections describe each of these steps in more detail.  
2.1 Paths  
2.1.1 Path decomposition  
We imagine our bitmapped image to be placed on a coordinate system such that the  
corners (and not the centers) of each pixel have integer coordinates. Let us further  
assume that the background color of the image is white, and the foreground color is  
black. By convention, the parts of the coordinate plane that lie outside the bitmap  
boundaries are assumed to be ﬁlled with white pixels.  
We now construct a directed graph from our bitmap as follows. Let p be a point of  
integer coordinates; such a point is adjacent to four pixels. The point is called a vertex  
if the four pixels are not all of the same color. If v and w are vertices, we say that  
there is an edge from v to w if the Euclidean distance between v and w is 1, and if the  
straight line segment from v to w separates a black pixel from a white pixel, so that the  
black pixel is to its left and the white pixel is to its right when traveling in the direction  
from v to w. Let us call the resulting directed graph G with the vertices and edges just  
described.  
A path is a sequence of vertices {v0, . . . , vn} such that there is an edge from vi to  
vi+1, for all i \= 0, . . . , n − 1, and such that all these edges are distinct. A path is called  
closed if further, vn \= v0. The length of a path is the number of edges in it, i.e., n. The  
goal of path decomposition is to decompose the graph G into closed paths, i.e., to ﬁnd  
a set of closed paths in which each edge of G occurs exactly once.  
Potrace uses the following straightforward method to decompose a bitmap into  
paths. Start by picking a pair of adjacent pixels of different color. This can be accom-  
plished, for instance, by picking the leftmost black pixel in some row. The two chosen  
3

Figure 2: A detail from the seal of Stanford University; the original scanned image,  
left; the output of AutoTrace, center; the output of Potrace, right.  
between black and white areas. In the second step, each path is approximated by an op-  
timal polygon. In the third step, each polygon is transformed into a smooth outline. In  
an optional fourth step, the resulting curve is optimized by joining consecutive Bezier  
curve segments together where this is possible. Finally, the output is generated in the  
required format. The following subsections describe each of these steps in more detail.  
2.1 Paths  
2.1.1 Path decomposition  
We imagine our bitmapped image to be placed on a coordinate system such that the  
corners (and not the centers) of each pixel have integer coordinates. Let us further  
assume that the background color of the image is white, and the foreground color is  
black. By convention, the parts of the coordinate plane that lie outside the bitmap  
boundaries are assumed to be filled with white pixels.  
We now construct a directed graph from our bitmap as follows. Let p be a point of  
integer coordinates; such a point is adjacent to four pixels. The point is called a vertex  
if the four pixels are not all of the same color. If v and w are vertices, we say that  
there is an edge from v to w if the Euclidean distance between v and w is 1, and if the  
straight line segment from v to w separates a black pixel from a white pixel, so that the  
black pixel is to its left and the white pixel is to its right when traveling in the direction  
from v to w. Let us call the resulting directed graph G with the vertices and edges just  
described.  
A path is a sequence of vertices {v0, . . . , vn} such that there is an edge from vi to  
vi+1, for all i \= 0, . . . , n − 1, and such that all these edges are distinct. A path is called  
closed if further, vn \= v0. The length of a path is the number of edges in it, i.e., n. The  
goal of path decomposition is to decompose the graph G into closed paths, i.e., to find  
a set of closed paths in which each edge of G occurs exactly once.  
Potrace uses the following straightforward method to decompose a bitmap into  
paths. Start by picking a pair of adjacent pixels of different color. This can be accom-  
plished, for instance, by picking the leftmost black pixel in some row. The two chosen  
3

位图被分解成多个路径图 2：斯坦福大学印章的细节；原始扫描图像，左；AutoTrace 输出，中；Potrace 输出，右。

在黑白区域之间。在第二步中，每条路径被近似为一个最优多边形。在第三步中，每个多边形被转换为一个平滑轮廓。在可选的第四步中，通过将连续的贝塞尔曲线段连接起来，对得到的曲线进行优化。最后，以所需的格式生成输出。以下小节将更详细地描述这些步骤。

我们想象我们的位图图像被放置在一个坐标系上，使得每个像素的角（而不是中心）具有整数坐标。让我们进一步假设图像的背景颜色是白色，前景颜色是黑色。按照惯例，坐标平面中位于位图边界之外的部分被认为是填充了白色像素。

我们现在根据位图构建一个有向图，如下所示。设 p 为一个整数坐标点；这样的点与四个像素相邻。如果四个像素不是同一种颜色，则该点称为顶点。如果 v 和 w 是顶点，我们说从 v 到 w 存在一条边，如果 v 和 w 之间的欧几里得距离为 1，并且从 v 到 w 的直线段将一个黑色像素和一个白色像素分开，使得当沿从 v 到 w 的方向移动时，黑色像素在其左侧，白色像素在其右侧。让我们称由此产生的具有上述顶点和边的结果有向图为 G。

路径是一系列顶点{v, . . . , v}的序列，其中对于所有 i = 0, . . . , n − 1，都存在一条从 v 到 v 的边，并且所有这些边都是不同的。如果进一步有 v= v，则称路径为封闭路径。路径的长度是其中边的数量，即 n。路径分解的目标是将图 G 分解为封闭路径，即找到一组封闭路径，其中 G 的每条边恰好出现一次。

Potrace 使用以下简单方法将位图分解成路径。首先选择一对相邻的不同颜色的像素。例如，可以通过选择某一行中最左边的黑色像素来实现。所选的两个像素

?  
Figure 3: The path extension algorithm  
pixels meet at an edge; we orient this edge so that the black pixel is to its left and the  
white pixel is to its right. This edge deﬁnes a path of length one. We then continue to  
extend this path in such a way that each new edge has a black pixel on its left and a  
white pixel on its right, relative to the direction of the path. In other words, we move  
along the edges between pixels, and each time we hit a corner, we either go straight or  
turn left or right, depending on the colors of the surrounding pixels as shown in Fig-  
ure 3\. We continue until we return to the vertex where we started, at which point we  
have deﬁned a closed path.  
Every time we have found a closed path, we remove it from the graph by inverting  
all the pixel colors in its interior. This deﬁnes a new bitmap, to which we apply the  
algorithm recursively until there are no more black pixels left. The result is a set of  
closed paths to be passed to the next phase of the Potrace algorithm. The later phases  
of the Potrace algorithm look at each path independently.  
2.1.2 Turn policies  
In the situation in Figure 3(d), we have a choice of whether to take a left turn or a  
right turn. This choice has no effect on the success or failure of the path decomposition  
algorithm, as we will end up with a set of closed paths either way. However, the choice  
does have an effect on the shape of the closed paths chosen.  
In the Potrace algorithm, the choice of whether to turn left or right is governed  
by a turn policy, which can be deﬁned via the \--turnpolicy command line option.  
Possible turn policies are: left, which always takes a left turn, right, which always takes  
a right turn, black, which prefers to connect black components, white, which prefers  
to connect white components, minority, which prefers to connect the color (black or  
white) that occurs least frequently within a given neighborhood of the current position,  
majority, which prefers to connect the color that occurs most frequently, and random,  
which makes a (more or less) random choice. The default turn policy is minority.  
The reason that black and white are distinct turn policies from right and left is  
that some pixel colors may get inverted during the course of the path decomposition  
algorithm. The black and white policies look at the original pixel colors to determine  
the direction of the turn.  
4

?  
Figure 3: The path extension algorithm  
pixels meet at an edge; we orient this edge so that the black pixel is to its left and the  
white pixel is to its right. This edge defines a path of length one. We then continue to  
extend this path in such a way that each new edge has a black pixel on its left and a  
white pixel on its right, relative to the direction of the path. In other words, we move  
along the edges between pixels, and each time we hit a corner, we either go straight or  
turn left or right, depending on the colors of the surrounding pixels as shown in Fig-  
ure 3\. We continue until we return to the vertex where we started, at which point we  
have defined a closed path.  
Every time we have found a closed path, we remove it from the graph by inverting  
all the pixel colors in its interior. This defines a new bitmap, to which we apply the  
algorithm recursively until there are no more black pixels left. The result is a set of  
closed paths to be passed to the next phase of the Potrace algorithm. The later phases  
of the Potrace algorithm look at each path independently.  
2.1.2 Turn policies  
In the situation in Figure 3(d), we have a choice of whether to take a left turn or a  
right turn. This choice has no effect on the success or failure of the path decomposition  
algorithm, as we will end up with a set of closed paths either way. However, the choice  
does have an effect on the shape of the closed paths chosen.  
In the Potrace algorithm, the choice of whether to turn left or right is governed  
by a turn policy, which can be defined via the \--turnpolicy command line option.  
Possible turn policies are: left, which always takes a left turn, right, which always takes  
a right turn, black, which prefers to connect black components, white, which prefers  
to connect white components, minority, which prefers to connect the color (black or  
white) that occurs least frequently within a given neighborhood of the current position,  
majority, which prefers to connect the color that occurs most frequently, and random,  
which makes a (more or less) random choice. The default turn policy is minority.  
The reason that black and white are distinct turn policies from right and left is  
that some pixel colors may get inverted during the course of the path decomposition  
algorithm. The black and white policies look at the original pixel colors to determine  
the direction of the turn.  
4

这可以通过像素在边缘相遇来实现；我们将这个边缘定位，使得黑色像素位于其左侧，白色像素位于其右侧。这个边缘定义了一个长度为 1 的路径。然后我们继续以这种方式扩展这条路径，使得每个新边缘的左侧都有一个黑色像素，右侧都有一个白色像素，相对于路径的方向。换句话说，我们沿着像素之间的边缘移动，每次遇到角落时，我们根据周围像素的颜色（如图 3 所示）要么直行，要么左转或右转。我们继续这样做，直到回到起始顶点，此时我们已定义了一个闭合路径。

每次我们找到一个闭合路径，我们就通过反转其内部所有像素颜色将其从图中删除。这定义了一个新的位图，我们对它递归地应用算法，直到没有更多黑色像素为止。结果是传递给 Potrace 算法下一阶段的闭合路径集。Potrace 算法的后续阶段独立地查看每条路径。

在图 3(d)所示的情况下，我们有一个选择：是左转还是右转。这个选择对路径分解算法的成功或失败没有影响，因为我们无论如何都会得到一组闭合路径。然而，这个选择确实会影响所选择闭合路径的形状。

在 Potrace 算法中，是否左转或右转的选择由转向策略控制，该策略可以通过--turnpolicy 命令行选项定义。可能的转向策略有：左转，总是左转；右转，总是右转；黑色，优先连接黑色组件；白色，优先连接白色组件；少数，优先连接在当前位置给定邻域内出现频率最低的颜色（黑色或白色）；多数，优先连接出现频率最高的颜色；随机，做出（或多或少）随机选择。默认转向策略是少数。

黑色和白色是不同于左右转弯策略的原因在于，在路径分解算法的过程中，某些像素颜色可能会发生反转。黑白策略通过查看原始像素颜色来确定转弯的方向。

(a) (b)  
(c) (d)  
(e)  
Figure 4: Examples of straight and non-straight paths. The vertices of the path are  
shown as dots, and their 1/2-neighborhoods are shown as squares. (a), (b), and (d) are  
straight, whereas (c) and (e) are not.  
2.1.3 Despeckling  
Despeckling can be performed by dropping all paths whose interior consists of fewer  
than t pixels, for a given parameter t. The parameter t can be set with the \--turdsize  
command line option. The area of the interior of a path can be efﬁciently computed by  
the formula  
Area \=  
∫  
y dx \=  
∫  
yx′ dt.  
2.2 Polygons  
The second phase of the Potrace algorithm has as its input a closed path as deﬁned in  
Section 2.1\. The output is an optimal polygon that approximates this path. We start by  
making precise what is meant by “optimal” and by “approximates”.  
2.2.1 Straight paths  
Given two points z0 \= (x0, y0) and z1 \= (x1, y1) in the coordinate plane, not necessar-  
ily of integer coordinates, we deﬁne their max-distance to be d(z0, z1) = max{|x1 −  
x0|, |y1 − y0|}. Thus, the set of points of max-distance at most 1/2 from the point  
(1/2, 1/2) is just the pixel centered at (1/2, 1/2).  
For any two points a, b in the coordinate plane, let ab denote the straight line seg-  
ment connecting a and b. Here a and b are not required to have integer coordinates.  
Given a non-closed path p \= {v0, . . . , vn} as in Section 2.1, we say that a line  
segment ab approximates the path if d(v0, a) 6 1/2, d(vn, b) 6 1/2, and for each  
i \= 1, . . . , n − 1, there exists some point ci on ab such that d(vi, ci) 6 1/2.  
For a path p \= {v0, . . . , vn}, we say the direction at index i is vi+1 − vi, where  
i \= 0, . . . , n − 1\. There are four possible directions: (0, 1), (1, 0), (0, −1), and (−1, 0).  
A path is called straight if it is approximated by some line segment, and not all four  
directions occur in p.  
Figure 4 shows some examples of straight and non-straight paths. Note that in  
this ﬁgure, the dots represent vertices in the path, which lie at the corners, not at the  
5

(a) (b)  
(c) (d)  
(e)  
Figure 4: Examples of straight and non-straight paths. The vertices of the path are  
shown as dots, and their 1/2-neighborhoods are shown as squares. (a), (b), and (d) are  
straight, whereas (c) and (e) are not.  
2.1.3 Despeckling  
Despeckling can be performed by dropping all paths whose interior consists of fewer  
than t pixels, for a given parameter t. The parameter t can be set with the \--turdsize  
command line option. The area of the interior of a path can be efficiently computed by  
the formula  
Area \=  
∫  
y dx \=  
∫  
yx′ dt.  
2.2 Polygons  
The second phase of the Potrace algorithm has as its input a closed path as defined in  
Section 2.1\. The output is an optimal polygon that approximates this path. We start by  
making precise what is meant by “optimal” and by “approximates”.  
2.2.1 Straight paths  
Given two points z0 \= (x0, y0) and z1 \= (x1, y1) in the coordinate plane, not necessar-  
ily of integer coordinates, we define their max-distance to be d(z0, z1) = max{|x1 −  
x0|, |y1 − y0|}. Thus, the set of points of max-distance at most 1/2 from the point  
(1/2, 1/2) is just the pixel centered at (1/2, 1/2).  
For any two points a, b in the coordinate plane, let ab denote the straight line seg-  
ment connecting a and b. Here a and b are not required to have integer coordinates.  
Given a non-closed path p \= {v0, . . . , vn} as in Section 2.1, we say that a line  
segment ab approximates the path if d(v0, a) 6 1/2, d(vn, b) 6 1/2, and for each  
i \= 1, . . . , n − 1, there exists some point ci on ab such that d(vi, ci) 6 1/2.  
For a path p \= {v0, . . . , vn}, we say the direction at index i is vi+1 − vi, where  
i \= 0, . . . , n − 1\. There are four possible directions: (0, 1), (1, 0), (0, −1), and (−1, 0).  
A path is called straight if it is approximated by some line segment, and not all four  
directions occur in p.  
Figure 4 shows some examples of straight and non-straight paths. Note that in  
this figure, the dots represent vertices in the path, which lie at the corners, not at the  
5

图 4：直线和非直线路径的示例。路径的顶点以点表示，它们的 1/2 邻域以方框表示。(a)、(b)和(d)是直线，而(c)和(e)不是。

去噪可以通过删除所有内部像素少于 t 个的路径来实现，其中 t 是一个给定的参数。参数 t 可以通过--turdsize 命令行选项来设置。路径内部的面积可以通过公式高效计算。

Potrace 算法的第二阶段以第 2.1 节定义的封闭路径作为输入。输出是一个逼近此路径的最优多边形。我们首先明确“最优”和“逼近”的含义。

给定两个点 z= (x, y) 和 z= (x, y) 在坐标平面中，不一定有整数坐标，我们定义它们的最大距离为 d(z, z) = max{|x− x|, |y− y|}。因此，距离点 (1/2, 1/2) 最大距离不超过 1/2 的点集恰好是以 (1/2, 1/2) 为中心的像素。

对于坐标平面上的任意两点 a，b，令 ab 表示连接 a 和 b 的直线段。这里 a 和 b 不需要有整数坐标。

给定一个非封闭路径 p = {v, . . . , v}，如第 2.1 节所述，我们称线段 ab 近似路径，如果 d(v, a) ≤ 1/2，d(v, b) ≤ 1/2，并且对于每个 i = 1, . . . , n − 1，存在某个点 c 在 ab 上，使得 d(v, c) ≤ 1/2。

对于路径 p = {v, . . . , v}，我们称索引 i 的方向为 v−v，其中 i = 0, . . . , n − 1。有四种可能的方向：(0, 1)，(1, 0)，(0, −1) 和 (−1, 0)。如果一个路径被称为直线，那么它被某个线段近似，且 p 中不包含所有四个方向。

图 4 展示了直线和非直线路径的一些示例。注意，在此图中，点代表路径的顶点，它们位于角落，而不是在
