---
aliases:
  - "Base of RoPE Bounds Context Length"
  - "Base of RoPE Bounds Context Length, 2024"
---

# Base of RoPE Bounds Context Length

- **Journal**: arxiv:2405.14591
- **Author**: Xin Men, Mingyu Xu, Bingning Wang, Qingyu Zhang, Hongyu Lin, Xianpei Han, Weipeng Chen
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2405.14591
- [**Zotero**](zotero://select/items/@2024BaseRoPEBoundsMen)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=2329435625969206784&noteId=2352105804276230656)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

[Transformer 升级之路：18、RoPE 的底数选择原则 - 科学空间|Scientific Spaces (kexue.fm)](https://kexue.fm/archives/10122)

> 

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### RoPE 性质：远程衰减

注意力的上界随距离递减

$$
\left|A_{i j}\right|=\left|q_{i}^{T} R_{m} k_{j}\right|\le\max _{l}\left(\left|h_{l}-h_{l+1}\right|\right) \sum_{n=1}^{d / 2}\left|\sum_{l=0}^{n-1} e^{(j-i) \theta_{l} \sqrt{-1}}\right|
$$

区分相关向量 $\boldsymbol{\tilde k}=\boldsymbol{q}+\boldsymbol{\varepsilon}$ 和随机向量 $\boldsymbol{k}$ 的能力（语义聚合） $B_{m,\theta}$ 随距离递减

$$
\begin{align}
\mathbb{E}_{\boldsymbol{q}, \boldsymbol{k}, \boldsymbol{\tilde k}}\left[\boldsymbol{q}^{\top} \mathcal{R}_m\boldsymbol{\tilde k}-\boldsymbol{q}^{\top} \mathcal{R}_m \boldsymbol{k}\right]&=2\sigma^2\sum_{i=0}^{d/2-1}\cos m\theta_i
\\&\triangleq 2\sigma^2B_{m,\theta}
\end{align}
$$

其中，$\boldsymbol{\varepsilon}$ 是0均值的随机扰动。假设 $\boldsymbol{q},\boldsymbol{k}\in\mathbb R^d$ 的每一维 I.I.D.

对于 $\theta_i=b^{-2i/d}$ ：

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/690dd1823aef18604d80fe81c3bc25d7_5_Figure_4_-95865585.png)

语义聚合的能力尽可能大 $\Rightarrow B_{m,\theta}\ge 0$ ，解得 $b$ 的下界：

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/690dd1823aef18604d80fe81c3bc25d7_6_Table_2_-490776805.png)

拟合： $L=6.97b^{0.614}$

语义聚合推导

$$
\begin{align}
&\quad\ \mathbb{E}_{\boldsymbol{q}, \boldsymbol{k}, \boldsymbol{\tilde k}}\left[\boldsymbol{q}^{\top} \mathcal{R}_m\boldsymbol{\tilde k}-\boldsymbol{q}^{\top} \mathcal{R}_m \boldsymbol{k}\right]\\
&=\mathbb{E}_{\boldsymbol{q}, \boldsymbol{k}, \boldsymbol{\varepsilon}}\left[\boldsymbol{q}^{\top} \mathcal{R}_m(\boldsymbol{q}+\boldsymbol{\varepsilon})-\boldsymbol{q}^{\top} \mathcal{R}_m \boldsymbol{k}\right] \\
&= \mathbb{E}_{\boldsymbol{q}}\left[\boldsymbol{q}^{\top} \mathcal{R}_m \boldsymbol{q}\right]-\mathbb{E}_{\boldsymbol{q}, \boldsymbol{k}}\left[\boldsymbol{q}^{\top} \mathcal{R}_m \boldsymbol{k}\right] \qquad(\mathbb E[\boldsymbol\varepsilon]=0) \\
&=\mathbb{E}_{\boldsymbol{q}}\left[\boldsymbol{q}^{\top} \mathcal{R}_m \boldsymbol{q}\right]-\mathbb{E}_{\boldsymbol{q}}[\boldsymbol{q}]^{\top} \mathcal{R}_m \mathbb{E}_{\boldsymbol{k}}[\boldsymbol{k}] \qquad (\boldsymbol q,\boldsymbol k \text{ 独立})\\
&=\mathbb{E}_{\boldsymbol{q}}\left[\boldsymbol{q}^{\top} \mathcal{R}_m \boldsymbol{q}\right]-\mu^{2} \mathbf{1}^{\top} \mathcal{R}_m \mathbf{1} \qquad(\mathbb{E}[\boldsymbol{q}]=\mathbb{E}[\boldsymbol{k}]=\boldsymbol{\mu}) \\
&=\mathbb{E}_{\boldsymbol{q}}\left[\sum_{i=0}^{d / 2-1}\left(q_{2 i}^{2}+q_{2 i+1}^{2}\right) \cos m \theta_{i}\right]-\sum_{i=0}^{d / 2-1} 2 \mu^{2} \cos m\theta_{i} \\
&=\sum_{i=0}^{d / 2-1} 2\left(\mu^{2}+\sigma^{2}\right) \cos m \theta_{i}-\sum_{i=0}^{d / 2-1} 2 \mu^{2} \cos m \theta_{i} \qquad(\mathbb{E}[q_i^2]=\mu^2+\sigma^2) \\
&=\sum_{i=0}^{d / 2-1} 2 \sigma^{2} \cos m \theta_{i}
\end{align}
$$

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

[[@2024ScalingLawsRoPEbasedLiu|Scaling Laws of RoPE-based Extrapolation, 2024]] 发现降低 $b$ 能使 PPL 降低，但是本文发现在长文档任务上表现不佳。

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/690dd1823aef18604d80fe81c3bc25d7_4_Figure_3_1930619136.png)

Llama2-7B 越过下界后长文本性能恢复

![fig6](https://pdf.cdn.readpaper.com/parsed/fetch_target/690dd1823aef18604d80fe81c3bc25d7_7_Figure_6_-1830952395.png)

预训练模型也受下界影响：2B 模型，1T tokens 上预训练，4k上下文，$b=100$，FT到 $b=\mathrm{10k,1M}$

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/690dd1823aef18604d80fe81c3bc25d7_7_Figure_7_-960313074.png)

## 相关研究

%% 如何归类。值得关注的研究员 %%
