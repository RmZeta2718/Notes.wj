---
aliases: ["Attention is All you Need", "Attention is All you Need, 2017", "Transformer"]
---
# Attention is All you Need

- **Journal**: Advances in Neural Information Processing Systems
- **Author**: Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N Gomez, Łukasz Kaiser, Illia Polosukhin
- **Year**: 2017
- **URL**: https://proceedings.neurips.cc/paper/2017/hash/3f5ee243547dee91fbd053c1c4a845aa-Abstract.html
- [**Zotero**](zotero://select/items/@2017vaswaniAttentionAllYou)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4665249039130836993)

## 论文试图解决的问题（是否是新的问题）

序列转换任务（sequence transduction tasks），或者具体的，机器翻译任务。实际上可以应用于很多其他任务，甚至 NLP 之外的任务

## 论文的总体贡献

提出了一个基于注意力的序列转换（sequence transduction）模型，有别于传统的 RNN 或 CNN 网络模型。

## 论文提供的关键元素、关键设计

### Encoder

$N=6$ 个相同的层堆叠在一起，每一层是：$\mathrm{LayerNorm}(x+\mathrm{Sublayer}(x))$。

子层是：
- multi-head self-attention
- feed-forward

为了方便残差连接，所有隐层维度相同 $d_{model}=512$

### Decoder

$N=6$，子层略有区别：
- Masked multi-head self-attention
- 。。。

自回归（auto-regressive）：生成第 $t$ 个词的时候只知道前面 $1\sim t-1$ 的输出，不知道后面的输出。注意力机制中每次能看到所有词，这里是为了限制这种情况

### [[深度学习笔记#Layer Norm|Layer Norm]]

为什么不用 Batch Norm（论文没有说）：句子长度不相同

隐层是三维的： $(d,T,n_{\text{max}})$ ，$d$ 是特征维度，$T$ 是 batch size，$n_{\text{max}}$ 是（最大）句子长度

按照特征归一化会得到 $T\times n_{\text{max}}$ 大小的切片。

按照样本归一化得到 $d\times n$ 的切片，其中 $n$ 是当前句子长度（因为可以忽略后面的 zero-padding）。

后续一些研究表明（Understanding and Improving Layer Normalization）：Layer Norm 对梯度、对输入的正则化等方面的影响更重要

### Attention

Attention 的目的是将 query 和一组 key-value 对映射到 output，他们都是向量（对于一个词）或矩阵（对于一个句子）。output 是 value 的加权和，权重由 query 和 key 决定。

#### Scaled Dot-Product Attention

本文采取了最简单的一种权重计算方式：点乘

query 和 key 的维度是 $d_k$ ，value 的维度是 $d_v$ （虽然实际上 $d_k=d_v$ ，但这里是一般化的情况）

有 $n$ 个 query，$m$ 个 key-value 对

- 对于每一个 $q$ 和 $k$ 做点乘： $q^Tk$（$shape=1\times1$）
    - 向量化：$n$ 个 query 和 $m$ 个 key 放在一起就是 $Q^T_{d_k\times n}K_{d_k\times m}$（$shape=n\times m$）
- 除以 $\sqrt{d_k}$ 归一化： $\dfrac{q^Tk}{\sqrt{d_k}}$（$shape=1\times1$）
    - 点积的结果会比较大，导致 softmax 的结果接近 1，于是梯度很小。所以要归一化
- 对每一个 query softmax：$\mathrm{softmax}(\dfrac{Q^TK}{\sqrt{d_k}})$（$shape=n\times m$）
    - 将上式记为 $W$ ，$W$ 的每一行是一个 query 的所有权重，且有 $\sum_{j=1}^mW_{ij}=1$，即每行求和为 1
- 按第 $i$ 个 query 的权重 $W_i$ 对 $m$ 个 value （$V=\begin{bmatrix} | & | & | & |\\ v_1 & v_2 & \cdots & v_m\\ | & | & | & |\\\end{bmatrix}$）求加权和：$\sum_{j=1}^mW_{ij}v_j=VW_i^T$ （$W_i$ 是 $W$ 的第 $i$ 行）
    - 向量化：$n$ 个 query 放在一起， $V_{d_v\times m}W_{n\times m}^T$
    - 即 $\mathrm{Attention}(Q_{d_k\times n},K_{d_k \times m},V_{d_v \times m})=V\mathrm{softmax}(\dfrac{Q^TK}{\sqrt{d_k}})^T$（$shape=d_v\times n$）

> 这里的记号和论文中差一个转置（所有矩阵行列互换），因为我认为特征作为列向量、多个特征横向排列，这种矩阵排布更容易理解（列向量的拼接）

#### Multi-head

只用 [[#Scaled Dot-Product Attention]] 是没有参数可以学的。因此引入投影矩阵，将 $Q,K,V$ 分别投影到 $h$ 个子空间，Attention 之后合并再投影。

- 对第 $i$ 个 head：$\mathrm{head_i=Attention}(W^Q_{d_k\times d_{model}}Q_{d_{model}\times n},W^K_{d_k\times d_{model}}K_{d_{model}\times m},W^V_{d_v\times d_{model}}V_{d_{model}\times m})$（$shape=d_v\times n$）
- 拼接： $\mathrm{head}_{}=\mathrm{Concat(head_1,\cdots,head_h)}$（$shape=h\cdot d_v\times n$）
- 最后再投影： $\mathrm{MultiHead}(Q_{d_{model}\times n},K_{d_{model}\times m},V_{d_{model}\times m})=W^O_{d_{model}\times h\cdot d_v}\mathrm{head}_{h\cdot d_v\times n}$（$shape=d_{model}\times n$）

> 这里每个 head 的投影部分可以并行（用矩阵表达）

$h=8,d_k=d_v=d_{model}/h=64$

#### Mask

处理第 $t$ 个词的时候只能看到 $1\sim t-1$ 的 key-value 对。

在 softmax 之前，把 $t\sim m$ 的结果变成负无穷 $-\infty$ （1e-10 in practice），这样在 softmax 之后就会是 0

#### 连接方式

- Encoder: self-attention，$Q,K,V$ 来自相同的向量（$n=m=T$，$T$ 是输入句子的长度）。每一层中，每个位置的向量都能看到前一层的每个向量。
- Decoder: self-attention + mask，只能看到前面位置的词（TODO：mn？）
- Encoder-Decoder: $K,V$ 来自 Encoder， $Q$ 来自 Decoder，于是 Decoder 能看见 Encoder 中的每一个位置（TODO：mn？）

### Feed Forward

就是 2 层的 MLP。输入和输出维度都是 $d_{model}=512$ ，隐层维度 $d_{ff}=2048$

论文称之为 Position-wise，因为是对每一个词（位置）独立做，不过参数共享

### Embedding

- Word Embedding：可学习的词表示。
- Positional Encoding：正余弦。因为引入了正余弦的 Encoding，为了让 Word Embedding 和 Positional Encoding 可以直接加（不要有系统性差距），给 Word Embedding 乘以 $\sqrt{d_{model}}$。后续工作如 Bert 让 Positional 也是可学习的。

### code

https://paperswithcode.com/paper/attention-is-all-you-need

https://github.com/graykode/nlp-tutorial/blob/master/5-1.Transformer/Transformer.py

https://zhuanlan.zhihu.com/p/403433120

https://github.com/AntNLP/fm-gym/tree/main/transformer

https://github.com/NVIDIA/DeepLearningExamples/tree/master/PyTorch/Translation/Transformer

https://github.com/NVIDIA/DeepLearningExamples/tree/master/PyTorch/LanguageModeling/BERT

## 实验（设置、数据集）

### 数据集

- WMT 2014 English-German
    - $4.5e6$ 句子
- WMT 2014 English-French
    - $3.6e7$句子

byte-pair encoding：提取词根

### 评估

[[NLP#Perplexity|Perplexity]]：基于词根的困惑度，不能和基于单词的困惑度相比较

[[NLP#BLEU|BLEU]]

TODO：更多细节

## 有什么疑问，如何继续深入，如何吸取到你的工作中

具体训练流程、测试流程

### Why Attention

论文说：一次看到了整个句子的信息

李沐：
- 后续研究表明，并不是只有 Attention 就行，Attention 起到聚合作用，其他的如残差、MLP 也是同等重要的
- Attention 不建模序列信息，为什么比 RNN 显示建模要好。因为提供了更广泛的归纳偏置（inductive biases），能够处理更一般化的信息。对模型的假设更少，需要更多数据和更大的模型才能训练出来

## 相关研究（如何归类，值得关注的研究员）

auto-regressive：
- Generating Sequences With Recurrent Neural Networks

byte-pair encoding：
- Massive Exploration of Neural Machine Translation Architectures, 2017

斯坦福 100+作者的 200+页综述：
- On the Opportunities and Risks of Foundation Models

对 LayerNorm 的新研究：
- Understanding and Improving Layer Normalization

对 Attention 在 Transformer 里面作用的研究：
- Attention is Not All You Need: Pure Attention Loses Rank Doubly Exponentially with Depth
