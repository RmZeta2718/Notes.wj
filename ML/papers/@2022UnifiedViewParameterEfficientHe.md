---
aliases: ["Towards a Unified View of Parameter-Efficient Transfer Learning", "Towards a Unified View of Parameter-Efficient Transfer Learning, 2022"]
---
# Towards a Unified View of Parameter-Efficient Transfer Learning

- **Journal**: arxiv:2110.04366 [cs]
- **Author**: Junxian He, Chunting Zhou, Xuezhe Ma, Taylor Berg-Kirkpatrick, Graham Neubig
- **Year**: 2022
- **URL**: http://arxiv.org/abs/2110.04366
- [**Zotero**](zotero://select/items/@2022UnifiedViewParameterEfficientHe)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?noteId=755321167401959424)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

- How are these methods connected?
- Do these methods share design elements that are essential for their effectiveness, and what are they?
- Can the effective ingredients of each method be transferred to others to yield more effective variants?

### 现状

- Adapter
- [[@2021PrefixTuningOptimizingContinuousLi|prefix-tuning]]
- [[@2021PowerScaleParameterEfficientLester|prompt-tuning]]
- [[@2021LoRALowRankAdaptationHu|LoRA]]

## 论文的总体贡献

- 统一框架
- 综合各种方法优点的新方法

## 论文提供的关键元素、关键设计

### [[@2017AttentionAllYouVaswani|Transformer]] 结构

self-attention：
$$
\text{Attn}(Q, K, V)=\text{softmax}\left(\frac{Q K^T}{\sqrt{d_{k}}}\right) V
$$
其中，query $Q\in\mathbb R^{n\times d_k}$ , key-value pair $K\in\mathbb R^{m\times d_k},V\in\mathbb R^{m\times d_v}$ ， $n,m$ 分别是 query 和 key-value pair 的个数

Multi-head attention 包含 $N_h$ 个 head，每个 head 分别由下列投影矩阵参数化
$$
W_{q}^{(i)}, W_{k}^{(i)}, W_{v}^{(i)} \in \mathbb{R}^{d \times d_{h}}
$$

长度为 $m$ 的序列向量 $C\in\mathbb R^{m\times d}$ 和 query 向量 $x\in \mathbb R^d$ 的 multi-head attention (MHA) 表示为：
$$
\begin{align}
\text{MHA}(C, x)&=\text{Concat}\left(\mathrm{head_1}, \cdots, \mathrm{head_h}\right) W_{o}\\
\mathrm{head_i}&=\text{Attn}\left(x W_q^{(i)}, C W_k^{(i)}, C W_v^{(i)}\right)
\end{align}
$$
其中 $W_o\in \mathbb R^{d\times d}$  ， $d$ 是模型维度，通常 $d_h=d/N_h$

feed-forward network (FFN) 是两层线性层以及 [[深度学习笔记#ReLU（Rectified Linear Unit）|ReLU]] 激活函数
$$
\text{FFN}(x)=\text{ReLU}\left(x W_1+b_1\right) W_2+b_2
$$
其中 $W_1\in \mathbb R^{d\times d_m},W_2\in \mathbb R^{d_m\times d}$ ，通常 $d_m=4d$

最后还有残差连接，公式略。

### Parameter-efficient tuning 方法

#### Adapter

在 [[@2017AttentionAllYouVaswani|Transformer]] 层中加入一些小模块，由 down-projection $W_{\text{down}}\in \mathbb R^{d\times r}$ 和 up-projection $W_{\text{up}}\in \mathbb R^{r\times d}$ 组成，还包括残差连接：
$$
h \leftarrow h+f\left(h W_{\text {down}}\right) W_{\text{up}}
$$
其中， $f(\cdot)$ 是激活函数

#### [[@2021PrefixTuningOptimizingContinuousLi|Prefix-tuning]]

在原始的 $K,V$ 前面分别拼接 prefix 向量 $P_k,P_v\in\mathbb R^{l\times d}$
$$
\begin{matrix}
\mathrm{head_i}=\text{Attn}\left(x W_q^{(i)}, C W_k^{(i)}, C W_v^{(i)}\right) \\
\Downarrow \\
\mathrm{head_i}=\text{Attn}\left(x W_q^{(i)}, \text{concat}\left(P_k^{(i)}, C W_k^{(i)}\right), \text{concat}\left(P_v^{(i)}, C W_v^{(i)}\right)\right)
\end{matrix}
$$
其中 $P_k^{(i)},P_v^{(i)}\in\mathbb R^{l\times d/N_h}$ ，表示第 $i$ 个 head 对应的向量

#### [[@2021LoRALowRankAdaptationHu|LoRA]]

在层中添加可训练的低秩（low-rank）矩阵来估计权重更新。对于预训练的权重矩阵 $W\in\mathbb R^{d\times k}$ ，更新的低秩分解表示为：
$$
W+\Delta W=W+W_{\text{down}}W_{\text{up}}
$$
其中， $W_{\text{down}}\in \mathbb R^{d\times r},W_{\text{up}}\in \mathbb R^{r\times k}$

LoRA 对 query 和 value 矩阵执行上述更新。对于某个输入 $x$ ，LoRA 把 MHA 的投影部分输出变为：
$$
h \leftarrow h+s\cdot xW_{\text {down}}W_{\text{up}}
$$
其中， $s\ge1$ 是超参数

### A Unified View

$$
\begin{align}
\text {head}&=\operatorname{Attn}\left(\boldsymbol{x} \boldsymbol{W}_{q}, \operatorname{concat}\left(\boldsymbol{P}_{k}, \boldsymbol{C} \boldsymbol{W}_{k}\right), \operatorname{concat}\left(\boldsymbol{P}_{v}, \boldsymbol{C} \boldsymbol{W}_{v}\right)\right) \\
&=\operatorname{softmax}\left(\boldsymbol{x} \boldsymbol{W}_{q} \operatorname{concat}\left(\boldsymbol{P}_{k}, \boldsymbol{C} \boldsymbol{W}_{k}\right)^{\top}\right)\left[\begin{array}{c}
\boldsymbol{P}_{v} \\
\boldsymbol{C} \boldsymbol{W}_{v}
\end{array}\right] \\
&=(1-\lambda(\boldsymbol{x})) \operatorname{softmax}\left(\boldsymbol{x} \boldsymbol{W}_{q} \boldsymbol{W}_{k}^{\top} \boldsymbol{C}^{\top}\right) \boldsymbol{C} \boldsymbol{W}_{v}+\lambda(\boldsymbol{x}) \operatorname{softmax}\left(x \boldsymbol{W}_{q} \boldsymbol{P}_{k}^{\top}\right) \boldsymbol{P}_{v} \\
&=(1-\lambda(\boldsymbol{x})) \underbrace{\operatorname{Attn}\left(\boldsymbol{x} \boldsymbol{W}_{q}, \boldsymbol{C} \boldsymbol{W}_{k}, \boldsymbol{C} \boldsymbol{W}_{v}\right)}_{\text {standard attention }}+\lambda(\boldsymbol{x}) \underbrace{\operatorname{Attn}\left(\boldsymbol{x} \boldsymbol{W}_{q}, \boldsymbol{P}_{k}, \boldsymbol{P}_{v}\right)}_{\text {independent of } \boldsymbol{C}}\\
\\
\lambda(\boldsymbol{x})&=\frac{\sum_{i} \exp \left(\boldsymbol{x} \boldsymbol{W}_{q} \boldsymbol{P}_{k}^{\top}\right)_{i}}{\sum_{i} \exp \left(\boldsymbol{x} \boldsymbol{W}_{q} \boldsymbol{P}_{k}^{\top}\right)_{i}+\sum_{j} \exp \left(\boldsymbol{x} \boldsymbol{W}_{q} \boldsymbol{W}_{k}^{\top} \boldsymbol{C}^{\top}\right)_{j}}
\end{align}
$$
其中， $\lambda(x)$ 是一个标量，表示 prefix 的注意力权重之和

> 这里省略了 [[@2017AttentionAllYouVaswani|Transformer]] 中的缩放因子 $\sqrt d$

我将上述推导翻译成（我认为）更清晰的形式：
$$
\begin{align}
\mathrm{head_{prefix}}&=\text{Attn}\left(Q, \begin{bmatrix}P_k\\ K\end{bmatrix}, \begin{bmatrix}P_v\\ V\end{bmatrix}\right)\\
&=\text{softmax}\left(Q \begin{bmatrix}P_k\\ K\end{bmatrix}^T\right)\begin{bmatrix}P_v\\ V\end{bmatrix} \qquad (\text{ignore } \dfrac1{\sqrt d} \text{ for ease of notation}) \\
&=\text{softmax}\left( \begin{bmatrix}QP_k^T & QK^T\end{bmatrix}\right)\begin{bmatrix}P_v\\ V\end{bmatrix}\\
&=(1-\lambda(Q)) \text{softmax}\left(QK^T\right) V+\lambda(Q) \text{softmax}\left(QP_k^T\right)P_v \\
&=(1-\lambda(Q)) \underbrace{\text{Attn}(Q, K, V)}_{\text{standard attention}}+\lambda(Q) \underbrace{\text{Attn}(Q, P_{k}, P_{v})}_{\text {independent of } K,V}\\
\\
\lambda(Q)&=\frac{\sum_{i} \exp(Q P_{k}^T)_{i}}{\sum_{i} \exp(Q P_{k}^T)_{i}+\sum_{j} \exp(QK^T)_{j}}
\end{align}
$$

于是可以将 prefix 视为对原隐藏层的修改，写为下面的形式：
$$
\begin{align}
\boldsymbol{h} &\leftarrow(1-\lambda(\boldsymbol{x})) \boldsymbol{h}+\lambda(\boldsymbol{x}) \Delta \boldsymbol{h} \qquad &&(\Delta \boldsymbol{h}\triangleq\operatorname{softmax}\left(\boldsymbol{x} \boldsymbol{W}_{q} \boldsymbol{P}_{k}^{\top}\right) \boldsymbol{P}_{v})\\
&\leftarrow(1-\lambda(\boldsymbol{x})) \boldsymbol{h}+\lambda(\boldsymbol{x}) f\left(\boldsymbol{x} \boldsymbol{W}_{1}\right) \boldsymbol{W}_{2} \qquad &&(\boldsymbol{W}_{1}\triangleq\boldsymbol{W}_{q} \boldsymbol{P}_{k}^{\top}, \boldsymbol{W}_{2}\triangleq\boldsymbol{P}_{v},f(\cdot)\triangleq\text{softmax}(\cdot))\\
\end{align}
$$

于是这种形式与 [[#Adapter]] 很像（而且 prefix 中的长度 $l$ 和 Adapter 中的瓶颈维度 $r$ 的作用类似）：
$$
\begin{array}{rc}
\text{Prefix: } & h\leftarrow(1-\lambda(x)) h+\lambda(x) f\left(x W_1\right) W_2\\
& \Updownarrow\\
\text{Adapter: }& h \leftarrow h+f\left(h W_{\text {down}}\right) W_{\text{up}}\\
\end{array}
$$

主要区别：
- Prefix 有权重，Adapter 没有
- Prefix 以层输入 $x$ 为输入，而 Adapter 以层输出 $h$ 为输入，因此 Prefix 也可以视作与层并行的计算，而 Adapter 是串行的
- Prefix 是多头的，Adapter 只有一个 head（参数共享），这导致 Prefix 的表达能力更强，因为多头的向量维度更低，同等瓶颈下损失的信息更少，而参数量相同。
    - Prefix 满秩变换要求 $l\ge d_h$ ，而 Adapter 要求 $r\ge d=d_h\times N_h$
    - 仅考虑一层，$l=r$ 时，参数量是等同的：Prefix 的参数量是 $2\times l\times d_h\times N_h=2\times l\times d$ ，Adapter 的参数量是 $2\times r\times d$

![tab11](https://pdf.cdn.readpaper.com/parsed/fetch_target/e1e47628dd45ba47904d8f2597810ea1_13_Table_11_-125685422.png)

受上述联系启发，提出框架：将所有模型视作学习一个 $\Delta h$ ，并对 $h$ 以某种形式进行修改。

![tab1](https://pdf.cdn.readpaper.com/parsed/fetch_target/e1e47628dd45ba47904d8f2597810ea1_4_Table_1_1042779594.png)

> 我认为上图 Proposed Variants 的 functional form 应该是 $x$ 而不是 $h$ ，可能是作者写错了。

![fig3](https://pdf.cdn.readpaper.com/parsed/fetch_target/e1e47628dd45ba47904d8f2597810ea1_3_Figure_3_1042779594.png)

同时提出了 3 种新的方法：
- Parallel Adapter：把 prefix 的 insertion form 迁移到 Adapter 中
- Multi-head Parallel Adapter：把 prefix 的 modified representation 迁移到 Adapter 中。期望在不增加参数的情况下提升表达能力（improves the capacity for free）
- Scaled Parallel Adapter：把 LoRA 的 insertion form 和 composition function 迁移到 Adapter 中。

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### 数据集

- XSum: English singledocument summarization
- WMT: en-ro translation
- MNLI: English natural language inference
- SST2: English sentiment classification

### 基础模型

- summarization/translation: mBART-LARGE (Multilingual Denoising Pre-training for Neural Machine Translation, 2020)，BART 的多语言版本
- inference/classification: RoBERTa-BASE

### 消融

#### 串行/并行

![tab3](https://pdf.cdn.readpaper.com/parsed/fetch_target/e1e47628dd45ba47904d8f2597810ea1_6_Table_3_-1698765474.png)

并行更好。因此后续实验不再考虑串行。

#### Attention/FFN

- 参数量较小时（0.1\%），Attention 更好
- 参数量较大时（3.6\%），FFN 更好

Observation：
- [[@2021PrefixTuningOptimizingContinuousLi|Prefix-tuning]] 的性能不会随着 prefix 长度 $l$ 的增加而持续上升，会下降。这一点和原论文的观察一致。

#### Composition function

![tab5](https://pdf.cdn.readpaper.com/parsed/fetch_target/e1e47628dd45ba47904d8f2597810ea1_8_Table_5_1042779594.png)

- Gated addition 是因为 Softmax 而存在的，所以不作为比较对象
- 采用 $s=4$ 的缩放更好

> 为什么有用？
> 表中参数量是一样的吗？论文说 LoRA 的 $r=102$ （对齐原论文），而提出的方法 $r=512$。而 LoRA 的参数量是两倍（同等 $r$ 下），所以参数量的数字似乎不太对。

#### 综合消融结果

![tab6](https://pdf.cdn.readpaper.com/parsed/fetch_target/e1e47628dd45ba47904d8f2597810ea1_8_Table_6_-1698765474.png)

MAM Adapter：用 $l=30$ 的 prefix，加在 Attention 上。用 $r=512$ 的 scaled parallel adapter，加在 FFN 上。

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%

## [[pq]]

- as exemplified in Figure 2
