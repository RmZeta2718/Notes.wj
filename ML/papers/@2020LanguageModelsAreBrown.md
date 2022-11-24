---
aliases: ["Language Models are Few-Shot Learners", "Language Models are Few-Shot Learners, 2020", "GPT3"]
---
# Language Models are Few-Shot Learners

- **Journal**: Advances in Neural Information Processing Systems
- **Author**: Tom Brown, Benjamin Mann, Nick Ryder, Melanie Subbiah, Jared D Kaplan, Prafulla Dhariwal, Arvind Neelakantan, Pranav Shyam, Girish Sastry, Amanda Askell, Sandhini Agarwal, Ariel Herbert-Voss, Gretchen Krueger, Tom Henighan, Rewon Child, Aditya Ramesh, Daniel Ziegler, Jeffrey Wu, Clemens Winter, Chris Hesse, Mark Chen, Eric Sigler, Mateusz Litwin, Scott Gray, Benjamin Chess, Jack Clark, Christopher Berner, Sam McCandlish, Alec Radford, Ilya Sutskever, Dario Amodei
- **Year**: 2020
- **URL**: https://papers.nips.cc/paper/2020/hash/1457c0d6bfcb4967418bfb8ac142f64a-Abstract.html
- [**Zotero**](zotero://select/items/@2020LanguageModelsAreBrown)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4545166049246076929&from_extension=true&noteId=749511897306398720)
- [bilibili](https://www.bilibili.com/video/BV1AF411b7xQ/)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

### 现状

- 预训练+精调的范式需要针对每个任务整理数据集，精调

### 动机

[[@2019LanguageModelsAreRadford|GPT2]] 的性能不够好。于是退而求其次，不追求 zero-shot 的性能，转而尝试 few-shot。

## 论文的总体贡献

训练了一个 1750 亿参数量的模型。对于下游任务，不做微调，不更新梯度。

能够生成逼真的文本

提出概念：
- meta learning（和原来的这个词的含义不太一样）：在阅读了足够多的无监督文本之后，语言模型可以具有一定的模式识别的能力，即训练出一个真的具有很强泛化性能的模型，而不依赖后续微调
- in-context learning：不依赖于更新模型，在 prompt 的上下文里进行学习。

## 论文提供的关键元素、关键设计

### 讨论

局限性：
- GPT在生成长文本（如小说）任务上还不太行，可能会逐渐失去上下文信息。
- 单向模型
- 仅学习了文本数据，没有多模态信息
- 预训练效率很低，远低于人类学习效率
- 到底是从few-shot中学到了知识还是记住了训练样本？
- 不可解释。模型太大，几乎无法探查


## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### 评估

- few-shot learning，或者叫 in-context learning：可以在上下文窗口（通常是 10 到 100）里放尽可能多的例子。
- one-shot learning：允许一个例子
- zero-shot learning：没有例子，只有用自然语言陈述的指令

### 其他结论

- Figure 3.1：大模型所需的计算量与性能（损失）之间呈幂律关系

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

李沐：few-shot 的缺点：
- 如果有很多训练数据怎么办？并不能全部放进 prompt 里
- 训练样本每次都需要作为prompt输入，没有办法保存
- LM-BFF：输入长度是有限的，训练数据很多怎么办？

- 如果是背下来的，怎么让大模型回忆起这些数据？in-context是唯一的做法吗？
- in-context learning到底学了还是没学？
- 

给不同的few-shot example，虽然性能比zero-shot大幅提升，但是鲁棒性和稳定性很差。

## 相关研究

%% 如何归类。值得关注的研究员 %%
