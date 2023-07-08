---
aliases: ["Train Short, Test Long: Attention with Linear Biases Enables Input Length Extrapolation", "Train Short, Test Long: Attention with Linear Biases Enables Input Length Extrapolation, 2022", "ALiBi"]
---
# Train Short, Test Long: Attention with Linear Biases Enables Input Length Extrapolation

- **Journal**: arxiv:2108.12409 #ICLR22
- **Author**: Ofir Press, Noah A. Smith, Mike Lewis
- **Year**: 2022
- **URL**: http://arxiv.org/abs/2108.12409
- [**Zotero**](zotero://select/items/@2022TrainShortTestPress)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4667289924685283329&noteId=1786749292533193472)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

在推理时将模型序列长度外推（Train short, Test long）

外推（extrapolation）：测试时输入序列长度超过训练时序列长度时，模型仍然能表现良好的能力

## 论文的总体贡献

去除 Positional Embedding，在 Attention 中引入距离惩罚。

## 论文提供的关键元素、关键设计

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

### 为什么 val 序列长度增加会降低 Perplexity

可能的两种原因：
1. 模型可以利用到更多的上下文，以此提升预测准确率
2. 长序列减轻了 early token curse

Sliding window evaluation (top; blue) vs. non-overlapping evaluation (bottom; red)：
![fig10](https://pdf.cdn.readpaper.com/parsed/fetch_target/3d59167f9dd3b4cbbfddf9f34e46f8f3_22_Figure_10.png)

early token curse：不重叠的 eval 会导致前几个 token 没有足够的上下文信息。

为了验证是哪一种原因主导，对比两种 eval 方式。
- non-overlapping evaluation：
![fig6](https://pdf.cdn.readpaper.com/parsed/fetch_target/3d59167f9dd3b4cbbfddf9f34e46f8f3_7_Figure_6.png)
- Sliding window evaluation：
![fig11](https://pdf.cdn.readpaper.com/parsed/fetch_target/3d59167f9dd3b4cbbfddf9f34e46f8f3_23_Figure_11.png)

证明sliding window（去除early token curse的影响）没有出现性能提升。

## 相关研究

%% 如何归类。值得关注的研究员 %%

## pq

- denoted L herein
