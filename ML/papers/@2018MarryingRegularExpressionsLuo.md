---
aliases: ["Marrying Up Regular Expressions with Neural Networks: A Case Study for Spoken Language Understanding", "Marrying Up Regular Expressions with Neural Networks: A Case Study for Spoken Language Understanding, 2018"]
---
# Marrying Up Regular Expressions with Neural Networks: A Case Study for Spoken Language Understanding

- **Journal**: Proceedings of the 56th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers)
- **Author**: Bingfeng Luo, Yansong Feng, Zheng Wang, Songfang Huang, Rui Yan, Dongyan Zhao
- **Year**: 2018
- **URL**:
- [**Zotero**](zotero://select/items/@2018MarryingRegularExpressionsLuo)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4498408243138813953&noteId=749761732328722432)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

将神经网络（NN）与正则表达式（RE）结合起来，用于提升监督学习性能，特别是 few-shot 情况下的性能。

### 动机

正则表达式：
- 优点：简洁、可解释、可调的、不需要太多训练数据
- 缺点：
    - 泛化性能差：同义词需要显示指出
- 结合 NN 以获得泛化性能
- RE 不仅仅是 pattern matching，而是编码了开发者的知识，包括：
    - informative words (clue words)

## 论文的总体贡献

- 输入层：RE 作为输入特征
- 网络模块层面：RE 指导 NN 的注意力机制
- 输出层：通过可学习的方式结合 RE 与 NN 的输出

应用：
- Intent Detection（句子分类）：RE 指导注意力机制
- Slot Filling（序列标注）：REtags 作为特征

## 论文提供的关键元素、关键设计

论文定义的 RE 复杂度：group 越多越复杂

### RE

Perl 格式

每个 RE 是 pattern 到 REtags 的映射，即每个 RE 对应一个 label（不论是句子类别还是序列标注中的类别）

RE 的使用方式仍然是经典的：直接 match。本文在 match 的基础上，将这些已经匹配的 RE（的 REtags）融入到 NN 中。

- 句子分类任务：REtags 就是句子的 label，例如 flight
- 序列标注任务：
    - 可以直接是 label，注意力中用这种 tag，如 fromloc.city, toloc.city, stoploc.city
    - 也可以是概括性的，表示共性的信息，输入输出中用这种 tag，如 city，优点：
        - RE 在没有完全匹配的时候也能有用
        - 人工标注 REtags 更简单

### 基础模型

本文采用 BLSTM 作为基础模型。输入长度为 $n$ 的序列 $[x_1,\cdots,x_n]$ ，每个 token $x_i$ 对应输出词表示 $h_i$

![论文 Fig2](https://pdf.cdn.readpaper.com/parsed/fetch_target/9dd527af347384667d5d1d622598dce0_3_Figure_2.png)

#### 句子分类任务

对 $h_i$ 做加权和（注意力），本文中的注意力定义为：
$$
\mathbf{s}=\sum_{i} \alpha_{i} \mathbf{h}_{i}, \quad \alpha_{i}=\frac{\exp \left(\mathbf{h}_{i}^{\top} \mathbf{W} \mathbf{c}\right)}{\sum_{i} \exp \left(\mathbf{h}_{i}^{\top} \mathbf{W} \mathbf{c}\right)}
$$
其中，$c$ 是随机初始化的可学习的向量（用以选择哪些单词是富含信息的），$W$ 是权重矩阵。

再过一层 Softmax 分类器（MLP+Softmax）。$p_k$ 表示类别 $k$ 的概率。
$$
p_{k}=\frac{\exp \left(\operatorname{logit}_{k}\right)}{\sum_{k} \exp \left(\operatorname{logit}_{k}\right)}, \quad \quad \operatorname{logit}_{k}=\mathbf{w}_{k} \mathbf{s}_{k}+b_{k}
$$

> 这个公式出现在很靠后（3.3 节），导致我前面一直很迷糊。。（忽略 $s_k$ 的下标，后文对每个类别都有注意力）

#### 序列标注任务

对每个 $h_i$ 过 Softmax 分类器。

> 图中（Fig2b）的注意力层仅在 RE 应用于注意力的方法中使用

### RE 应用于输入

#### 句子分类任务

取成功匹配的 RE 的 REtag 的 embedding。同一句可能匹配多个 RE，取平均值，称为 aggregated embedding。

aggregated embedding 两种应用方案：
- 合并在每个输入单词的 embedding 后面
    - 缺点：aggregated embedding 重复了很多次，导致模型过度依赖与 RE （few-shot 情况下性能接近只用 RE），因此不采用
- 作为 Softmax 分类器的输入

#### 序列标注任务

RE 的输出结果是 word-level tag，所以直接取 tag embedding 的平均（因为一句可能匹配多个 RE），记作 $f_i$ ，拼在单词的 embedding $w_i$ 后面。

### RE 应用于注意力

#### 句子分类任务

由于每个类别的核心词（clue words）不同，每个类别设计了独立的注意力，作为正面的注意力（positive attentions）。
$$
\mathbf{s}_{k}=\sum_{i} \alpha_{k i} \mathbf{h}_{i}, \quad \alpha_{k i}=\frac{\exp \left(\mathbf{h}_{i}^{\top} \mathbf{W}_{a} \mathbf{c}_{k}\right)}{\sum_{i} \exp \left(\mathbf{h}_{i}^{\top} \mathbf{W}_{a} \mathbf{c}_{k}\right)}
$$
输出分类概率：
$$
p_{k}=\frac{\exp \left(\operatorname{logit}_{k}\right)}{\sum_{k} \exp \left(\operatorname{logit}_{k}\right)}, \quad \quad \operatorname{logit}_{k}=\mathbf{w}_{k} \mathbf{s}_{k}+b_{k}
$$
RE 还能指出某个句子不属于某些类别（RE 设计目标为类别 $k$ ，则该类为正，其他均为负），这种作为负面的注意力（negative attentions），与正面的相加。
$$
\operatorname{logit}_{k}=\operatorname{logit}_{p k}-\operatorname{logit}_{n k}
$$
把 RE 是否匹配融入损失中，选出所有 clue words，求对数注意力之和：
$$
\operatorname{loss}_{a t t}=\sum_{k} \sum_{i} t_{k i} \log \left(\alpha_{k i}\right)
$$
其中，$t_{ki}$ 表达是否匹配（是否是类别 $k$ 的 clue words），细节略。实际上对于正负注意力有各自的 loss，通过超参数加权。

#### 序列标注任务

不能对每个 RE 都计算正负注意力，因为计算量太大（对每个词都要输出注意力），共有 $2\times L\times n^2$ 个注意力需要计算， $L$ 是类别个数， $n$ 是序列长度， $2$ 来自 BIO（B 和 I；O 只有一个）

于是转而共享正负注意力（而不是每个类别有自己的注意力）
$$
\mathbf{s}_{p i}=\sum_{j} \alpha_{p i j} \mathbf{h}_{j}, \quad \alpha_{p i j}=\frac{\exp \left(\mathbf{h}_{j}^{\top} \mathbf{W}_{s p} \mathbf{h}_{i}\right)}{\sum_{j} \exp \left(\mathbf{h}_{j}^{\top} \mathbf{W}_{s p} \mathbf{h}_{i}\right)}
$$
上式为正面注意力，对于负面注意力有相同的公式。

> 这个形式和 [[@2017AttentionAllYouVaswani|Transformer]] 的注意力很接近？

最后过 Softmax 分类器，具体形式为：
$$
\mathbf{p}_{i}=\text{softmax}((\mathbf{W}_{p}[\mathbf{s}_{p i} ; \mathbf{h}_{i}]+\mathbf{b}_{p})-(\mathbf{W}_{n}[\mathbf{s}_{n i} ; \mathbf{h}_{i}]+\mathbf{b}_{n}))
$$
这里把 $h_i$ 也拼在后面，作者认为有必要加强单词自身在结果中的作用（真的有必要吗，前面也没加啊）。

### RE 应用于输出

在原有 NN 的 $\mathrm{logit_k'}$ 的基础上加上 RE 相关的权重。$z_k$ 表示有至少匹配上一个对应 label $k$ 的 RE 。$w_k$ 是可学习的参数，表示 RE 对应于 label $k$ 的置信度。
$$
\text{logit}_{k}=\text{logit}_{k}^{\prime}+w_{k} z_{k}
$$

- 没有给每个 RE 都加上参数（可学习的权重），因为通常只有很少几句句子能匹配某个 RE （why？）
- 在 logit 而不是最终概率上加权重，因为 logit 是无约束的。

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

结论：
- few-shot 场景下是否有用
    - 句子分类任务：
        - 正面注意力比负面注意力更好（当然，一起来更好）
        - 输出部分加 RE 比输入加 RE 要好
        - 样本数量超过 10 之后，RE+NN 比纯 RE 更好
    - 序列标注任务：
        - 输入加 RE 下效果最好，但低于 SOTA
- 数据充足的场景下是否有用
    - 句子分类任务：
        - 注意力 RE 有提升
        - 输入输出 RE 是负优化
- 这么多方法选哪个
- 简单的 RE（包含较少的 group，如 1-2 个）就有比较好的结果。更复杂的 RE 也能进一步提升。

### 数据集

ATIS dataset：
- 18 句子分类类别，127 序列标注类别
- 4978 训练，893 验证

预训练的词表示：100d GloVe word vectors

预处理：
- tokenization: Miami's 拆分为 Miami/'s，从而更好地应用与训练的词表示。
- RE 人工构造。
    - 对照 20 个样本构造。当能够较好地匹配（resonable precision）这 20 个样本就认为构造完成。
    - city 这类正则列表是从整个数据集中提取的

few-shot：
- full few-shot learning setting：每个类别 5、10、20 个训练样本
- partial few-shot learning setting（实际上是迁移学习？）：对最常见的 3 个类别给 300 个样本，其余类别 few-shot

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

从论文中的例子来看，似乎没有构造比较复杂的 RE（如包含循环结构），论文也说简单的 RE 就够了。所以本文没有充分挖掘 RE。

## 相关研究

%% 如何归类。值得关注的研究员 %%

前置工作：
- Attention-based recurrent neural network models for joint intent detection and slot filling, 2016
## [[pq]]

- As a technique based on human-crafted rules, it is concise, interpretable, tunable, and does not rely on much training data to generate.
