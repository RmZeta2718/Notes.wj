---
aliases: ["LoRA: Low-Rank Adaptation of Large Language Models", "LoRA: Low-Rank Adaptation of Large Language Models, 2021", "LoRA"]
---
# LoRA: Low-Rank Adaptation of Large Language Models

- **Journal**: arxiv:2106.09685 [cs]
- **Author**: Edward J. Hu, Yelong Shen, Phillip Wallis, Zeyuan Allen-Zhu, Yuanzhi Li, Shean Wang, Lu Wang, Weizhu Chen
- **Year**: 2021
- **URL**: http://arxiv.org/abs/2106.09685
- [**Zotero**](zotero://select/items/@2021LoRALowRankAdaptationHu)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4551486883931103233&noteId=1539080524591653888)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### 动机

相关研究表明，模型虽然参数量很大（over-parametrized），而其内在的维度并没有那么高。

于是假设：应用模型时对模型权重的更新也是一个低秩更新。

- Adapter是串行的，虽然参数量不大，但是并行度不高，所以添加Adapter会显著增加（主要是inference时的）延时
- 对模型并行不友好。显著增加GPU同步开销。

### 总体流程

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%

前置研究：
- Measuring the Intrinsic Dimension of Objective Landscapes, 2018
- Intrinsic Dimensionality Explains the Effectiveness of Language Model Fine-Tuning, 2020