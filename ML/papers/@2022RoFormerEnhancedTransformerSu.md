---
aliases: ["RoFormer: Enhanced Transformer with Rotary Position Embedding", "RoFormer: Enhanced Transformer with Rotary Position Embedding, 2022", "RoPE"]
---
# RoFormer: Enhanced Transformer with Rotary Position Embedding

- **Journal**: arxiv:2104.09864 [cs]
- **Author**: Jianlin Su, Yu Lu, Shengfeng Pan, Ahmed Murtadha, Bo Wen, Yunfeng Liu
- **Year**: 2022
- **URL**: http://arxiv.org/abs/2104.09864
- [**Zotero**](zotero://select/items/@2022RoFormerEnhancedTransformerSu)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4662765722829586433&noteId=1671207901605221376)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### 总体流程

$$
\begin{pmatrix}
\cos{m\theta_1}& -\sin{m\theta_1}&0&0&\cdots&0&0\\
\sin{m\theta_1}&\cos{m\theta_1}&0&0&\cdots&0&0 \\
0&0&\cos{m\theta_2}& -\sin{m\theta_2}&\cdots&0&0\\
0&0&\sin{m\theta_2}&\cos{m\theta_2}&\cdots&0&0 \\
\vdots&\vdots&\vdots&\vdots&\ddots&\vdots&\vdots\\
0&0&0&0&\cdots&\cos{m\theta_{d/2}}& -\sin{m\theta_{d/2}}\\
0&0&0&0&\cdots&\sin{m\theta_{d/2}}&\cos{m\theta_{d/2}}
\end{pmatrix}\begin{pmatrix}q_0\\q_1\\q_2\\q_3\\\vdots\\q_{d-2}\\q_{d-1}\end{pmatrix}
$$

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
