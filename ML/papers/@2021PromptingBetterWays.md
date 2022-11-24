---
aliases: ["Prompting: Better Ways of Using Language Models for NLP Tasks", "Prompting: Better Ways of Using Language Models for NLP Tasks, 2021"]
---
# Prompting: Better Ways of Using Language Models for NLP Tasks

- Blog
- **Author**: Tianyu Gao
- **Year**: 2021
- **URL**: https://gaotianyu.xyz/prompting/
- [**Zotero**](zotero://select/items/@2021PromptingBetterWays)

## 本文大致内容

Prompting 方法在 NLP 中的最新应用的概述，以及介绍作者的论文 LM-BFF

### Discrete prompts

- 最早的应用： [[@2019LanguageModelsAreRadford|GPT2]]，只要合理设置 prompt，可以得到不错的 zero-shot 性能
- 之后，一些研究关注如何从 LM 中挖掘事实或常识（mine factual or commonsense knowledge）
    - Language Models as Knowledge Bases?, 2019
    - Commonsense Knowledge Mining from Pretrained Models, 2019
    - How Can We Know What Language Models Know?, 2020
    - oLMpics -- On what Language Model Pre-training Captures, 2020
- [[@2020LanguageModelsAreBrown|GPT3]] 提出了固定模型参数，基于 prompt 的 few-shot 方案
- 试图在小模型上应用 prompt，于是可以调整模型参数
    - Exploiting Cloze Questions for Few Shot Text Classification and Natural Language Inference, 2021
    - Making Pre-trained Language Models Better Few-shot Learners, 2021
- 用基于梯度的搜索来寻找任务上最佳的 prompt
    - AutoPrompt: Eliciting Knowledge from Language Models with Automatically Generated Prompts, 2020

### Soft prompts

不能调整模型参数的情况下（例如 probing tasks，训练通用模型，[[@2020LanguageModelsAreBrown|GPT3]] 等超大模型），soft prompt 很好用。在 few-shot 场景下比 fine tune 整个模型更好，但是性能仍然不高。

相关研究：
- 在输入序列汇总用随机向量来 prompt，而不受限于词表中的特定词表示，然后 fine-tune 这些随机向量，保持模型固定。用以做 probing 的任务
    - [[@2021FactualProbingMASKZhong|Factual Probing Is [MASK]: Learning vs. Learning to Recall, 2021]]
    - Learning How to Ask: Querying LMs with Mixtures of Soft Prompts, 2021
- 将 Soft prompt 应用到生成式任务上，展示了只用调整 0.1\% 的参数就能得到一样好的效果
    - [[@2021PrefixTuningOptimizingContinuousLi|Prefix-Tuning: Optimizing Continuous Prompts for Generation, 2021]]
    - [[@2021PowerScaleParameterEfficientLester|The Power of Scale for Parameter-Efficient Prompt Tuning, 2021]]
        - 一些关键选择：
            - 从词嵌入初始化
            - soft prompt token 的数量
            - 对齐的（aligned）预训练目标
        - 发现 soft prompt 带来更好地迁移性能（相比 fine tune）
- 与人工模板结合，用于关系抽取 RE
    - PTR: Prompt Tuning with Rules for Text Classification, 2021

### In-context learning

[[@2020LanguageModelsAreBrown|GPT3]]：在 prompt 中加入样例。由于 self-attention 机制允许在上下文中寻找联系，所以这种方法出乎意料地 work。论文称之为

### LM-BFF

https://github.com/princeton-nlp/lm-bff

## [[pq]]

- In all those models, prompts are in natural language and are composed of discrete tokens from the vocabulary. Most of the work takes manually-designed prompts—prompt engineering is non-trivial since a small perturbation can significantly affect the model’s performance, and creating a perfect prompt requires both understanding of LMs' inner workings and trial-and-error.
