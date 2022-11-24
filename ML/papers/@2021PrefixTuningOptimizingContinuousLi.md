---
aliases: ["Prefix-Tuning: Optimizing Continuous Prompts for Generation", "Prefix-Tuning: Optimizing Continuous Prompts for Generation, 2021", "Prefix-Tuning"]
---
# Prefix-Tuning: Optimizing Continuous Prompts for Generation

- **Journal**: Proceedings of the 59th Annual Meeting of the Association for Computational Linguistics and the 11th International Joint Conference on Natural Language Processing (Volume 1: Long Papers)
- **Author**: Xiang Lisa Li, Percy Liang
- **Year**: 2021
- **URL**:
- [**Zotero**](zotero://select/items/@2021PrefixTuningOptimizingContinuousLi)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4498415942576529409&noteId=753212213146570752)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

pre-train + fine tune 模式需要调整个模型，存储效率低。

## 论文的总体贡献

提出 prefix-tuning，一种 soft prompt 方法，面向自然语言生成任务（natural language generation, NLG）

优势：
- few-shot 场景下效果更好
- 可以用于迁移学习
- 足够轻量，甚至可以应用于用户（隐私）相关的场景（每个用户有独立的 prefix）
- 同一个 batch 里可以执行不同任务
- 表达能力更强（expressiveness）

## 论文提供的关键元素、关键设计

### 总体流程

加入 soft prompt 作为 prefix，调 prefix 的 embedding 以及 hidden state

### Reparameterization

作者认为直接调 prefix 会不稳定，所以做了 reparameterization，即加一个 MLP，从 $k$ 维映射到 $\dim(h_i)$ 维。
$$
P_\theta[i, : ] = MLP_\theta(P'_\theta[i,: ])
$$

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### 消融

#### prefix 长度

![fig4](https://pdf.cdn.readpaper.com/parsed/fetch_target/ee30e4faaa04f67945538716db84d921_7_Figure_4.png)

- table-to-text：10
- summarization：200

更长能使训练误差下降，但是测试误差会上升，意味着这里存在过拟合。（论文 comment14）

#### 是否调隐藏层 prefix

![tab4](https://pdf.cdn.readpaper.com/parsed/fetch_target/ee30e4faaa04f67945538716db84d921_7_Table_4.png)

只调输入层 prefix（embedding-only）：
- 对学习率和初始化敏感
- 性能显著下降

> 但是 [[@2021PowerScaleParameterEfficientLester|prompt-tuning]] 证明 embedding-only 也是可行的

论文指出 embedding-only 是 discrete prompt 的上界（约束更少），而 prefix-tuning（即包含隐藏层）比 embedding-only 的表达能力更强（参数更多）。

所以得出结论，从表达能力（expressive power）来看：discrete prompting < embedding-only ablation < prefix-tuning

#### Prefixing vs Infixing

即： $[PREFIX; x; y]$ vs $[x; INFIX; y]$

prefix 更好。合理的解释是：INFIX 影响不到 $x$

#### Initialization

![fig5](https://pdf.cdn.readpaper.com/parsed/fetch_target/ee30e4faaa04f67945538716db84d921_7_Figure_5.png)

初始化会有较大影响，特别是对 few-shot 场景。
- 随机初始化：性能较差、方差较大
- 真实单词初始化：效果不错
- 任务相关单词初始化：略好于其他单词

这一点与“尽可能保留 PLM 的信息”的想法保持一致

TODO: more（隐层初始化？）

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

[[@2021PowerScaleParameterEfficientLester|prompt-tuning]]：不含隐藏层 prefix

low-data setting 和 few-shot 有区别吗？

## 相关研究

%% 如何归类。值得关注的研究员 %%
