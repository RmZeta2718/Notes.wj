---
aliases: ["Simple Local Attentions Remain Competitive for Long-Context Tasks", "Simple Local Attentions Remain Competitive for Long-Context Tasks, 2022"]
---
# Simple Local Attentions Remain Competitive for Long-Context Tasks

- **Journal**: arxiv:2112.07210 #NAACL/22
- **Author**: Wenhan Xiong, Barlas Oğuz, Anchit Gupta, Xilun Chen, Diana Liskovich, Omer Levy, Wen-tau Yih, Yashar Mehdad
- **Year**: 2022
- **URL**: http://arxiv.org/abs/2112.07210
- [**Zotero**](zotero://select/items/@2022SimpleLocalAttentionsXiong)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4665137602152644609&noteId=1805519848354949888)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

高效 transformer 之间缺乏公平对比（同[[@2020LongRangeArenaTay|LRA]]）

## 论文的总体贡献

- [[@2020LongRangeArenaTay|LRA]]不够好。在[[@2020LongRangeArenaTay|LRA]]上可以达到接近性能的模型，在更大规模的预训练和下游任务上差异巨大
- 在类似的预训练计算量下，其他 attention 范式和简单的 attention 差别不大
- 在 long-doc QA 上获得了一个和 [[@2020LongformerLongDocumentTransformerBeltagy|Longformer]] 性能接近的模型但是快 2 倍

## 论文提供的关键元素、关键设计

### 总体流程

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### [[@2020LongRangeArenaTay|LRA]] 实验

- 两层 transformer encoder
- 在 `[cls]` token 上加分类器层

[[@2020LongRangeArenaTay|LRA]] 的问题:
- 没有预训练，与当前的 NLP 范式差异较大，因此无法释放全部性能。
- 字符级任务而不是 BPE 影响性能。
- 模型大小和实际使用的模型差异较大。
- 设置的超参数不是最优的，调参能提升性能。
- 和真实的下游任务性能有偏差。

### 预训练与下游任务

由于不是所有模型都能复用 RoBERTa ，为了公平对比，所有模型重新预训练。

预训练数据集 follow [[@2020LongformerLongDocumentTransformerBeltagy|Longformer]] ：Stories、RealNews、Books corpus、English Wikipedia

序列长度 4096，batch size 256，100k steps。计算资源32 x A100 x 2days

下游任务是包含长文本的实际任务：
- 抽取式QA：TriviaQA
- 分类：Hyperpartisan
- 检索：根据另一篇paper（Latent retrieval for weakly supervised open domain question answering）的方法构造了数据

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
