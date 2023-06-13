---
aliases: ["Long Range Arena: A Benchmark for Efficient Transformers", "Long Range Arena: A Benchmark for Efficient Transformers, 2020", "LRA"]
---
# Long Range Arena: A Benchmark for Efficient Transformers

- **Journal**: arxiv:2011.04006
- **Author**: Yi Tay, Mostafa Dehghani, Samira Abnar, Yikang Shen, Dara Bahri, Philip Pham, Jinfeng Rao, Liu Yang, Sebastian Ruder, Donald Metzler
- **Year**: 2020
- **URL**: http://arxiv.org/abs/2011.04006
- [**Zotero**](zotero://select/items/@2020LongRangeArenaTay)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4556753046223200257&noteId=1820115422647710720)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

为了应对 attention 平方增长的问题，大量的高效 transformer 模型（xformers）涌现。但是在评估 xformer 模型方面没有达成一致，导致模型之间没有办法公平对比。

## 论文的总体贡献

- Long-Range Arena (LRA)，包含人造的探测任务和现实世界的任务。
- 为 10 个高效 transformer 模型完成测试和比较：Sparse Transformers，Reformer，Linformer，[[@2020LongformerLongDocumentTransformerBeltagy|Longformer]]，Sinkhorn Transformers，[[@2022RethinkingAttentionPerformersChoromanski|Performer]]，Synthesizers，Linear Transformers，BigBird

## 论文提供的关键元素、关键设计

关注点：
- 模型在 long-context 场景下推理的能力
- 为了探测模型能力，选择有特定内部结构的数据集和任务
- 模型的计算效率和内存效率

benchmark 设计标准：
- Generality：由于不是所有模型都能自回归生成，所以 benchmark 只测试 encoding 的能力（实际上是局限性）
- Simplicity
- Challenging：有提升空间
- Long inputs：输入序列长度需要足够长
- Probing diverse aspects：例如探测模型建模关系的能力，建模分层/空间结构的能力，泛化能力
- Non-resource intensive and accessible：不需要大量计算资源

### Long ListOps

关注长序列中建模分层结构数据的能力。

数据集由分层的数据组成，包含 MAX, MEAN,MEDIAN and SUM_MOD 操作符。每个数都是个位数字，结果也在 0\~9 范围内，即输出是 10 分类。

```text
INPUT: [MAX 4 3 [MIN 2 3 ] 1 0 [MEDIAN 1 5 8 9, 2]] OUTPUT: 5
```

实验中序列长度至多 2K

### Byte-level Text Classification

IMDb reviews，总是截断或填充至序列长度 4K。二分类任务。

### Byte-level Document Retrieval

任务主要是建模两篇文档之间的相似度。通过一个两阶段的方式来实现：通过模型得到文档的压缩表示，然后拼接在一起进入一个线性分类器。作者有意地避免使用 cross attention

数据集：ACL Anthology Network （AAN），识别两篇 paper 之间是否有引用关系。

每篇文章序列长度 4K，一对共 8K。二分类任务。

### Image Classification on Sequences of Pixels

图像分类任务，关注建模空间信息的能力。输入是 2D 序列直接拉成 1D

CIFAR-10，8bit 灰度图（词表大小=256），分类任务。

### PathFinder (Long-Range Spatial Dependency)

给定图片上两个圆点和若干条曲线，需要模型判断，这两个圆点是否被某一条曲线连接。

图像大小 $32\times 32$ （序列长度 1024）

### PathFinder-X (Long-Range Spatial Dependencies with Extreme Lengthts)

更长的序列。图像大小 $128\times 128$ （序列长度 16K）

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

作者认为 Byte-level 对长序列的要求更高，更有挑战性。但是难道不是因为这种建模方式不够好吗（相比 word level 或 sentence piece）？换成另一种 tokenize 的方式一样可以做长序列。

## 相关研究

%% 如何归类。值得关注的研究员 %%

似乎和 ViT 系列模型是同期的工作，所以和图像相关的测试有些过时。

## [[pq]]

- desiderata
