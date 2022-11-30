---
aliases: ["Factual Probing Is [MASK]: Learning vs. Learning to Recall", "Factual Probing Is [MASK]: Learning vs. Learning to Recall, 2021", "OptiPrompt"]
---
# Factual Probing Is [MASK]: Learning vs. Learning to Recall

- **Journal**: arxiv:2104.05240 [cs]
- **Author**: Zexuan Zhong, Dan Friedman, Danqi Chen
- **Year**: 2021
- **URL**: http://arxiv.org/abs/2104.05240
- [**Zotero**](zotero://select/items/@2021FactualProbingMASKZhong)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?noteId=755020581615554560)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

- OptiPrompt：一种连续 prompt，用于 Factual Probing （LAMA）

## 论文提供的关键元素、关键设计

### 动机

把搜索空间限制在词表范围内是次优的，且人为的约束。

### 总体流程

类似 AutoPrompt ，prompt 的形式是：
$$
t_{r}=[\mathrm{X}][\mathrm{V}]_{1}[\mathrm{V}]_{2} \ldots[\mathrm{V}]_{m}[\mathrm{MASK}]
$$
其中 $[\mathrm{V}]_{i}\in\mathbb R^d$ 是 soft prompt，维度和 LM embedding 一致， $m$ 是超参数

基础模型：主要实验基于 BERT-base-cased，以及其他

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### 数据集

benchmark: LAMA: Language Models as Knowledge Bases, 2019
- evaluation benchmark ---- no training data, a pretrained language model can be evaluated "off-the-shelf" with no additional fine-tuning

dataset: AutoPrompt
- 800 train
- 200 dev

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%

factual probing：
- Language models as knowledge bases?, 2019
