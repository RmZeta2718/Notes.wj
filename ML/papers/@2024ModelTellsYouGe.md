---
aliases:
  - "Model Tells You What to Discard: Adaptive KV Cache Compression for LLMs"
  - "Model Tells You What to Discard: Adaptive KV Cache Compression for LLMs, 2024"
  - FastGen
---
# Model Tells You What to Discard: Adaptive KV Cache Compression for LLMs

- **Journal**: arxiv:2310.01801 #ICLR/24 outstanding paper
- **Author**: Suyu Ge, Yunan Zhang, Liyuan Liu, Minjia Zhang, Jiawei Han, Jianfeng Gao
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2310.01801
- [**Zotero**](zotero://select/items/@2024ModelTellsYouGe)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4807191216051453953&noteId=2310290808928133120)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

- LLM推理时的显存占用问题
- kv-cache驱逐策略

[LLM profiling guides KV cache optimization - Microsoft Research](https://www.microsoft.com/en-us/research/blog/llm-profiling-guides-kv-cache-optimization/)

## 论文的总体贡献

kv-cache压缩方法：FastGen
- 不同head的pattern不同
- pattern随context长度基本不变

> kv-cache 从列的方向考虑，熵从行的角度考虑

## 论文提供的关键元素、关键设计

### 总体流程

将kv-cache分为如下几类：

1. Special Tokens： `<s>` `[INST]` 等
2. Punctuation：标点符号
3. Frequency ([[@2023_2HeavyHitterOracleZhang|Heavy Hitter]])：通过 $r_{f}=0.3$ 控制比例
4. Locality：附近的token，通过 $r_l=0.3$ 控制比例
5. 其他token

- prefill阶段：每个head按上述顺序添加kv-cache，直到满足 $\left|\boldsymbol{A}-\operatorname{softmax}\left(\boldsymbol{Q} \boldsymbol{K}_{\boldsymbol{C}}^{T}\right)\right| \leq 1-T$。通过recover ratio $T$ 控制kv-cache的筛选策略。
- 生成阶段：每个head根据先前得到的筛选策略控制kv-cache

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/7ba1071f0854a5c57d4e4afc80fcf3c4_1_Figure_1_570703591.png)

不同类别kv-cache的组合情况有 $2^n$ 种，论文采用了Naive Strategy Combination，规定了顺序，降低到 $n$ 种情况。且策略组合是单调的，因此选择是唯一的。

> 实际上可以根据attention map做更细致的筛选？考虑kv-cache是否保留的矩阵的形状：每一列上半部分True，下半部分False，因此整个矩阵包含n个决策位置（分界点）。


## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%

[如何度量数据的稀疏程度？ - 科学空间|Scientific Spaces (kexue.fm)](https://kexue.fm/archives/9595)****
