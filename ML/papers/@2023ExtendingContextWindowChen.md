---
aliases:
  - Extending Context Window of Large Language Models via Positional Interpolation
  - Extending Context Window of Large Language Models via Positional Interpolation, 2023
  - RoPE-PI
---
# Extending Context Window of Large Language Models via Positional Interpolation

- **Journal**: arxiv:2306.15595
- **Author**: Shouyuan Chen, Sherman Wong, Liangjian Chen, Yuandong Tian
- **Year**: 2023
- **URL**: http://arxiv.org/abs/2306.15595
- [**Zotero**](zotero://select/items/@2023ExtendingContextWindowChen)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4771950625369882625&noteId=1854612893453042176)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

长序列问题

直接在长文本上 Finetune，收敛速度太慢

## 论文的总体贡献

Position Interpolation
- 1000 个 step 的训练就能达到较好性能，相比 FT 10000 step 速度更快
- 理论上说明向内差值的 attention score 上界更小，从而更稳定，不会出现爆炸

## 论文提供的关键元素、关键设计

### catastrophic values in attention computation

对于[[@2022RoFormerEnhancedTransformerSu|RoPE]]，一对给定的 qk 的 attention score 随距离的函数为：
$$
a(s)=\operatorname{Re}\left[\sum_{j=0}^{d / 2-1} h_{j} e^{\mathrm{i} s \theta_{j}}\right]
$$

其中，$h_{j}=\boldsymbol{q}_{[2 j: 2 j+1]} \boldsymbol{k}_{[2 j: 2 j+1]}^{*}=\left(q_{2 j}+\mathrm{i} q_{2 j+1}\right)\left(k_{2 j}-\mathrm{i} k_{2 j+1}\right)$ ，表示 qk 的内积。$\theta_j=10000^{-2j/d}$

attention score 是输入 $h$ 和相对距离 $s$ 的函数。这里假设每个位置上的输出 $a$ 都是正态分布，以距离 $s$ 为自变量，输入 $h$ 为参数，拟合输入（以一簇三角函数为基函数拟合 $y=0+\varepsilon$）。也就是找到某个输入 $h$ ，使得在任何距离上的 attention score 都是比较小的。有点类似傅里叶级数。

然后把距离 $s$ 外推，看到在预训练范围内比较稳定的输入 $h$ 在更长的距离上呈现出很大的波动。因此直接外推是不稳定的，会导致 attention score 出现异常值。预训练的过程基本可以看做拟合一个合适的输入 $h$ ，而由于只在某个距离范围内训练，所以只有给定范围内的 attention score 是在合理范围内的。

由于基函数 $\phi_{j}(s)=e^{\mathrm{i} s \theta_{j}}$ 是光滑的（没有频率特别高的因子？），因此在预训练的距离向内差值的波动较小。

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/e832b0767955ca753b066fee5b70c50b_3_Figure_2_-1000039138.png)

### Position Interpolation

不考虑“外推性”（Extrapolation），而是将位置 ID 压缩到预训练时支持的最长序列，即向内差值（Interpolation）
![](https://pdf.cdn.readpaper.com/parsed/fetch_target/e832b0767955ca753b066fee5b70c50b_1_Figure_1_1568776386.png)

$$
\text{Position Interpolation}(x,m)=\text{RoPE}(x,m\dfrac L{L'})\qquad \text{for } L'>L
$$

映射： $[0,L')\mapsto  [0,L)$

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### Long Sequence Language Modeling

- book corpus (PG-19)
- Arxiv Math proof-pile

![tab1](https://pdf.cdn.readpaper.com/parsed/fetch_target/e832b0767955ca753b066fee5b70c50b_6_Table_1_1010005755.png)

PI 收敛地比 FT 快。

> 我认为：向外插值，数据点比较稀疏，要把大范围波动限制到合理范围内很困难，不容易训练。向内插值，原本波动就小，所以拟合起来比较容易。
>
> 另外，向内插值在我看来也是拟合随机数据，而不是根据某种特定规律扩展。我认为收敛速度快仅仅是因为波动幅度问题，而不是因为 RoPE 有多么好的性质。
> 
> 让模型过拟合到PE是可行的，但是让PE去适配模型是不可能的，两者的表达能力上存在根本的差异。

### Measuring Effective Context Window Size Through Passkey Retrieval

from [[@2023LandmarkAttentionRandomAccessMohtashami|Landmark Attention: Random-Access Infinite Context Length for Transformers]]

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/e832b0767955ca753b066fee5b70c50b_8_Figure_3_-656175357.png)

至少 $20\%$ 的准确率即视为有效

> 结合 LM 实验，我认为 LM 任务上 PPL 的降低只是因为忽略了较远的 token。当需要用到远处的 token 时，直接 FT 的做法就不 work 了

### Benchmarks On Original Context Window Size

性能下降

### Long Document Summarization

GovReport

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
