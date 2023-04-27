---
aliases: ["Longformer: The Long-Document Transformer", "Longformer: The Long-Document Transformer, 2020", "Longformer"]
---
# Longformer: The Long-Document [[@2017AttentionAllYouVaswani|Transformer]]

- **Journal**: arXiv:2004.05150
- **Author**: Iz Beltagy, Matthew E. Peters, Arman Cohan
- **Year**: 2020
- **URL**:
- [**Zotero**](zotero://select/items/@2020LongformerLongDocumentTransformerBeltagy)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4500345191331946498&noteId=1744650709602988800)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

长序列问题：
- 计算和内存开销平方增长
- 其中内存开销比较显著，而计算开销可以忽略不计

两种解决方案
1. left-to-right (ltr) approach: processes the document in chunks moving from left-to-right
    - potentially result in loss of important cross-partition information
2. sparse attention: defines some form of sparse attention pattern and avoids computing the full quadratic attention matrix multiplication

## 论文的总体贡献

- sparse attention: window based local-context self-attention and an end task motivated global attention that encodes inductive bias about the task.
    - custom CUDA kernel
- 基于 Encoder 的 Longformer，在 text classification, QA, coreference resolution 上验证了有效性
- 基于 Encoder-Decoder 的 LED，在 summarization 上验证了有效性

## 论文提供的关键元素、关键设计

### Sparse Attention

- Sliding Window: the importance of local context
    - use different window size for each layer
- Dilated Sliding Window: increase the receptive field without increasing computation
    - different dilation configurations per head
- Global Attention: end task motivated, encodes inductive bias about the task.
    - Importantly, we make this attention operation symmetric
- Linear Projections for Global Attention: additional projections provide flexibility to model the different types of attention

![fig 2](https://pdf.cdn.readpaper.com/parsed/fetch_target/2a0e4527d840912fd8df82856964b128_2_Figure_2.png)

Implementation:
- Longformer-loop: computes each diagonal separately in a loop
    - only computes the non-zero values, but it is unusably slow.
    - use it for testing because it is easy to implement but don't use it to run experiments.
- Longformer-chunks: chunks Q and K into overlapping blocks of size $w$ and overlap of size $\frac 1 2 w$ , multiplies the blocks, then mask out the diagonals.
    - consumes 2x the amount of memory
    - only supports the nondilated case
- Longformer-cuda: a custom CUDA kernel that we implement using TVM (Tensor Virtual Machine, a deep learning compiler)
    - should be faster than the $n^2$ computation theoretically, but requires special knowledge of low-level GPU programming, similar to implementing a highly optimized matrix multiplication.

![fig 1](https://pdf.cdn.readpaper.com/parsed/fetch_target/2a0e4527d840912fd8df82856964b128_0_Figure_1.png)

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### Character-level Autoregressive Language Modeling

#### Settings

- window size: balance between efficiency and performance
    - small window sizes for the lower layers and increase window sizes as we move to higher layers
- dilated sliding windows:
    - For lower layers, do not use dilated sliding windows: maximize their capacity to learn local context
    - For the higher layers, use a small amount of increasing dilation only on 2 heads.
- Staged training procedure: on each phase, double the window size and the sequence length, and halve the learning rate.
    - The model needs a large number of gradient updates to learn the local context first, before learning to utilize longer context
- Dataset: text8, enwik8

![tab 12](https://pdf.cdn.readpaper.com/parsed/fetch_target/2a0e4527d840912fd8df82856964b128_14_Table_12.png)

#### Evaluation

> Follow Transformer-XL

metric: BPC (bit per character)

split the dataset into overlapping sequences of size 32,256 with a step of size 512, and report the performance on the last 512 tokens on the sequence.

#### Ablation

![tab4](https://pdf.cdn.readpaper.com/parsed/fetch_target/2a0e4527d840912fd8df82856964b128_5_Table_4.png)

- dilation 基本没什么用

### Finetuning

#### Further Pretraining

- continue MLM pretraining from the RoBERTa
- Attention Pattern:
    - window size: 512 (same amount of computation as RoBERTa)
    - dilation hurt performance: not compatible with the pretrained RoBERTa weights
- Position Embeddings: leverage RoBERTa's pretrained weights
    - copy the 512 position embeddings from RoBERTa multiple times, support up to position 4096

#### Question answering

**WikiHop**: a question, answer candidates (2~79 candidates), supporting contexts (3~63 paragraphs)

```text
[q] question [/q] [ent] candidate1 [/ent] ... [ent] candidateN [/ent]
</s> context1 </s> ... </s> contextM </s>
```

- take the question and answer candidates and concatenate them to as much context as possible up to the model sequence length, run the sequence through the model, collect the output activations, and repeat until all of the context is exhausted
- global attention on the entire question and answer candidate sequence.
- For prediction, we attach a linear layer to each `[ent]` that outputs a single logit, average over all logits for each candidate across the chunks, apply a softmax and use the cross entropy loss with the correct answer candidate.

**TriviaQA**: 100K question, answer, document triplets. Documents are Wikipedia articles, and answers are named entities mentioned in the article.

```text
[s] question [/s] document [/s]
```

- truncate the document at 4096 wordpiece to avoid it being very slow
- global attention on all question tokens
- add one layer that predicts the beginning and end of the answer span

**HotpotQA**: answering questions from a set of 10 paragraphs from 10 different Wikipedia articles where 2 paragraphs are relevant to the question and the rest are distractors.

```text
[CLS] [q] question [/q] <t> title1 </t> sent1,1 [s] sent1,2 [s] ... <t> title2 </t> sent2,1 [s] sent2,2[s] ...
```

two-stage Longformer model with similar setup that first identifies relevant paragraphs and then does find the final answer span and evidence

#### Text classification

- IMDB: sentiment classification datasets consisting of movie reviews (only 13.6% of them are larger than 512 wordpieces)
- Hyperpartisan news detection: 645 long documents

- binary cross entropy loss on top of a first `[CLS]` token
- addition of global attention to `[CLS]`

#### Ablations on WikiHop

![tab10](https://pdf.cdn.readpaper.com/parsed/fetch_target/2a0e4527d840912fd8df82856964b128_8_Table_10.png)

- performance gains are not due to additional pretraining

### Longformer-Encoder-Decoder (LED)

- Encoder: Longformer local+global attention
    - window size 1024, global attention on the first `<s>` token
- Decoder: full self-attention and cross-attention
- initialize LED parameters from the BART
- Position Embeddings: leverage BART's pretrained weights
    - copy the 1K position embeddings from BART multiple times, support up to position 16K

#### Summarization

- Training: teacher forcing on gold training summaries
- Inference: beam search

- arXiv summarization dataset: summarization in the scientific domain
    - 90th percentile of document lengths is 14.5K tokens

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%

## [[pq]]

- Autoregressive or left-to-right language modeling is loosely defined as estimating the probability distribution of an existing token/character given its previous tokens/characters in an input sequence.
