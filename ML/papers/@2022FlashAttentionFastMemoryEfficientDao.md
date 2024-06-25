---
aliases:
  - "FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness"
  - "FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness, 2022"
  - FlashAttention
---
# FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness

- **Journal**: arxiv:2205.14135 #NeurIPS/22  
- **Author**: Tri Dao, Daniel Y. Fu, Stefano Ermon, Atri Rudra, Christopher Ré
- **Year**: 2022
- **URL**: http://arxiv.org/abs/2205.14135
- [**Zotero**](zotero://select/items/@2022FlashAttentionFastMemoryEfficientDao)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4667276321932460033&noteId=1857762696672213760)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

> From Online Softmax to FlashAttention ([note](https://courses.cs.washington.edu/courses/cse599m/23sp/notes/flashattn.pdf))

如何减少HBM读写次数？逐块计算（Compute by blocks），block可以放入SRAM。

挑战：

- 计算SoftMax时没有完整的一行结果
- 反向传播时没有完整的注意力矩阵激活值

相关技术：

- Tiling：重构算法，逐块计算，避免SRAM-HBM之间来回挪动数据
    - $\operatorname{SoftMax}([A_1,A_2])=[\alpha\operatorname{SoftMax}(A_1),\ \beta\operatorname{SoftMax}(A_2)]$
    - $\operatorname{SoftMax}([A_1, A_2])\left[\begin{array}{l} V_1 \\ V_2 \end{array}\right]=\alpha \operatorname{SoftMax}(A_1) V_1+\beta \operatorname{SoftMax}(A_2) V_2$
- Recomputation：不存储注意力矩阵，反向传播时重新计算

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### (Safe) Softmax

$e^x$ 容易上溢（eg. fp16：$x>11$），$e^{x-\max x}$ 可避免上溢

$\begin{align}\operatorname{SoftMax}\left(\left\{x_{1}, \ldots, x_{N}\right\}\right)&=\left\{\dfrac{e^{x_{i}}}{\sum_{j=1}^{N} e^{x_{j}}}\right\}_{i=1}^{N}\\&=\left\{\dfrac{e^{x_{i}-m}}{\sum_{j=1}^{N} e^{x_{j}-m}}\right\}_{i=1}^{N},\quad m=\underset{i}\max{x_i}\end{align}$

### Algorithm: 3-pass safe softmax

Notations：

- $m_i=\max_{j=1}^i\{x_j\},\ m_0=0$，$m_N$ 是输入向量的最大值
- $d_i=\sum_{j=1}^ie^{x_j-m_N},\ d_0=0$， $d_N$ 是 safe softmax的分母
- $\{a_i\}_{i=1}^N$：softmax的结果

Body：

$\text { for } i \leftarrow 1, N \text { do } \quad m_i\leftarrow \max\{m_{i-1}, x_i\}$

$\text { for } i \leftarrow 1, N \text { do } \quad d_i\leftarrow d_{i-1}+e^{x_i-m_N}$

$\text { for } i \leftarrow 1, N \text { do } \quad a_i\leftarrow \dfrac{e^{x_i-m_N}}{d_N}$

### Online Softmax

$d_i=\sum_{j=1}^ie^{x_j-m_N}$ 依赖 $m_N$，因此需要额外一次遍历，考虑去除对 $m_N$ 的依赖：

$$
\begin{aligned}
d_i' & :=\sum_{j=1}^{i} e^{x_{j}-m_{i}} \\
& =\left(\sum_{j=1}^{i-1} e^{x_{j}-m_{i}}\right)+e^{x_{i}-m_{i}} \\
& =\left(\sum_{j=1}^{i-1} e^{x_{j}-m_{i-1}}\right) e^{m_{i-1}-m_{i}}+e^{x_{i}-m_{i}} \\
& =d_{i-1}^{\prime} e^{m_{i-1}-m_{i}}+e^{x_{i}-m_{i}}
\end{aligned}
$$

于是将 $m_i,d_i$ 的两次遍历融合为 $m_i,d_i'$ 的一次遍历

### Algorithm: 2-pass online softmax

$\begin{align}\text { for } i \leftarrow 1, N \text { do } \quad &m_i\leftarrow \max\{m_{i-1}, x_i\}\\& d_i'\leftarrow d_{i-1}'e^{m_{i-1}-m_i}+e^{x_i-m_i}\end{align}$

$\text { for } i \leftarrow 1, N \text { do } \quad a_i\leftarrow \dfrac{e^{x_i-m_N}}{d_N'}$

直观理解 $d_i'$ ：前 $i$ 项的 SoftMax 分母，递推更新时存在修正项

不存在 1-pass SoftMax 算法 : (

但是存在 1-pass Self-Attention 算法 :-o

### Algorithm: 2-pass Self-Attention

Self-Attention 的 SoftMax 是按行计算的，即行与行之间的计算独立。考虑第 $k$ 行：

Notations:

- $\boldsymbol{q}^{(k)}, \boldsymbol{k}^{(i)T}, \boldsymbol{v}^{(i)}$：$Q$ 的第 $k$ 行，$K$ 的第 $i$ 行的转置，$V$ 的第 $i$ 行
- $\boldsymbol{o}_i=\sum_{j=1}^ia_j\boldsymbol{v}^{(j)}=A[k,:i]V[:i,:]$ 是输出的部分累加结果

Body:

$$
\begin{align}\text { for } i \leftarrow 1, N \text { do } \quad
& x_i\leftarrow \boldsymbol{q}^{(k)}\boldsymbol{k}^{(i)T}\\
& m_i\leftarrow \max\{m_{i-1}, x_i\}\\
& d_i'\leftarrow d_{i-1}'e^{m_{i-1}-m_i}+e^{x_i-m_i}\end{align}
$$

$$
\begin{align}\text { for } i \leftarrow 1, N \text { do } \quad
& a_i\leftarrow \dfrac{e^{x_i-m_N}}{d_N'}\\
& \boldsymbol{o}_i\leftarrow \boldsymbol{o}_{i-1}+a_i\boldsymbol{v}^{(i)} \end{align}
$$

$\boldsymbol{o}^{(k)}=\boldsymbol{o}_N$

### 如法炮制

$$
\begin{aligned}
\boldsymbol{o}_i' & :=\sum_{j=1}^i \frac{e^{x_{j}-m_{i}}}{d_i'} \boldsymbol{v}^{(j)} \\
& =\left(\sum_{j=1}^{i-1} \frac{e^{x_j-m_{i}}}{d_i'} \boldsymbol{v}^{(j)}\right)+\frac{e^{x_{i}-m_{i}}}{d_i'} \boldsymbol{v}^{(i)} \\
& =\left(\sum_{j=1}^{i-1} \frac{e^{x_j-m_{i-1}}}{d_{i-1}'} \frac{e^{x_{j}-m_{i}}}{e^{x_{j}-m_{i-1}}} \frac{d_{i-1}^{\prime}}{d_i'} \boldsymbol{v}^{(j)}\right)+\frac{e^{x_{i}-m_{i}}}{d_i'} \boldsymbol{v}^{(i)} \\
& =\left(\sum_{j=1}^{i-1} \frac{e^{x_j-m_{i-1}}}{d_{i-1}'} \boldsymbol{v}^{(j)}\right) \frac{d_{i-1}'}{d_i'} e^{m_{i-1}-m_{i}}+\frac{e^{x_{i}-m_{i}}}{d_i'} \boldsymbol{v}^{(i)} \\
& =\boldsymbol{o}_{i-1}' \frac{d_{i-1}'e^{m_{i-1}}}{d_i'e^{m_{i}}}+\frac{e^{x_{i}-m_{i}}}{d_i'} \boldsymbol{v}^{(i)}
\end{aligned}
$$

### Algorithm: 1-pass Self-Attention (FlashAttention)


$$
\begin{align}\text { for } i \leftarrow 1, N \text { do } \quad & x_i\leftarrow \boldsymbol{q}^{(k)}\boldsymbol{k}^{(i)T}\\
& m_i\leftarrow \max\{m_{i-1}, x_i\}\\
& d_i'\leftarrow d_{i-1}'e^{m_{i-1}-m_i}+e^{x_i-m_i}\\
& \boldsymbol{o}_i' \leftarrow \boldsymbol{o}_{i-1}' \frac{d_{i-1}'}{d_{i}'}e^{m_{i-1}-m_{i}}+\frac{e^{x_{i}-m_{i}}}{d_i'} \boldsymbol{v}^{(i)} \end{align}
$$

$\boldsymbol{o}^{(k)}=\boldsymbol{o}_N$

|              | Standard Self-Attention | FlashAttention    |
|:------------:|:-----------------------:|:-----------------:|
| FLOPs        | $O(N^2d)$               | $O(N^2d)$         |
| Extra memory | $O(N^2)$                | $O(N)$            |
| HBM accesses | $O(Nd+N^2)$             | $O(N^2d^2M^{-1})$ |

对于典型的head dim $d$ (64\~128) 和 SRAM size $M$ (100KB)，有 $d^2M^{-1} \ll 1$

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### FlashAttention Speedup

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/71e6e8bb3499c6529c66850a915d395e_7_Table_2.png)

### vs. Sparse Attention (runtime/memory)

未经优化的 Sparse Attention 不如 FlashAttention

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/71e6e8bb3499c6529c66850a915d395e_33_Table_20.png)

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/71e6e8bb3499c6529c66850a915d395e_33_Table_21.png)

## 相关研究

%% 如何归类。值得关注的研究员 %%

[[@2021DataMovementAllIvanov|Data Movement Is All You Need: A Case Study on Optimizing Transformers, 2021]]

[arxiv'18] Online normalizer calculation for softmax ([arxiv](https://arxiv.org/abs/1805.02867))
