---
aliases:
  - "Dissecting Query-Key Interaction in Vision Transformers"
  - "Dissecting Query-Key Interaction in Vision Transformers, 2025"
---

# Dissecting Query-Key Interaction in Vision Transformers

- **Journal**: arXiv:2405.14880 #NeurIPS/24 Oral
- **Author**: Xu Pan, Aaron Philip, Ziqian Xie, Odelia Schwartz
- **Year**: 2025
- **URL**: http://arxiv.org/abs/2405.14880
- [**Zotero**](zotero://select/items/@2025DissectingQueryKeyInteractionPan)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

对 $\mathbf{W}_q^\top \mathbf{W}_k$ SVD 分解，从而 qk 可以统一为 x，以 uv 作为基向量，考虑 attn

$\mathbf{x}_i^\top \mathbf{W}_q^\top \mathbf{W}_k \mathbf{x}_j = \sum_{n=1}^{d_k} \mathbf{x}_i^\top \mathbf{u}_n \sigma_n \mathbf{v}_n^\top \mathbf{x}_j$

每一对 uv 构成了 code book，即和 u 相近的 x，会找到和 v 相近的 x

论文分析了uv的余弦相似度，发现底层（第一层）相似度高（=1），中高层相似度接近0

评论：然而cos sim的问题是：在高维空间中不可靠，因为大概率互相垂直，没有体现出空间指向性

### 总体流程

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
