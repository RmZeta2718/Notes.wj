---
aliases:
  - "Exploring Context Window of Large Language Models via Decomposed Positional Vectors"
  - "Exploring Context Window of Large Language Models via Decomposed Positional Vectors, 2024"
---

# Exploring Context Window of Large Language Models via Decomposed Positional Vectors

- **Journal**: arXiv:2405.18009 #NeurIPS/24 Spotlight
- **Author**: Zican Dong, Junyi Li, Xin Men, Wayne Xin Zhao, Bingbing Wang, Zhen Tian, Weipeng Chen, Ji-Rong Wen
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2405.18009
- [**Zotero**](zotero://select/items/@2024ExploringContextWindowDong)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=2336242234137600768&noteId=2532256692708945152)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### 总体流程

方法假设：

- 隐层向量=语义向量+位置向量
- 语义向量在整个数据集上的均值为 0（各个方向的语义均匀分布）

于是，在整个数据集上对隐层向量取平均，就是位置向量（对每个位置分别平均，拿到每个位置 t 对应的向量）

这个方法来自 [[@2024UncoveringHiddenGeometrySong|Uncovering hidden geometry in Transformers via disentangling position and context, 2024]]

![fig10](https://arxiv.org/html/2405.18009v1/x8.png)

- 解释初始 token：作者从数学上构造/解释了初始 token 的特殊之处（之前一篇 NoPE 构造性证明的改进版，即融入 attention sink 现象）
- 基于实验数据，解释我们的 attention scale：对位置向量做内插

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

外推方面：单独对位置向量缩放就能控制外推长度。比我们的 attention scale 略差（他们没加 head scale 的 baseline），还有（很大的）提升空间。

一些工程细节：

- 内插是指 L 个位置向量（d_model 维）的线性插值，L 个变成 L'个。一行实现：`torch.nn.functional.interpolate(..., mode='linear')`
- 初始 4 个 token 不插值，因为这几个点是离散的
- 只修改第 4 层的位置向量，不在所有层操作是因为计算量太大，第 4 层是调出来的（第 3 和第 5 层效果都差很多，4 是一个尖锐的局部最优点）

作者还把我们的 attention scale 应用到在 window attention 的 NoPE 上，相当于是 2k→8k 变成了 512 窗口 →2k 窗口，都在 8k 上测试，纸面数据（PPL）不错，比直接 8k 好。

## 相关研究

%% 如何归类。值得关注的研究员 %%

Zican Dong
