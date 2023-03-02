---
aliases: ["ZeRO: Memory Optimizations Toward Training Trillion Parameter Models", "ZeRO: Memory Optimizations Toward Training Trillion Parameter Models, 2020", "ZeRO"]
---
# ZeRO: Memory Optimizations Toward Training Trillion Parameter Models

- **Journal**: arxiv:1910.02054 [cs, stat]
- **Author**: Samyam Rajbhandari, Jeff Rasley, Olatunji Ruwase, Yuxiong He
- **Year**: 2020
- **URL**:
- [**Zotero**](zotero://select/items/@2020ZeROMemoryOptimizationsRajbhandari)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4544095804202164225&noteId=1673522372508150784)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

多卡并行训练大模型

## 论文的总体贡献

数据并行（DP）和张量并行（TP）在多卡上的优化方案（？）

## 论文提供的关键元素、关键设计

### ZeRO-DP

针对模型参数和梯度的优化

假设参数量为 $\Psi$ （个），采用混合精度训练：FP16 记录参数和梯度，FP32 记录优化器参数（数值稳定性）：
- 参数和梯度分别占用 $2\Psi$ ，共 $4\Psi$ （B，后续单位均为B）
- 以 Adam 优化器为例：参数、动量、方差分别占用 $4\Psi$，共 $12\Psi$

![fig1](https://pdf.cdn.readpaper.com/parsed/fetch_target/53affc1b8f3d34d4f3a0a9664456014f_2_Figure_1.png)

前两种并行（ZeRO-1，ZeRO-2）分别将**优化器**和**梯度**分块存放在每个 GPU 上，需要时通过 all-reduce 合并计算。因为每个 GPU 上有完整参数，所以可以直接计算出该 micro-batch 的梯度。

**通信量相同**。由于原本也需要 all-reduce 操作，这里的通信没有额外开销，只是通信方式的变化：
- 传统 DP：所有 GPU 发到 GPU0，求和后 GPU0 把结果发给每个 GPU。
- ZeRO：每个 GPU 按分区，将对应分区发送到对应 GPU，每个 GPU 将自己的分区求和后发回给所有其他 GPU
- 每个 GPU 接收其他 GPU 发来的 micro-batch 梯度 $2\Psi$ ，发出当前分区的更新后的参数 $2\Psi$ ，共 $4\Psi$

第三种并行（ZeRO-3）额外把参数也拆分到每个 GPU 上，代价是计算梯度之前需要先通信一遍，获取参数，通信量 $$。

### ZeRO-R

主要针对 activation

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
