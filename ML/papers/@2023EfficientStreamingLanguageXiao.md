---
aliases:
  - Efficient Streaming Language Models with Attention Sinks
  - Efficient Streaming Language Models with Attention Sinks, 2023
  - StreamingLLM
---
# Efficient Streaming Language Models with Attention Sinks

- **Journal**: arxiv:2309.17453 #ICLR/24
- **Author**: Guangxuan Xiao, Yuandong Tian, Beidi Chen, Song Han, Mike Lewis
- **Year**: 2023
- **URL**: http://arxiv.org/abs/2309.17453
- [**Zotero**](zotero://select/items/@2023EfficientStreamingLanguageXiao)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?noteId=2027768705114526976)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

推理时的内存与计算复杂度问题

![fig1](https://pdf.cdn.readpaper.com/parsed/fetch_target/02e8874a9a85d35676fbc643d19fdec3_1_Figure_1_1762025345.png)

|             | Dense    | Window  | Re-computation | Streaming   | ALiBi    |
| ----------- | -------- | ------- | -------------- | ----------- | -------- |
| kv cache    | $O(T)$   | $O(L)$  | $O(L)$         | $O(L+s)$    | $O(T)$   |
| computation | $O(T^2)$ | $O(TL)$ | $O(TL^2)$      | $O(T(L+s))$ | $O(T^2)$ |

b: 将其视为 NOPE，可以把长度超出视为长度外推，从 OOD 的角度来看性能下降。但是这个视角不能解释 d 为什么有效。

为什么以前没有关注过？
- [[@2020LongformerLongDocumentTransformerBeltagy|Longformer: The Long-Document Transformer, 2020]]：encoder-decoder，decoder no sparse Attention
- [[@2022SimpleLocalAttentionsXiong|Simple Local Attentions Remain Competitive for Long-Context Tasks, 2022]]： encoder

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### Window Attention Fails!

![fig3](https://pdf.cdn.readpaper.com/parsed/fetch_target/02e8874a9a85d35676fbc643d19fdec3_3_Figure_3_-359970483.png)

- Dense Attention 在 $T>L$ 时崩溃
- Window Attention 在 $T> \text{cache size}$ 时崩溃（此时 kv cache 开始轮换）

> 为什么 Pythia、Falcon 没有崩溃？

### Why Window Attention Fails? Attention Sinks

![fig2](https://pdf.cdn.readpaper.com/parsed/fetch_target/02e8874a9a85d35676fbc643d19fdec3_2_Figure_2_1369138411.png)

对 $256$ 个 $L=16$ 的句子取平均。现象：
- 前两层（layer 0, layer 1）存在局部性
- 后面不少层将注意力集中在第一个 token

于是，删除第一个 token 会导致显著的 OOD

### Initial Tokens, How?

猜想：
1. 初始 token 包含重要语义信息
2. 初始 token 所在的位置很重要，模型学习到了 bias towards their absolute position

![tab1](https://pdf.cdn.readpaper.com/parsed/fetch_target/02e8874a9a85d35676fbc643d19fdec3_4_Table_1_1612101083.png)

> 左 tab1，右 tab2

65k token from PG19 test set
- Window Attention cache size 1024
- first 4 tokens + recent 1020 Window Attention
- 4 `"\n"` + recent 1020 Window Attention

### Why Attention Sinks?

Softmax 本质是 $\mathbb{R} \rightarrow [0,1]$ 的归一化，导致任意一个分量的值都不会是 $0$ 。即使不需要注意任何一个 token，也需要分配概率值。因此，模型学会了将“多余的”注意力集中到特定位置。

#### Why on Initial Tokens?

由于自回归的顺序特性，初始 token 对后续所有 token 都可见。

### StreamingLLM

无需微调

![fig4](https://pdf.cdn.readpaper.com/parsed/fetch_target/02e8874a9a85d35676fbc643d19fdec3_4_Figure_4_201783727.png)

kv cache 轮换方式：
- PE 的 index 取 kv cache 内的位置，而非全局位置（!important）
- kv cache 中不包含 PE（!important）

注意力池：memory？

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### Streaming Long Text

![fig3](https://pdf.cdn.readpaper.com/parsed/fetch_target/02e8874a9a85d35676fbc643d19fdec3_3_Figure_3_-359970483.png)

![fig5](https://pdf.cdn.readpaper.com/parsed/fetch_target/02e8874a9a85d35676fbc643d19fdec3_6_Figure_5_-1370396758.png)

PG19 test set (100 books) 。PPL 波动归因于切换书籍

### Streaming QA on Instruction-Tuned Models

TODO：Arc？

![tab5](https://pdf.cdn.readpaper.com/parsed/fetch_target/02e8874a9a85d35676fbc643d19fdec3_7_Table_5_-1989084319.png)

StreamEval: LongEval，答案固定在 20 行之前

![fig9](https://pdf.cdn.readpaper.com/parsed/fetch_target/02e8874a9a85d35676fbc643d19fdec3_8_Figure_9_190389634.png)

可以与扩展上下文的技术结合

### Pre-Training with Attention Sinks

预训练 0.2B 模型
- standard SoftMax attention (Vanilla)
- SoftMax1 (Zero Sink)
- Prepend one Learnable Sink Token

$\operatorname{SoftMax}_{1}(x)_{i}=\dfrac{e^{x_{i}}}{1+\sum_{j=1}^{N} e^{x_{j}}}$

- loss 曲线相似，下游任务性能相似
- Attention 更集中（Sink Token 发挥了作用）

![fig7](https://pdf.cdn.readpaper.com/parsed/fetch_target/02e8874a9a85d35676fbc643d19fdec3_7_Figure_7_-1777598110.png)

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
本文对 Long Context 的研究方向进行了归类。并且指出不同类别之间是正交的。

- 长度外推（Length Extrapolation）：train short, test long $\leftarrow$ 本文
    - 难点：直接外推通常不可行，指标：PPL
    - 主要探索方向：改进 PE
        - [[@2022TrainShortTestPress|ALiBi]] 和 [[@2023ExtendingContextWindowChen|RoPE-PI]] 表明直接外推 RoPE 的性能是很差的。
        - [[@2022TrainShortTestPress|ALiBi]] 可以外推一定长度，但仍然无法处理很长的文本
- 扩展（预训练）上下文窗口（Context Window Extension）：train long, test that long
    - 难点：降低 $O(L^2)$ 的训练（计算、内存）复杂度，指标：成本、PPL、Task
    - 主要探索方向：
        - 工程优化：FlashAttention
        - 近似 / 稀疏 attention： BigBird，[[@2020LongformerLongDocumentTransformerBeltagy|Longformer]]，Reformer
        - 改进 RoPE+Further PreTrain：[[@2023ExtendingContextWindowChen|RoPE-PI]]，YaRN
- 有效利用长文本（Improving LLMs’ Utilization of Long Text），指标：Task
    - 本文的局限性：仍然只能利用最近的 token，而非全部 token
