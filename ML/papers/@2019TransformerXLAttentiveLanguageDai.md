---
aliases: ["Transformer-XL: Attentive Language Models Beyond a Fixed-Length Context", "Transformer-XL: Attentive Language Models Beyond a Fixed-Length Context, 2019", "Transformer-XL"]
---
# Transformer-XL: Attentive Language Models Beyond a Fixed-Length Context

- **Journal**: arxiv:1901.02860
- **Author**: Zihang Dai, Zhilin Yang, Yiming Yang, Jaime Carbonell, Quoc V. Le, Ruslan Salakhutdinov
- **Year**: 2019
- **URL**: http://arxiv.org/abs/1901.02860
- [**Zotero**](zotero://select/items/@2019TransformerXLAttentiveLanguageDai)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=550970997159968797&noteId=1746141392088190976)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### 相对位置编码

普通位置编码可以拆解为四项：

$$
\begin{aligned}
\mathbf{A}_{i, j}^{\mathrm{abs}} &=[\mathbf{W}_{q}(\mathbf{E}_{x_{i}}+\mathbf{U}_{i})]^{\top}\mathbf{W}_{k}(\mathbf{E}_{x_{j}}+\mathbf{U}_{j})\\
& =\underbrace{\mathbf{E}_{x_{i}}^{\top} \mathbf{W}_{q}^{\top} \mathbf{W}_{k} \mathbf{E}_{x_{j}}}_{(a)}+\underbrace{\mathbf{E}_{x_{i}}^{\top} \mathbf{W}_{q}^{\top} \mathbf{W}_{k} \mathbf{U}_{j}}_{(b)} \\
& +\underbrace{\mathbf{U}_{i}^{\top} \mathbf{W}_{q}^{\top} \mathbf{W}_{k} \mathbf{E}_{x_{j}}}_{(c)}+\underbrace{\mathbf{U}_{i}^{\top} \mathbf{W}_{q}^{\top} \mathbf{W}_{k} \mathbf{U}_{j}}_{(d)} .
\end{aligned}
$$

相对位置编码：

$$
\begin{aligned}
\mathbf{A}_{i, j}^{\mathrm{rel}} & =\underbrace{\mathbf{E}_{x_{i}}^{\top} \mathbf{W}_{q}^{\top} \mathbf{W}_{k, E} \mathbf{E}_{x_{j}}}_{(a)}+\underbrace{\mathbf{E}_{x_{i}}^{\top} \mathbf{W}_{q}^{\top} \mathbf{W}_{k, R} \mathbf{R}_{i-j}}_{(b)} \\
& +\underbrace{u^{\top} \mathbf{W}_{k, E} \mathbf{E}_{x_{j}}}_{(c)}+\underbrace{v^{\top} \mathbf{W}_{k, R} \mathbf{R}_{i-j}}_{(d)} .
\end{aligned}
$$

其中：
- $\mathbf{U}_{j}$ 被替换为 $\mathbf{R}_{i-j}$ ，融入了先验知识：只有相对位置关系是重要的，这里的 $R$ 是sin形式的，不可训练
- $\mathbf{U}_{i}^{\top} \mathbf{W}_{q}^{\top}$ 在 $(c)(d)$ 中被分别替换为可训练的 $u,v \in \mathbb{R}^{d}$ ，于是对所有query位置，query向量都是一样的
- $\mathbf{W}_{k}$ 被拆分为两组参数 $\mathbf{W}_{k, E},\mathbf{W}_{k, R}$ ，分别表示基于内容和基于位置的key

于是每一项都有特定含义：
1. content-based addressing
2. content-dependent positional bias
3. global content bias
4. global positional bias

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%

## [[pq]]

- whose cost is quadratic w.r.t. the sequence length.
