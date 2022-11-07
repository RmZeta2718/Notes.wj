---
aliases: ["Improving Language Understanding by Generative Pre-Training", "Improving Language Understanding by Generative Pre-Training, 2018", "GPT1"]
---
# Improving Language Understanding by Generative Pre-Training

- **Journal**:
- **Author**: Alec Radford, Karthik Narasimhan, Tim Salimans, Ilya Sutskever
- **Year**: 2018
- **URL**:
- [**Zotero**](zotero://select/items/@2018ImprovingLanguageUnderstandingRadford)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=602045241721716736&from_extension=true&noteId=748738884022587392)
- [bilibili](https://www.bilibili.com/video/BV1AF411b7xQ/)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

从文本中抽取信息是困难的，因为：
- NLP 的优化目标不统一，没有哪个的效果明显优于其他的，而是需要根据任务设计。
- 从一个任务上学习的表示很难迁移到其他任务。

## 论文的总体贡献

提出一种[[深度学习笔记#自监督]]的方法，在无标注数据上训练大规模语言模型，然后在子任务上微调。

## 论文提供的关键元素、关键设计

### 模型结构

基于 [[@2017AttentionAllYouVaswani|Transformer]] ，而不是 RNN：作者认为 [[@2017AttentionAllYouVaswani|Transformer]] 比 RNN 学习到的结构信息更稳健，抽取出更多的句子、段落层面的语义信息

12 层解码器，隐层大小 768 维

### 预训练

$\mathcal{U}$ 是无监督语料库中的一个序列

k-gram 语言模型（应该是吧？）：根据 $\mathcal{U}$ 的前 $k$ 个词，预测下一个词（计算下一个词的 logit）
$$
L_{1}(\mathcal{U})=\sum_{i} \log P\left(u_{i} \mid u_{i-k}, \ldots, u_{i-1} ; \Theta\right)
$$
其中， $P\left(u_{i} \mid u_{i-k}, \ldots, u_{i-1} ; \Theta\right)$ 是最后一层+线性+softmax 得到的

由于只能看到前面的，所以类似于 [[@2017AttentionAllYouVaswani|Transformer]] 的解码器

### 微调

$\mathcal{C}$ 是有标注的序列，对应 label $y$ （需要将下游任务转换成这种形式，需要引入一些标记 token）
$$
L_{2}(\mathcal{C})=\sum_{(x, y)} \log P\left(y \mid x^{1}, \ldots, x^{m}\right)
$$
论文认为将语言模型作为辅助的目标有助于提升性能，即
$$
L_{3}(\mathcal{C})=L_{2}(\mathcal{C})+\lambda * L_{1}(\mathcal{C})
$$
> 标记 token 如 start 等，在预训练中没见过，需要通过微调来训练

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### 数据集

BooksCorpus
- 7000 本书

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

[[@2019BERTPretrainingDeepDevlin|BERT]]：数据集约 4 倍，模型大小约 3 倍。编码器更简单，所以效果更好

## 相关研究
