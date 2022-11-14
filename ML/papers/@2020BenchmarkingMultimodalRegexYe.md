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

提供了新的数据集：Structured Regex，是 RE 和自然语言之间的对应关系。
- RE 结构更复杂
- 自然语言描述更多样
- 每个对应关系提供了多个正负匹配样例

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### 总体流程

#### 正负样本生成

- 正样本：随机遍历 RE 对应的 DFA。尽量走遍每个状态，以得到更好的区分度
- 负样本：扰动 DFA，然后在新的（错误的）DFA 上采样正样本
    - 直接在原 DFA 上采样负样本的话，质量比较差（错误太明显）

每个 RE 生成了各 6 个正负样本，与 Stack Overflow 上用户的行为相似。

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
