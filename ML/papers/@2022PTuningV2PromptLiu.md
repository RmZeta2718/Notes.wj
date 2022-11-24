---
aliases: ["P-Tuning v2: Prompt Tuning Can Be Comparable to Fine-tuning Universally Across Scales and Tasks", "P-Tuning v2: Prompt Tuning Can Be Comparable to Fine-tuning Universally Across Scales and Tasks, 2022", "P-Tuning"]
---
# P-Tuning v2: Prompt Tuning Can Be Comparable to Fine-tuning Universally Across Scales and Tasks

- **Journal**: arxiv:2110.07602 [cs]
- **Author**: Xiao Liu, Kaixuan Ji, Yicheng Fu, Weng Lam Tam, Zhengxiao Du, Zhilin Yang, Jie Tang
- **Year**: 2022
- **URL**: http://arxiv.org/abs/2110.07602
- [**Zotero**](zotero://select/items/@2022PTuningV2PromptLiu)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=667145423398391808&noteId=754992444920283136)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

更好的 soft prompt

## 论文的总体贡献

技术上沿用了 [[@2021PrefixTuningOptimizingContinuousLi|prefix-tuning]]，但是通过实验证明了：只要合理优化（仔细调），这种方法可以在各种大小的模型上适用，获得有竞争力的（相对于 fine-tuning）性能，同时参数量还很小（可以称为 fine-tuning 的替代品）。

## 论文提供的关键元素、关键设计

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### 消融

#### Reparameterization

即 [[@2021PrefixTuningOptimizingContinuousLi#Reparameterization|prefix-tuning#Reparameterization]]

效果和数据集有关

#### Prompt Length

- 简单的分类任务：20 以下（较短）
- 困难的序列标注任务：100 左右（较长）

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

迷惑：好像是认为 [[@2021PrefixTuningOptimizingContinuousLi|prefix-tuning]] 的实验不对？然后做了个更好的实验，甚至性能惊人？

## 相关研究

%% 如何归类。值得关注的研究员 %%
