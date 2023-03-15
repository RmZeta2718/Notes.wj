---
aliases: ["LLaMA: Open and Efficient Foundation Language Models", "LLaMA: Open and Efficient Foundation Language Models, 2023", "LLaMA"]
---
# LLaMA: Open and Efficient Foundation Language Models

- **Journal**:
- **Author**: Hugo Touvron, Thibaut Lavril, Gautier Izacard, Xavier Martinet, Marie-Anne Lachaux, Timothee Lacroix, Baptiste Rozière, Naman Goyal, Eric Hambro, Faisal Azhar, Aurelien Rodriguez, Armand Joulin, Edouard Grave, Guillaume Lample
- **Year**: 2023
- **URL**:
- [**Zotero**](zotero://select/items/@2023LLaMAOpenEfficientTouvron)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4727027362944778241&noteId=1670740940446323712)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

训练一个新的大模型，并讨论：
- 如何降低成本，特别是推理成本

## 论文的总体贡献

- 训练了 4 个模型（训练目标为语言模型）
- 达到相同的性能，模型大小缩小 10 倍
- 开源模型和参数，数据集来自开源社区

## 论文提供的关键元素、关键设计

### 大模型的计算量（amount of computation/compute budget）

$$
\mathrm{cost\propto computation\propto (\#params)\times (\#tokens)}
$$

- 训练成本：
    - 参数量 $\times$ 语料库大小
- 部署成本（推理成本）：
    - 参数量 $\times$ 用户访问量

Meta：降低部署成本 $\Rightarrow$ 减少参数量，扩大训练语料库

> "the performance of a 7B model continues to improve even after 1T tokens."

> 其他研究认为大模型有涌现性，但是这里似乎认为小模型也能很好，两种说法有什么关联

一些大模型数据（来自 [[@2022TrainingComputeOptimalLargeHoffmann|Training Compute-Optimal Large Language Models, 2022]]）
![tab1](https://pdf.cdn.readpaper.com/parsed/fetch_target/12c1b62b9ac459f2da00548a32a0cb1e_2_Table_1.png)

更多大模型数据（来自 [[@2022EmergentAbilitiesLargeWei|Emergent Abilities of Large Language Models, 2022]]）：
![tab2](https://pdf.cdn.readpaper.com/parsed/fetch_target/b76a1504436859a9ff610984d1596dfe_25_Table_2.png)

以降低部署成本为目标，因此 Meta 选择降低参数量，扩大语料库

![tab2](https://pdf.cdn.readpaper.com/parsed/fetch_target/db32c3ed9b26866af7ff6522bfcd9ec8_2_Table_2_852708355.png)

### 模型

[[@2017AttentionAllYouVaswani|transformer]]+:
- Pre-normalization ([[@2020LanguageModelsAreBrown|GPT3]])
- SwiGLU activation function (PaLM)
- Rotary Embeddings (GPTNeo)

### 性能优化（训练速度）

- 高效的“因果多头注意力”算子实现，降低内存用量和计算量
    - 不存储掩码覆盖的注意力权重，不计算掩码覆盖的 query/key 值
    - 开源： https://github.com/facebookresearch/xformers
- 手动实现 Transformer 层的反向传播，提升计算性能
    - model and sequence parallelism：通过增加 checkpoint，减少反向传播时的 activation 的重新计算
        - Megatron（吗？）
        - [[@2022ReducingActivationRecomputationKorthikanti|Reducing Activation Recomputation in Large Transformer Models, 2022]]
    - 尽量并行处理网络通信和 activation 的计算

性能数据（65B）：
- 380 tokens/sec/GPU
- 2048 x A100-80GB
- 1.4T tokens —— 21 days

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### 训练 loss
![fig1](https://pdf.cdn.readpaper.com/parsed/fetch_target/db32c3ed9b26866af7ff6522bfcd9ec8_2_Figure_1_-407761410.png)

> 为什么模型越大 loss 下降越快，而不是反过来？

### 性能
![fig2](https://pdf.cdn.readpaper.com/parsed/fetch_target/db32c3ed9b26866af7ff6522bfcd9ec8_7_Figure_2_-1848081711.png)

- SIQA 不太稳定，于是作者认为这个 benchmark 不可靠
- WinoGrande 上，两个大模型性能类似，也属于反常的 benchmark
- 其他的 benchmark 都与训练 loss（perplexity）趋势吻合

> 与 [[@2022TrainingComputeOptimalLargeHoffmann|Chinchilla]] 相比，两者模型大小，数据集大小接近，但是性能差距较大（见 paper table4,5），原因不明

NaturalQuestions 性能
![tab4](https://pdf.cdn.readpaper.com/parsed/fetch_target/db32c3ed9b26866af7ff6522bfcd9ec8_3_Table_4_-1274882875.png)

### 数据集

![tab1](https://pdf.cdn.readpaper.com/parsed/fetch_target/db32c3ed9b26866af7ff6522bfcd9ec8_1_Table_1_-759035277.png)

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
