---
aliases:
  - "Conditional probing: Measuring usable information beyond a baseline"
  - "Conditional probing: Measuring usable information beyond a baseline, 2021"
---
# Conditional probing: Measuring usable information beyond a baseline

- **Journal**: arxiv:2109.09234 #EMNLP/21
- **Author**: John Hewitt, Kawin Ethayarajh, Percy Liang, Christopher D. Manning
- **Year**: 2021
- **URL**: http://arxiv.org/abs/2109.09234
- [**Zotero**](zotero://select/items/@2021ConditionalProbingMeasuringHewitt)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4667103844883251201&noteId=2337505854536387584)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

probing

## 论文的总体贡献

## 论文提供的关键元素、关键设计

baselined probing performance:
$$\operatorname{Perf}(\phi(X))-\operatorname{Perf}(B)$$

conditional probing performance:
$$\operatorname{Perf}([B ; \phi(X)])-\operatorname{Perf}([B ; \mathbf{0}])$$

$B$ 和 $\phi(X)$ 一起作为probing的输入，从而计算出 $\phi(X)$ 贡献了多少 $B$ 中缺失的信息

### 总体流程

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
