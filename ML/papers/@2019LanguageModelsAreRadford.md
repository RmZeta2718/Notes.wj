---
aliases: ["Language Models are Unsupervised Multitask Learners", "Language Models are Unsupervised Multitask Learners, 2019", "GPT2"]
---
# Language Models are Unsupervised Multitask Learners

- **Journal**:
- **Author**: Alec Radford, Jeffrey Wu, Rewon Child, David Luan, Dario Amodei, Ilya Sutskever
- **Year**: 2019
- **URL**:
- [**Zotero**](zotero://select/items/@2018LanguageModelsAreRadford)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=602044846737633280&from_extension=true&noteId=749484275667210240)
- [bilibili](https://www.bilibili.com/video/BV1AF411b7xQ/)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

zero-shot

### 现状

解码器被编码器打败了，于是尝试换更大的模型，用更大的数据集。但是实际情况并没有提升太多。所以将路线转向 zero-shot （这就是新意度 novelty）

### 动机

- 单目标学习的泛化性能交叉
- 多任务学习在 NLP 中的应用并不广泛（作者说的多任务学习和实际的可能有点不同）
    - 当时的典型代表是 [[@2018ImprovingLanguageUnderstandingRadford|GPT1]] 和 [[@2019BERTPretrainingDeepDevlin|BERT]] 的预训练+有监督精调的范式：
        - 需要对每个下游任务重新训练模型
        - 需要精调的数据

## 论文的总体贡献

## 论文提供的关键元素、关键设计

因为 zero-shot，不能在精调中加入未见过的 token，所以引入 prompt （translate to French, answer the question...)

为什么work：
- 足够大的模型可以学会根据prompt进行推理
- 足够大的数据集上本来就包含这种推理的结构（作者挑出了几个show-case，证明网上爬取的数据确实存在这种情况）

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

发现随着模型规模增加，性能持续上升，所以模型大小仍然有上升空间。

### 数据集

WebText（从Reddit上爬取的数据）

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

[[@2020LanguageModelsAreBrown|GPT3]] 进一步提升模型大小

## 相关研究

%% 如何归类。值得关注的研究员 %%

prompt 首先在这里提出：
- The Natural Language Decathlon: Multitask Learning as Question Answering, 2018

## [[pq]]

- Our speculation is that a language model with sufficient capacity will begin to learn to infer and perform the tasks demonstrated in natural language sequences in order to better predict them, regardless of their method of procurement.