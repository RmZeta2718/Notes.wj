---
aliases: ["The Power of Scale for Parameter-Efficient Prompt Tuning", "The Power of Scale for Parameter-Efficient Prompt Tuning, 2021", "Prompt-Tuning"]
---
# The Power of Scale for Parameter-Efficient Prompt Tuning

- **Journal**: Proceedings of the 2021 Conference on Empirical Methods in Natural Language Processing
- **Author**: Brian Lester, Rami Al-Rfou, Noah Constant
- **Year**: 2021
- **URL**:
- [**Zotero**](zotero://select/items/@2021PowerScaleParameterEfficientLester)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4545287059073032193&noteId=753212733961265152)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

提出 prompt-tuning：拼一段 soft prompt 在输入前面

## 论文提供的关键元素、关键设计

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### 数据集

SuperGLUE

### 消融

![fig3](https://pdf.cdn.readpaper.com/parsed/fetch_target/5b874770c2cff16044ee9a2b638bed40_4_Figure_3.png)

图中绿色线是标准设置

#### Prompt Length

- 超过 20 带来的收益就比较小了。
- 即使只有 1 个 prompt，大模型下仍有较好的表现，意味着大模型可以减少 prompt 参数量

#### Prompt Initialization

- 随机初始化：$[-0.5,0.5]$ 内均匀采样
- 词表初始化：选择最常见的 5000 个单词
- 任务标签（class label）初始化：把任务的 label 拼在一起。如果有多 token 的 label，取均值。如果 label 不够，后面剩下的 fall back 到词表初始化。

findings：
- 模型足够大之后，不同初始化不再产生性能差异
- class label 初始化的训练结果倾向于保持原地不动，即余弦相似度最大的词仍然是初始化的词。而其他初始化没有发现显著的可解释性规律。

#### Pre-training Objective

T5 模型的三种设置：
- Span Corruption：直接用 T5。由于 T5 从来没有见过真实文本，所有预训练任务都包含哨兵词（sentinel tokens），所以直接 prompt-tuning 效果不会好，因为 decoder 的先验是不能调整的。而原来的 fine-tune 方式则可以比较好地适应这种 sentinel tokens。
- Span Corruption + Sentinel：所有下游任务的目标前加 sentinel，作为一种 workaround，效果仍然不好
- LM Adaptation：在原 T5 模型上用 LM 目标额外训练几轮（100K），即根据自然语言 prefix 作为输入，输出后续文本。这种训练只会进行一次，然后就作为基础模型固定住，在所有下游任务上共享。
    - 希望通过这种方式让 T5 快速转变为 [[@2020LanguageModelsAreBrown|GPT3]]

findings：
- 总体上 LM Adaptation 更好，但是模型足够大之后（T5-XXL），差异消失
- span corruption 随模型大小是不稳定的。小模型稳定地性能表现较差，甚至出现 0%。

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%

[[@2021PrefixTuningOptimizingContinuousLi|prefix-tuning]]：本文相当于其简化版本，对比：
- 基础模型：
    - prefix：[[@2019LanguageModelsAreRadford|GPT2]]，BART
    - prompt：T5
- prefix：在BART的decoder前也加了prefix。prompt：只在encoder前加prompt
- prefix：用了一个线性变换来增强参数的稳定性。prompt：不需要。

WARP（WARP: Word-level Adversarial ReProgramming, 2021）：依赖于mask，只能做分类任务

## [[pq]]

- An ideally interpretable prompt would consist of natural language that clearly describes the task at hand, explicitly asks the model for some result or action, and makes it easy to understand why the prompt elicited such behavior from the model.