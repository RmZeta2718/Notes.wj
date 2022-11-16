---
aliases: ["Benchmarking Multimodal Regex Synthesis with Complex Structures", "Benchmarking Multimodal Regex Synthesis with Complex Structures, 2020"]
---
# Benchmarking Multimodal Regex Synthesis with Complex Structures

- **Journal**: Proceedings of the 58th Annual Meeting of the Association for Computational Linguistics
- **Author**: Xi Ye, Qiaochu Chen, Isil Dillig, Greg Durrett
- **Year**: 2020
- **URL**:
- [**Zotero**](zotero://select/items/@2020BenchmarkingMultimodalRegexYe)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4667343814701105153&noteId=750921023109431297)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

自然语言到 RE 的数据集不够复杂（RE），且规模较小。

## 论文的总体贡献

提供了新的数据集：Structured Regex，是 RE 和自然语言之间的对应关系。
- RE 结构更复杂
- 自然语言描述更多样
- 每个对应关系提供了多个正负匹配样例

## 论文提供的关键元素、关键设计

### 总体流程

1. 根据 Stack Overflow 的用户提问人工制定模板，表示用户关心的 RE 中的一些常见结构
2. 对模板随机采样得到 RE （structured probabilistic grammar），然后采样 RE 得到一些正负样本
3. 将 RE 转化为描述性的图像
4. 人工标注任务：根据 RE 的描述性图像以及对应的正负样本，写出 RE 的自然语言描述。

![fig1](https://pdf.cdn.readpaper.com/parsed/fetch_target/9432339abdc3e383518fe7bf68d89230_0_Figure_1.png)

### 基于 Structured Grammar 生成 RE

#### Domain Specific Language (DSL)

DSL 是一种和 RE 的表达能力等价的表达形式。采用 DSL 来表述的目的是提升可读性。

![tab7](https://pdf.cdn.readpaper.com/parsed/fetch_target/9432339abdc3e383518fe7bf68d89230_11_Table_7.png)

DSL 的例子：

![fig2](https://pdf.cdn.readpaper.com/parsed/fetch_target/9432339abdc3e383518fe7bf68d89230_1_Figure_2.png)

#### Structured Grammar 模板

基于 DSL 封装为模板。根据 Stack Overflow 上的用户提问，设计了三个模板 Intersection, Concatenation, and Separation

![fig3](https://pdf.cdn.readpaper.com/parsed/fetch_target/9432339abdc3e383518fe7bf68d89230_2_Figure_3.png)

约束条件：
- Intersection：不出现互相矛盾的条件
- 树的展开深度作者称为 semantic complexity，不超过 6。

> 实际上这里是对 DSL 的再次封装，和直接封装 pure RE 是等价的。论文中用 DSL 来描述是为了提升可读性，与方法本身无关。

#### 生成 RE

根据树结构随机生成。过程中动态调整概率，把已有的子树概率增大，这样新生成的节点就更有可能复用已有节点，形成重复的结构（循环结构）

#### 生成对应正负样本

- 正样本：随机遍历 RE 对应的 DFA。尽量走遍每个状态，以得到更好的区分度
- 负样本：扰动 RE，然后在新的（错误的）DFA 上采样正样本
    - 直接在原 DFA 上采样负样本的话，质量比较差（错误太明显）

每个 RE 生成了各 6 个正负样本，与 Stack Overflow 上用户的行为相似。

负样本采样扰动示意图：

![fig5](https://pdf.cdn.readpaper.com/parsed/fetch_target/9432339abdc3e383518fe7bf68d89230_3_Figure_5.png)

### RE 生成描述性图像

这一步的目的是在人工标注任务中尽可能少给文本形式的提示，以获得多样化的自然语言表示。

将 RE 画成一系列的 block，每个 block 会有内容/约束的文本描述（同一种约束在不同题目下会有不同的文本，如 have, contain）。

![fig6](https://pdf.cdn.readpaper.com/parsed/fetch_target/9432339abdc3e383518fe7bf68d89230_4_Figure_6.png)

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%

DSL：
- Neural generation of regular expressions from natural language with minimal domain knowledge, 2016
- Sketch-Driven Regular Expression Generation from Natural Language and Examples, 2019

### NL-TURK

Neural generation of regular expressions from natural language with minimal domain knowledge, 2016

类似的数据集

从类似 DSL 的规则中采样 RE。容易产生冲突或冗余，且比较简单。

### StackOverflow

Sketch-Driven Regular Expression Generation from Natural Language and Examples, 2019

根据 Stack Overflow 上的用户提问收集来的数据集，62 NL-RE 对
