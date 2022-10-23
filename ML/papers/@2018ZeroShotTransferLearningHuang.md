---
aliases: ["Zero-Shot Transfer Learning for Event Extraction", "Zero-Shot Transfer Learning for Event Extraction, 2018"]
---
# Zero-Shot Transfer Learning for Event Extraction

- **Journal**: Proceedings of the 56th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers)
- **Author**: Lifu Huang, Heng Ji, Kyunghyun Cho, Ido Dagan, Sebastian Riedel, Clare Voss
- **Year**: 2018
- **URL**: 
- [**Zotero**](zotero://select/items/@2018huangZeroShotTransferLearning)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4558007594032046081&noteId=740512291097288704)

## 论文试图解决的问题（是否是新的问题）

transfer resources from existing types to new types without any additional annotation effort

## 论文的总体贡献

融合了各种方法，主要是AMR和CNN，我没了解过AMR，所以没看懂

## 论文提供的关键元素、关键设计

### 总体流程

- 学习阶段：
    - 将AMR关系表示为矩阵形式
    - 过CNN
- 预测阶段（unseen事件）：
    - 用type和argument role组成的tuple表达语义（eg. 〈Transport Person, Destination〉）
    - 过CNN
    - 找到学习阶段中距离最近的结构

## 实验（设置、数据集）

### 实现细节



### 数据集



### 评估



### 消融实验



## 有什么疑问，如何继续深入，如何吸取到你的工作中



## 相关研究（如何归类，值得关注的研究员）

- The Syntax of Event Structure, 1991
    - the semantics of an event structure can be generalized and mapped to event mention structures in a systematic and predictable way
- Abstract Meaning Representation (AMR)
    - Abstract Meaning Representation for Sembanking, 2013
    - A Transition-based Algorithm for AMR Parsing, 2015
- Entity Relation Event (ERE)
    - From Light to Rich ERE: Annotation of Entities, Relations, and Events, 2015
