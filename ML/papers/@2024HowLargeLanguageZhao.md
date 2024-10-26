---
aliases:
  - "How do Large Language Models Handle Multilingualism?"
  - "How do Large Language Models Handle Multilingualism?, 2024"
---
# How do Large Language Models Handle Multilingualism?

- **Journal**: arXiv:2402.18815
- **Author**: Yiran Zhao, Wenxuan Zhang, Guizhen Chen, Kenji Kawaguchi, Lidong Bing
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2402.18815
- [**Zotero**](zotero://select/items/@2024HowLargeLanguageZhao)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=2343459865676571392&noteId=2403046326503369984)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### Parallel Language-specific Neuron Detection (PLND)

mask hidden_states 的某一维（对应参数矩阵的一行或一列，行还是列取决于计算过程），比较mask前后的层输出差的模长，超过阈值（超参数）的视为高度激活的参数

给特定语言的输入，就能筛选出特定语言的神经元



## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
