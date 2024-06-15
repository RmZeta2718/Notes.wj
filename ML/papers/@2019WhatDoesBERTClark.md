---
aliases:
  - "What Does BERT Look At? An Analysis of BERT's Attention"
  - "What Does BERT Look At? An Analysis of BERT's Attention, 2019"
---
# What Does BERT Look At? An Analysis of BERT's Attention

- **Journal**: arxiv:1906.04341 #ACL/19
- **Author**: Kevin Clark, Urvashi Khandelwal, Omer Levy, Christopher D. Manning
- **Year**: 2019
- **URL**: http://arxiv.org/abs/1906.04341
- [**Zotero**](zotero://select/items/@2019WhatDoesBERTClark)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=550493768760930304&noteId=2321743808078942976)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

Attention模块分析

## 论文的总体贡献

### surface-level Pattern

- 相对位置：大部分head**不会**关注当前token，而关注相邻（前、后）的head有很多
- 关注特定token：`[CLS]` `[SEP]` 标点符号。解释：
    - `[CLS]` `[SEP]`是最常见的token
    - 他们聚合了segment-level information？然而，`[SEP]`倾向于关注自己，而非整个序列。某些特定功能的head，在功能不激活时，关注 `[SEP]`
    - 关注特殊token作为一种no-op
- 注意力聚集程度（熵）：（主要是低层head）注意力更分散

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/f659d386d2d8de9b0c9ad8f19374bf4b_2_Figure_2_-1778302735.png)

### gradient-based measures of feature importance

MLM任务的loss相对于注意力分数 $\alpha=\operatorname{SoftMax}(QK^T)$ 的梯度 $\frac{\partial L}{\partial \alpha}$ ，直观来看，这个指标反映了注意力的变化如何影响模型输出

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/f659d386d2d8de9b0c9ad8f19374bf4b_2_Figure_3_1220248498.png)

从第5层开始，`[SEP]`的梯度变得很低（同时attention数值也变高），这说明对`[SEP]`token的关注变多或变少都不影响模型输出。



## 论文提供的关键元素、关键设计

### 总体流程

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
