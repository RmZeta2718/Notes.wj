---
aliases: ["Zero-shot Label-Aware Event Trigger and Argument Classification", "Zero-shot Label-Aware Event Trigger and Argument Classification, 2021"]
---
# Zero-shot Label-Aware Event Trigger and Argument Classification

- **Journal**: Findings of the Association for Computational Linguistics: ACL-IJCNLP 2021
- **Author**: Hongming Zhang, Haoyu Wang, Dan Roth
- **Year**: 2021
- **URL**: 
- [**Zotero**](zotero://select/items/@2021zhangZeroshotLabelAwareEvent)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=628131137469050880&noteId=740758152104022016)

## 论文试图解决的问题（是否是新的问题）

事件抽取中的分类子任务（假设已经正确识别出event和argument）

## 论文的总体贡献

不仅仅用label，还将label嵌入外部语料中，获得包含上下文信息的表示（[[#contextualized representations]]）

## 论文提供的关键元素、关键设计

### 总体流程

分为两个步骤：preparation and prediction
1. preparation: generate the representations for all pre-defined event types and argument roles
    1. for each type, select the label word (and its synonyms) as the anchor words
        - trigger的词性通常是verb，而通常一个词又有很多不同意思，所以引入同义词来提升准确性
    2. retrieve a list of anchor sentences that use these words from an external corpus
    3. acquire embeddings of anchor words ([[#contextualized representations]]): apply the pre-trained language models to encode all anchor sentences
    4. type representation: the cluster of these embeddings
        - 这里其实是分类而不是聚类，因为是有标签的
2. prediction:
    1. acquire embeddings of the triggers and arguments ([[#contextualized representations]])
    2. map them to the most similar types in the embedding space (cosine distance to cluster center)
    3. regularize the prediction by modeling it as an ILP problem, leverage constraints provided by the event definitions, including:
        1. One type per trigger.
        2. One type per argument.
        3. Different arguments in one event must have different types.
        4. Predicted trigger and argument type must appear in the ontology .
        5. Entity types of arguments match the requirements.

2.3 的优化目标：

$$
\underset{I_{t}, I_{a}}{\operatorname{argmax}} \sum_{j \in|\mathcal{A}|}\left(\sum_{i \in|\mathcal{E}|} f\left(t, E_{i}\right) \cdot I_{t}(i) \cdot \lambda+\sum_{k \in|\mathcal{R}|} f\left(a_{j}, R_{k}\right) \cdot I_{a}(j, k)\right)
$$

### contextualized representations

- 对于trigger：contextualized representations without mask
    - 把包含trigger的句子直接输入Bert，得到表示
    - motivation：trigger（通常是动词）包含了最重要的语义信息
- 对于argument：contextualized representations with mask
    - 把anchor mask之后再输入Bert
    - motivation：argument（通常是名词、介词）的语义信息通常根据上下文推断

tokenizer 有可能将一个anchor拆分成多个token，最终结果取平均值~~（论文公式3的分母忘了+1）~~

## 实验（设置、数据集）

### 实现细节

- 对于步骤1.2：107 anchor words for 33 event trigger types and 22 anchor words for 22 event argument types
- 1.3: 对于每个anchor，从NYT （The New York Times Annotated Corpus, 2008）中随机选取10个句子

### 数据集

[[事件抽取#ACE-2005]]

由于是zero-shot，所以不需要数据集提供的切分，train/dev/test都融合在一起作为test


### 评估

两种评估方式：
1. 只评估least 23 frequent event types and associated role types
    - 为了和以前的工作（[[@2018ZeroShotTransferLearningHuang|Zero-shot transfer learning for event extraction, 2018]]）对比，这个工作用most 10 frequent type来训练，然后用其他的测试
2. 在所有33个事件类型上测试，用以验证整体性能

Hit@1, Hit@3, Hit@5

所有实验结果取5次平均

### 消融实验

#### context

只把anchor输入到Bert中，而不输入上下文（对于argument，mask也一并去掉，即输入原token）

结果只比原baseline略高（应该是Bert的贡献），显著低于带有上下文信息的表示

#### Bert

Bert-large改成Bert-base，结果82.9-55.7（-27.2）：语言模型的影响非常大

#### trigger与argument的相对权重

即 $\lambda$ 。paper发现在引入ILP之前，模型在trigger上做得很好，而在argument上做得较差，因此认为优先以trigger为目标。（为什么？）

## 有什么疑问，如何继续深入，如何吸取到你的工作中

这算zero-shot吗（需要初始化cluster）

如果实验有多种可调选项，而根据结果最终选择了某一种。那么这些其他选项写在实验章节中还是前面介绍中。（例如本文的w or w/o mask，最终选择了trigger w & argument w/o）

Bert到底embedding了什么东西，本文似乎表明，argument type word的上下文与argument word本身的embedding距离较近

## 相关研究（如何归类，值得关注的研究员）

Specifically, we formulate the final inference step as an integer linear programming (ILP) （A Linear Programming Formulation for Global Inference in Natural Language Tasks, 2004）

- WSD-embedding & Transfer Learning （[[@2018ZeroShotTransferLearningHuang|Zero-shot transfer learning for event extraction, 2018]]）
- 

identification pipeline 中用到的工具:
- SRL (Simple BERT Models for Relation Extraction and Semantic Role Labeling, 2019)

### [[pq]]

- This paper shows that the whole event extraction pipeline (i.e., identification and classification) can be done without any event-specific annotation
- Such large-scale and high-quality annotation requires significant expertise, and it facilitates the success of supervised learning models. However, scaling these efforts to new domains and more event types is very costly and unrealistic.
