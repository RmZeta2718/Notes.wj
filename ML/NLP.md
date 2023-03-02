# 自然语言处理

## 序列模型

> eg. speech recognition, music generation, sentiment classification, DNA sequence analysis, machine translation, video activity recognition, name entity recognition(NER)

 $x^{(i)}$ : 第 $i$ 个样本的输入序列， $y^{(i)}$ : 输出序列

 $x^{(i)\langle t\rangle}, y^{(i)\langle t\rangle}$ : 序列中的第 $t$ 个元素

 $T_x^{(i)},T_y^{(i)}$ : 序列的长度

## 循环神经网络 Recurrent NN (RNN)

![image-20220812125052583](NLP.assets/RNN.png)

单个样本：
$$
\begin{align}
a^{\langle0\rangle}&=\vec 0\\
a^{\langle t\rangle}&=g_a(w_{aa}a^{\langle t-1\rangle}+w_{ax}x^{\langle t\rangle}+b_a)\\
&=g_a(w_a\begin{bmatrix}
a^{\langle t-1\rangle} \\
x^{\langle t\rangle}
\end{bmatrix}+b_a),\qquad(w_a=[w_{aa},w_{ax}])\\
\hat y^{\langle t\rangle}&=g_y(w_{ya}a^{\langle t\rangle}+b_y)
\end{align}
$$

> 通常， $g_a$ 取 tanh 或 ReLU； $g_y$ 由 $y$ 的性质决定，如二分类可用 Sigmoid

### pros and cons of RNN

pros:
- 可以处理任意长度的序列
- 模型大小不随序列长度变化
- 第 $t$ 个词的计算（理论上）可以用到前面的词的信息
- 处理每个词用的是相同的参数，即对输入序列的处理是对称的

cons:
- 计算效率低，因为是 sequential 处理
- 实践中无法有效利用前面的词的信息，因为存在梯度消失/爆炸的问题

### GRU, Gated Recurrent Unit

解决梯度消失（长期依赖）问题

 $c$ : 记忆单元 memory cell

 $c^{\langle 0\rangle}=\vec 0$

 $c^{\langle t-1\rangle}=a^{\langle t-1\rangle}$

 $\Gamma_r=\sigma(w_r\begin{bmatrix}c^{\langle t-1\rangle} \\x^{\langle t\rangle}\end{bmatrix}+b_r)$ 相关关系

 $c^{\langle t\rangle}$ 的候选值 $\tilde c^{\langle t\rangle}=\tanh(\Gamma_r*w_c\begin{bmatrix}c^{\langle t-1\rangle} \\x^{\langle t\rangle}\end{bmatrix}+b_c)$

 $\Gamma_u=\sigma(w_u\begin{bmatrix}c^{\langle t-1\rangle} \\x^{\langle t\rangle}\end{bmatrix}+b_u)$ 更新开关（update gate）

 $c^{\langle t\rangle}=\Gamma_u*\tilde c^{\langle t\rangle}+(1-\Gamma_u)*c^{\langle t-1\rangle}$

 $a^{\langle t\rangle}=c^{\langle t\rangle}$

> $a^{\langle t\rangle}，c^{\langle t\rangle},\Gamma_u$ shape 相同， $*$ 表示按位相乘

### LSTM, Long Short Term Memory units

 $\tilde c^{\langle t\rangle}=\tanh(w_c\begin{bmatrix}c^{\langle t-1\rangle} \\x^{\langle \rangle}\end{bmatrix}+b_c)$

 $\Gamma_u=\sigma(w_u\begin{bmatrix}c^{\langle t-1\rangle} \\x^{\langle t\rangle}\end{bmatrix}+b_u)$ 更新开关（update gate）

 $\Gamma_f=\sigma(w_f\begin{bmatrix}c^{\langle t-1\rangle} \\x^{\langle t\rangle}\end{bmatrix}+b_f)$ 遗忘开关（forget gate）

 $\Gamma_o=\sigma(w_o\begin{bmatrix}c^{\langle t-1\rangle} \\x^{\langle t\rangle}\end{bmatrix}+b_o)$ 输出开关（output gate）

 $c^{\langle t\rangle}=\Gamma_u*\tilde c^{\langle t\rangle}+\Gamma_f*c^{\langle t-1\rangle}$

 $a^{\langle t\rangle}=\Gamma_o*c^{\langle t\rangle}$

### BRNN Bidirectional

通常用来对序列抽取特征、填空，而不用作生成（因为缺乏未来信息）

### Deep RNN

沿 $y$ 方向堆叠 RNN

## 词表示 Word Representation

### One-hot

对于词表 $V$ ，用 $\mathbb{R}^{|V|}$ 的基向量表示所有单词

### 基于 SVD 的方法

找出某个矩阵 $X$ ，然后进行 SVD 分解， $X=U\Sigma V^T$ ，取 $U$ 的每一行作为 word embedding，从而达到降维的效果。

#### Word-Document Matrix

对于 $M$ 篇文章，列出矩阵 $X\in \mathbb{R}^{|V|\times M}$ ， $X_{ij}$ 表示单词 $i$ 出现在文章 $j$ 中。

问题： $M$ 会变

#### Window based Co-occurrence Matrix

 $X\in \mathbb{R}^{|V|\times|V|}$ 表示每个单词的周围一个范围内有多少其他单词

对 $X$ SVD 分解后，取前若干维作为 word embedding

问题：

- 加入新单词导致 $X$ 维度变化
- $X$ 稀疏且庞大
- SVD 分解是二次方复杂度

一些改进措施：

- 忽略常见词（stop words，停词），如 he his the
- 采用带权重的滑动窗口，距离越近权重越高
- 使用协方差矩阵代替简单的计数

### 基于迭代（训练）的方法——word2vec

基于特征的词表示

定义一个模型，其参数是词表示，然后在一些特定的任务上训练模型

一些注解

- Word2vec 是一种 Bag of words model——与位置无关
- 词嵌入用于类比：man-woman : king-？ $\underset{w}{\arg\max\,}\mathrm{sim}(e_w,e_{\mathrm{king}}-e_{\mathrm{man}}+e_{\mathrm{woman}})$
- 对于多义词也可以很好地表示
- 同义词和反义词都在类似的语境中出现，因此基于上下文预测的方式无法很好地区分反义词
- 可视化方法：t-SNE 算法投影到二维

#### word2vec: Continuous Bag of Words Model (CBOW)

任务：根据上下文预测中心词，学习输入输出的词表示（学习两个词表示）

Notations：

- $w^{\langle i\rangle},w_i$ ：分别表示输入序列中的第 $i$ 个单词，和词表中的第 $i$ 个单词。（假设序列中第 $i$ 个单词在词表中的下标是 $j$ ，则 $w^{\langle i\rangle}=w_j$ ）
- $n$ ：词向量维度，超参数
- $\mathcal{V} \in \mathbb{R}^{n \times|V|}$ ：表示输入的词向量矩阵，即作为上下文时的词向量
- $\mathcal{U} \in \mathbb{R}^{|V|\times n}$ ：表示输出的词向量矩阵，即作为中心词时的词向量
- $u^{\langle i\rangle},u_i$ ：同 $w^{\langle i\rangle},w_i$

- $c$ ：中心词在序列中的位置
- $m$ ：上下文窗口半径，即选取 $[c-m,c+m]$ 范围内的单词，即

输入上下文的词表示： $(v^{\langle c-m\rangle},\cdots,v^{\langle c-1\rangle},v^{\langle c+1\rangle},\cdots,v^{\langle c+m\rangle})$

这些词向量的平均值记为 $\hat v=\dfrac{v^{\langle c-m\rangle}+\cdots+v^{\langle c-1\rangle}+v^{\langle c+1\rangle}+\cdots+v^{\langle c+m\rangle}}{2m}$

对于单词 $i,j$ ，相似度通过点积计算，即 $u_i^Tv_j$ ，将所有输出单词的词向量放在一起，得到评分向量： $z=\mathcal U\hat v\in\mathbb R^{|V|}$

通过 softmax 将评分转化为概率，即输出 $\hat y=\text{softmax}(z)\in\mathbb R^{|V|}$ ，表示每个单词是中心词的概率，而 ground truth 是真实中心词的 one hot 表示

损失函数取交叉熵 $J(\hat y,y)=H(\hat y,y)=-\sum_{j=1}^{|V|}y_j\log(\hat y_j)$ ，由于 $y$ 是中心词的 one hot 表示，假设中心词在词表的下标是 $i$ （只有 $y_i=1$ ），于是
$$
\begin{align}
J(\hat y,y)&=-\log(\hat y_i)\qquad=-\log P(u^{\langle c\rangle}|v^{\langle c-m\rangle},\cdots,v^{\langle c-1\rangle},v^{\langle c+1\rangle},\cdots,v^{\langle c+m\rangle})\\
&=-\log(\text{softmax}(z_i))\\
&=-\log \frac{\exp(u_i^{T} \hat{v})}{\sum_{j=1}^{|V|} \exp(u_j^{T} \hat{v})} \\
&=-u_{i}^{T} \hat{v}+\log \sum_{j=1}^{|V|} \exp(u_{j}^{T} \hat{v})
\end{align}
$$

#### word2vec: Skip-Gram Model

类似 CBOW，只是反过来

任务：根据中心词预测上下文，学习输入输出的词表示（学习两个词表示）

Notations:

- 同 CBOW，不同点如下：
- $\mathcal{V} \in \mathbb{R}^{n \times|V|}$ 表示中心词（同样是输入的词向量矩阵）
- $\mathcal{U} \in \mathbb{R}^{|V|\times n}$ 表示上下文

评分向量 $z=\mathcal Uv^{\langle c\rangle}\in\mathbb R^{|V|}$ ，转化为概率： $\hat y=\text{softmax}(z)\in\mathbb R^{|V|}$ ，即对于单词 $w_i$ ，其在 $w^{\langle c\rangle}$ 周围 $m$ 范围内出现的概率 $P(u_i|v^{\langle c\rangle})=\hat y_i$

对于某一个中心词 $w^{\langle c\rangle}$ ，似然函数表达为：
$$
\begin{align}
\text {Likelihood}&=L(\theta)=P(u^{\langle c-m\rangle},\cdots,u^{\langle c-1\rangle},u^{\langle c+1\rangle},\cdots,u^{\langle c+m\rangle}|v^{\langle c\rangle})\\
&=\prod_{\substack{-m \leq j \leq m \\ j \neq 0}} P(u^{\langle c+j\rangle}|v^{\langle c\rangle})\qquad \text{(Naive Bayes assumption)}
\end{align}
$$
损失函数取负对数似然：
$$
\begin{align}
J_c(\hat y,y)&=-\log L(\theta)\\
&=-\sum_{\substack{-m \leq j \leq m \\ j \neq 0}} \log P(u^{\langle c+j\rangle}|v^{\langle c\rangle})\qquad \text{(Naive Bayes assumption)}\\
&=-\sum_{\substack{-m \leq j \leq m \\ j \neq 0}} \log \hat y^{\langle c+j\rangle}\\
&=-\sum_{\substack{-m \leq j \leq m \\ j \neq 0}} \log \frac{\exp(u^{\langle c+j\rangle}\cdot v^{\langle c\rangle})}{\sum_{k=1}^{|V|} \exp(u_k\cdot v^{\langle c\rangle})} \\
&=-\sum_{\substack{-m \leq j \leq m \\ j \neq 0}} u^{\langle c+j\rangle}\cdot v^{\langle c\rangle}+2m\log\sum_{k=1}^{|V|} \exp(u_k^{T} v^{\langle c\rangle})
\end{align}
$$
总损失为所有中心词的平均：
$$
J=\dfrac1T\sum_{c=1}^TJ_c
$$
注：

- 为了简化求导，每个单词有两个词向量 $v_w,u_w$ ，（通常）最终结果取两者平均值。
- $J_c=-\sum_{\substack{-m \leq j \leq m \\ j \neq 0}} \log P(u^{\langle c+j\rangle}|v^{\langle c\rangle})=\sum_{\substack{-m \leq j \leq m \\ j \neq 0}} H(\hat y,y^{\langle c+j\rangle})$ ，概率向量 $\hat y$ 和 one-hot 向量 $y^{\langle c+j\rangle}$ 的交叉熵就是负对数似然。所以损失函数也可以看做交叉熵。
- 反向传播的结果：

$$
\begin{align}
\dfrac{\partial P(o|c)}{\partial v^{\langle c\rangle}}&=u^{\langle o\rangle}-\sum_{x=1}^{|V|}P(x|c)u_x\\
&=\text{observed}-\text{expected}
\end{align}
$$

#### word2vec Optimization: Negative Sampling

Distributed Representations of Words and Phrases and their Compositionality

$\sum_{w\in V}$ 代价较大，尝试近似：从词表中随机取 $K$ 个单词，采样的分布是 $P_n(w)$ ，一般认为较好的分布是 Unigram 的 $3/4$ 次方（放大罕见词的概率）。

## Seq2Seq

### 应用

- Translation: source language -> target language
- Summarization: long text -> short text
- Dialogue: previous utterances -> next utterance
- Parsing: input text -> output parse as sequence
- Code generation: natural language -> programming language

### Decoding

> 参考 [CS224n](https://web.stanford.edu/class/archive/cs/cs224n/cs224n.1214/slides/cs224n-2021-lecture12-generation.pdf)

- Exhaustive search: NP-complete
- Greedy Search: $\hat y_{t}=\underset{w\in V}{\arg\max\ } P(y_t=w | \{y\}_{<t})$ ，容易生成重复的文本
- Ancestral sampling: 根据当前 LM 的分布采样 $\hat y_{t} \sim P(y_{t}=w | \{y\}_{<t})$ 。
    - 虽然理论上是渐进精确的（asymptotically exact），但实践中通常性能较差，方差较大
        - 分布是长尾的
        - 许多低概率的词是与当前上下文完全无关的。所以没有必要给这些词采样概率
    - 改进策略：
        - 选top-k by rank（但是k不好选，不同语境有不同的最优k）
        - top-p (nucleus) 累计密度到p
- Beam search: 每个 step $t$ 都维护 $k$ 个最好的结果（beam width）$\mathcal{H}_{t}=\left\{\left(x_{1}^{1}, \ldots, x_{t}^{1}\right), \ldots,\left(x_{1}^{K}, \ldots, x_{t}^{K}\right)\right\}$

### Evaluation

Evaluation vs loss (by [CS224n](https://web.stanford.edu/class/archive/cs/cs224n/cs224n.1214/readings/cs224n-2019-notes06-NMT_seq2seq_attention.pdf) )：本质上loss也是对模型预测结果的一种评估，因此这两个概念容易混淆。Evaluation: a final, summative assessment of your model against some measurement criterion

分类（[CS224n](https://web.stanford.edu/class/archive/cs/cs224n/cs224n.1214/slides/cs224n-2021-lecture12-generation.pdf)）：
- Content Overlap Metrics: Compute a score that indicates the similarity between generated and gold-standard (human-written) text
    - N-gram overlap metrics (e.g., BLEU, ROUGE, METEOR, CIDEr, etc.)
        - 面对open-ended的输出时评估效果较差，如machine translation、summarization、dialogue、story generation
    - Semantic overlap metrics (e.g., PYRAMID, SPICE, SPIDEr, etc.)
- Model-based Metrics: Use **learned representations** of words and sentences to compute semantic similarity between generated and reference texts
- Human Evaluations: Ask humans to evaluate the quality of generated text
    - slow and expensive, also problems:
        - inconsistent
        - illogical
        - lose concentration
        - misinterpret your question
        - can’t always explain why they feel the way they do

#### BLEU

> Bilingual Evaluation Understudy

存在多个可选的输出时（如机器翻译）使用的评价指标，越大越好

n-gram precision（翻译的句子中的 n-gram 有多少也出现在答案句子中，即 precision）:
$$
p_n=\dfrac{\sum\limits_{\text{n-grams}\in\hat y}\mathrm{Count_clip}(\text{n-gram})}{\sum\limits_{\text{n-grams}\in\hat y}\mathrm{Count}(\text{n-gram})}
$$

Combined Bleu score:
$$
\mathrm{BP}\cdot\exp(\dfrac14\sum_{n=1}^4p_n)
$$
BP 指 brevity penalty，用于惩罚短句子
$$
\mathrm{BP}=\exp(\min(0,1-\dfrac{T^*}{\hat T}))=\begin{cases}
1 & \text{if } \hat T>T^* \\
\exp(1-\dfrac{T^*}{\hat T}) &\text { otherwise }
\end{cases}
$$
 $T^*,\hat T$ 分别指 ground truth 的句子长度和模型翻译的句子长度

BLEU score 不是完美的：如果某个翻译离 ground truth 太远（n-gram 重叠率低），就会分数较低

[BLEU — 动手学深度学习](https://zh.d2l.ai/chapter_recurrent-modern/seq2seq.html#id9)

### Word segmentation

> 参考 [CS224n](https://web.stanford.edu/class/archive/cs/cs224n/cs224n.1214/readings/cs224n-2019-notes06-NMT_seq2seq_attention.pdf)

现实中的词汇数量庞大，导致模型计算最终的词表概率分布的计算开销巨大（$O(|V|)$），总体上应对方案有两个思路：
- 更快地计算Softmax。但是优化Softmax的方法只能让训练过程加速，因为知道目标词（正样本）是哪个。在测试时，为了预测，仍然需要计算每一个词的概率。
    - Noise Contrastive Estimation：从负样本中随机采样 $K$ 个单词。于是Softmax的计算代价缩小了 $\dfrac{|V|}{K}$ 
    - Hierarchical Softmax：把Softmax放到二分树上。
- 缩小词表大小/更高效地表示单词
    - Jean et al.: 把训练集分成一些子集，每个子集用自己的小词表，实践中能缩小约10倍。这个方法可以视作一种非均匀采样的NCE，其采样不是均匀分布，而是从这个分布中采样 $Q(y_{t})=\begin{cases}\frac{1}{|V'|}, \text { if } y_{t} \in|V'| \\0, \text { otherwise }\end{cases}$
    - Byte Pair Encoding: Neural Machine Translation of Rare Words with Subword Units, 2016

#### Byte Pair Encoding

从仅包含字母的词表开始，不断扩充词表，加入频率最高的n-gram pair。不断重复，直到词表大小达到阈值


## 语言模型 Language Model

### 定义

输入：序列，输出：该序列存在的概率，即 $P(w_1,\cdots,w_T)$

基于条件概率直接展开： $P(w_1,\cdots,w_T)=P(w_1)P(w_2|w_1)\cdots P(w_T|w_1w_2\cdots w_{T-1})$

#### n-gram 语言模型

应用 $N-1$ 阶马尔科夫假设得到 N-gram 模型：

$$P\left(w_{1}, \ldots, w_{T}\right)=\prod_{i=1}^T P\left(w_{i} \mid w_{1}, \ldots, w_{i-1}\right) \approx \prod_{i=1}^T P\left(w_{i} \mid w_{i-(n-1)}, \ldots, w_{i-1}\right)$$

- Unigram model：假设每个单词独立，即 $P(w_{1}, w_{2}, \cdots, w_{T})=\prod_{i=1}^{T} P(w_{i})$
- Bigram model：仅考虑连续两个单词的相关性，即 $P(w_{1}, w_{2}, \cdots, w_{T})=P(w_1)\cdot\prod_{i=2}^{T} P(w_{i}|w_{i-1})$ ，其中 $p\left(w_{i} | w_{i-1}\right)=\frac{\operatorname{count}\left(w_{i-1}, w_{i}\right)}{\operatorname{count}\left(w_{i-1}\right)}$
- Trigram model： $P(w_{1}, w_{2}, \cdots, w_{T})=P(w_1)P(w_2|w_1)\cdot\prod_{i=3}^{T} P(w_{i}|w_{i-1},w_{i-2})$

### 评估

#### Perplexity

> 困惑度（越小越好）

Inverse probability of corpus (according to LM), normalized by number of words

$$
\text{Perplexity}=\sqrt[T]{\dfrac1{P(w_1,\cdots,w_T)}}=\exp(-{\dfrac1T\log P(w_1,\cdots,w_T)})
$$

如何理解困惑度：如果 $\text{Perplexity}=53$，那么相当于你对下一个词的不确定度是一个 53 面的骰子

困惑度最小值估计在 20 左右（by [CS224N](https://www.bilibili.com/video/BV18Y411p79k/?p=6&share_source=copy_web&vd_source=ff9df13d97e77634f0683a5b6f354918&t=1662) )

困惑度等价于指数交叉熵损失（CEL）：

$$
\begin{align}
&J(\theta)=-{\dfrac1T\log P(w_1,\cdots,w_T)}\\
&\text{Perplexity}=\exp(J(\theta))
\end{align}
$$

[动手学深度学习的解释](https://zh.d2l.ai/chapter_recurrent-neural-networks/rnn.html#perplexity)

### 神经语言模型 NLM

Word2vect，GloVe，Elmo，Bert

## 注意力机制

 机器翻译为例： $t,t'$ 分别是输出和输入句子的下标， $s^{\langle t\rangle},a^{\langle t\rangle}$ 分别是输出和输入 RNN 的激活值。

 $\alpha^{\langle t,t'\rangle}$ 表示生成 $y^{\langle t\rangle}$ 时，对 $a^{\langle t'\rangle}$ 的注意力，用 softmax 计算
$$
\alpha^{\langle t,t'\rangle}=\dfrac{\exp(e^{\langle t,t'\rangle})}{\sum_{t'=1}^{T_x}\exp(e^{\langle t,t'\rangle})}
$$
 $e^{\langle t,t'\rangle}$ 由 $s^{\langle t-1\rangle}$ 和 $a^{\langle t'\rangle}$ 通过一个神经网络得到。

总体复杂度为二次方

[Bahdanau et.al.,2014.Neural machine translation by jointly learning to align and translate]

[Xu et. al., 2015.Show attention and tell: neural image caption generation with visual attention]

## Transformers

### 自注意力机制 Self-Attention

Intuition:
- Attention: idea
    - Attention is a way to obtain a fixed-size representation of an arbitrary set of representations (the values), dependent on some other representation (the query).
- CNN: parallel

Self-Attention=Attention+CNN

第 $i$ 个 token $x^{\langle i\rangle}$ 的 Attention 表达为：
$$
A^{\langle i\rangle}=A(q^{\langle i\rangle}, K, V)=\sum_{i} \frac{\exp \left(q^{\langle i\rangle} \cdot k^{\langle i\rangle}\right)}{\sum_{j} \exp \left(q^{\langle i\rangle} \cdot k^{\langle j\rangle}\right)} v^{\langle i\rangle}
$$
其中， $q^{\langle i\rangle}=W^Q\cdot x^{\langle i\rangle},k^{\langle i\rangle}=W^K\cdot x^{\langle i\rangle},v^{\langle i\rangle}=W^V\cdot x^{\langle i\rangle}$

向量化，对所有 token 同时计算，也叫做 Scaled dot-product attention：
$$
\mathrm{Attention}(Q, K, V)=\mathrm{softmax}\left(\frac{Q K^{T}}{\sqrt{d_{k}}}\right) V
$$
Attention 重复做若干次，则为 Multihead Attention 多头注意力

## Machine Translation (MT)

- Out-of-vocabulary words
- Domain mismatch between train and test data
- Maintaining context over longer text
- Low-resource language pairs
- Failures to accurately capture sentence meaning
- Pronoun (or zero pronoun) resolution errors
- Morphological agreement errors

## Data

【【斯坦福 CS224N】(2021|中英) 深度自然语言处理 Natural Language Processing with Deep Learning】 【精准空降到 1:05:37】 https://www.bilibili.com/video/BV18Y411p79k/?p=8&share_source=copy_web&vd_source=ff9df13d97e77634f0683a5b6f354918&t=3937
