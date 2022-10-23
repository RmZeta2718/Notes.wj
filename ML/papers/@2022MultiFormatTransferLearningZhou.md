---
aliases: ["A Multi-Format Transfer Learning Model for Event Argument Extraction via Variational Information Bottleneck", "A Multi-Format Transfer Learning Model for Event Argument Extraction via Variational Information Bottleneck, 2022"]
---
# A Multi-Format Transfer Learning Model for Event Argument Extraction via Variational Information Bottleneck

- **Journal**: Proceedings of the 29th International Conference on Computational Linguistics
- **Author**: Jie Zhou, Qi Zhang, Qin Chen, Qi Zhang, Liang He, Xuanjing Huang
- **Year**: 2022
- **URL**: https://aclanthology.org/2022.coling-1.173
- [**Zotero**](zotero://select/items/@2022zhouMultiFormatTransferLearninga)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?noteId=742217252582608896)

## 论文试图解决的问题（是否是新的问题）

**难度过高，暂时放弃**

Can we transfer the knowledge from the existing complex event extraction datasets with different formats?

深入挖掘数据集中的丰富的语义信息（不同event中的各个role可能存在知识的交叉）

有监督EE

顺带提升低资源性能

### 迁移EE知识的难点

- 不同数据集的格式不同
    - 即使是相同event，event type名字可能不同，包含的argument role可能不完全一致
- 不同数据集对同一对象的标注不同，导致噪声
    - 简单融合不同数据集会导致性能下降

## 论文的总体贡献

- a unified architecture that can learn both the format-shared and format-specific knowledge from various EE datasets
- 用VIB学习format-shared knowledge

## Methodology

> 论文提供的关键元素、关键设计


### 总体流程



### SSP

> Shared-Specific Prompt

capture both format-shared and format-specific knowledge

用BART作为event argument extractor：
- Encoder:
    - 在trigger前后添加标记 `<t> </t>`
    - 输入BART，得到事件的句子表示
        - $H_{encoder}=BART_{Encoder}(s)$
        - $H=BART_{Decoder}(s,H_{encoder})$
- Decoder:
    - 人工设计的prompt
    - $H_p=BART_{decoder}(p,H_{encoder})$

### VIB

> Variational Information Bottleneck

capture the format-shared representation

remove the format irrelevant information and retaining format invariable knowledge

## 实验（设置、数据集）

### 实现细节



### 数据集



### 评估



### 消融实验



## 有什么疑问，如何继续深入，如何吸取到你的工作中

Bert/BART怎么处理标点符号？特别是括号、引号这些可能会影响句子语义的标点符号。（受文中prompt中的括号启发）

## 相关研究（如何归类，值得关注的研究员）

- template
    - Document level event argument extraction by conditional generation, 2021
- SSP相关
    - BART: Denoising Sequence-to-Sequence Pre-training for Natural Language Generation, Translation, and Comprehension, 2020
- VIB相关
    - Specializing Word Embeddings (for Parsing) by Information Bottleneck, 2019
    - The information bottleneck method, 2000
IB的相关应用：
- word cluster
    - DISTRIBUTIONAL CLUSTERING OF ENGLISH WORDS, 1994
- dependent parsing
    - Variational Information Bottleneck for Effective Low-Resource Fine-Tuning, 2021
- summarization
    - BottleSum: Unsupervised and Self-supervised Sentence Summarization using the Information Bottleneck Principle, 2019
- interpretability
    - Attending via both Fine-tuning and Compressing

### [[pq]]

- However, these methods rely on a large-scale labeled dataset for training, which is **time-consuming** and **labor-intensive** due to the complexity of event extraction.