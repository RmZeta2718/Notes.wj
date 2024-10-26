---
aliases:
  - "LESS: Selecting Influential Data for Targeted Instruction Tuning"
  - "LESS: Selecting Influential Data for Targeted Instruction Tuning, 2024"
---
# LESS: Selecting Influential Data for Targeted Instruction Tuning

- **Journal**: arXiv:2402.04333
- **Author**: Mengzhou Xia, Sadhika Malladi, Suchin Gururangan, Sanjeev Arora, Danqi Chen
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2402.04333
- [**Zotero**](zotero://select/items/@2024LESSSelectingInfluentialXia)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4899396180605140993&noteId=2542018091811095552)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计


梯度方法提供了一种通过直接选择最小化目标任务损失的数据来高效学习特定任务的方法，而不依赖于数据的表面特征。直观地说，如果直接将评测集加入训练数据中，评测集性能肯定会提高。受此启发，我们可以计算评测集用于训练时的梯度表示，该梯度是一个与模型参数量相同大小的向量。通过计算每个训练样本对应的梯度表示，我们可以直接计算训练样本与测试样本的梯度向量相似度。与测试样本梯度相似度高的训练样本预计会对测试集性能有正向贡献。

### 影响力的数学描述

数据影响力的灵感来自于微积分基本定理：一个函数$f(\cdot)$在两个点$a,b$之间的插值可以由函数的梯度$f'(\cdot)$沿着$a,b$之间的路径积分得到 $\int_a^bf'(x)\mathrm dx=f(b)-f(a)$。因此，作者将机器学习过程与微积分基本定理类比，将模型训练视为一个积分过程：模型在测试时（训练结束时）与训练开始前的损失变化可以由训练过程的路径描述。

考虑在训练第$t$时间步的模型$\boldsymbol\theta^t$，其训练的损失函数为$\ell\left(\cdot;\boldsymbol\theta^t\right)$，则模型在测试集样本$\boldsymbol z'$上的损失可以用泰勒展开一阶近似：
$$\ell\left(\boldsymbol{z}^{\prime} ; \boldsymbol{\theta}^{t+1}\right) \approx \ell\left(\boldsymbol{z}^{\prime} ; \boldsymbol{\theta}^{t}\right)+\left\langle\nabla \ell\left(\boldsymbol{z}^{\prime} ; \boldsymbol{\theta}^{t}\right), \boldsymbol{\theta}^{t+1}-\boldsymbol{\theta}^{t}\right\rangle$$

假设模型使用随机梯度下降（SGD）训练，批次大小为1，学习率为$\eta_t$，时间步$t$的训练样本为$\boldsymbol z$，则SGD的更新过程可以写为：$\boldsymbol\theta^{t+1}-\boldsymbol\theta^t=-\eta_t\nabla \ell\left(\boldsymbol{z}; \boldsymbol{\theta}^{t}\right)$，将其代入泰勒展开式，得到：
$$\ell\left(\boldsymbol{z}^{\prime} ; \boldsymbol{\theta}^{t+1}\right) - \ell\left(\boldsymbol{z}^{\prime} ; \boldsymbol{\theta}^{t}\right)\approx-\eta_t\left\langle\nabla \ell\left(\boldsymbol{z}^{\prime} ; \boldsymbol{\theta}^{t}\right), \nabla \ell\left(\boldsymbol{z}; \boldsymbol{\theta}^{t}\right)\right\rangle$$

该式表明，由于单个训练步骤导致的测试损失变化，近似与测试样本和训练样本梯度的内积成比例。

\paragraph{基于影响力的数据选择} 基于上述观察，\texttt{LESS}~\cite{LESS}将数据影响力$\mathrm{Inf_{SGD}}$定义为：
$$\mathrm{Inf_{SGD}}(\boldsymbol{z},\boldsymbol{z'})\triangleq\eta_t\left\langle\nabla \ell\left(\boldsymbol{z}^{\prime} ; \boldsymbol{\theta}^{t}\right), \nabla \ell\left(\boldsymbol{z}; \boldsymbol{\theta}^{t}\right)\right\rangle$$

该指标量化了在训练样本 $\boldsymbol{z}$ 上训练对测试样本 $\boldsymbol{z}^{\prime}$ 损失的预期变化。然而，将先前的方法应用于指令微调时，会遇到以下问题：

- 模型通常使用 Adam 优化器而非 SGD。
- 在变长的指令数据上计算序列级别的梯度会导致影响力估计产生偏差，倾向于选择较短的指令。
- 大型语言模型的参数量使得梯度信息的计算和存储开销巨大。

### 扩展到Adam优化器
为了解决第一个问题，LESS将影响力定义扩展到 Adam 优化器。Adam 的更新规则如下，其中 $\beta_1, \beta_2$ 分别为一阶和二阶动量的超参数，$\epsilon$ 为一个很小的常数：
$$\begin{aligned}
\boldsymbol{\theta}^{t+1}-\boldsymbol{\theta}^{t}&=-\eta_{t} \Gamma\left(\boldsymbol{z}, \boldsymbol{\theta}^{t}\right) \\
\Gamma\left(\boldsymbol{z}, \boldsymbol{\theta}^{t}\right) &\triangleq \frac{\boldsymbol{m}^{t+1}}{\sqrt{\boldsymbol{v}^{t+1}+\epsilon}} \\
\boldsymbol{m}^{t+1}&=\left(\beta_{1} \boldsymbol{m}^{t}+\left(1-\beta_{1}\right) \nabla \ell\left(\boldsymbol{z} ; \boldsymbol{\theta}^{t}\right)\right) /\left(1-\beta_{1}^{t}\right) \\
\boldsymbol{v}^{t+1}&=\left(\beta_{2} \boldsymbol{v}^{t}+\left(1-\beta_{2}\right) \nabla \ell\left(\boldsymbol{z} ; \boldsymbol{\theta}^{t}\right)^{2}\right) /\left(1-\beta_{2}^{t}\right)
\end{aligned}$$

这意味着对于Adam优化器而言，应当选择$\boldsymbol z$，使内积$\left\langle\nabla \ell\left(\boldsymbol{z}^{\prime} ; \boldsymbol{\theta}^{t}\right), \Gamma\left(\boldsymbol{z}, \boldsymbol{\theta}^{t}\right)\right\rangle$最大。

### 消除序列长度偏差

然而，在序列上计算梯度，即对序列 $\boldsymbol{z}$ 中每个词的损失取平均值，这种操作会导致梯度范数 $\left|\nabla_{\boldsymbol{\theta}} \ell\left(\boldsymbol{z}; \boldsymbol{\theta}^{t}\right)\right|$ 与序列长度呈显著负相关。如果使用内积来衡量数据影响力，该指标将倾向于选择较短的样本，最终可能导致模型性能下降。

为了解决这个问题，作者将梯度范数归一化，选择余弦相似度而非内积来估计影响力。Adam 优化器下的数据影响力定义为：
$$\mathrm{Inf_{Adam}}(\boldsymbol{z},\boldsymbol{z'})\triangleq\eta_t\cos\left(\nabla \ell\left(\boldsymbol{z}^{\prime} ; \boldsymbol{\theta}^{t}\right), \Gamma\left(\boldsymbol{z}; \boldsymbol{\theta}^{t}\right)\right)$$

这种调整有助于确保样本的选择基于梯度的方向而非幅度，从而缓解对较短序列的偏好。

### 高效梯度特征计算

由于主流语言模型的参数量通常较大，按照数据影响力的定义，需要计算模型参数量大小的两个梯度向量的内积，这种操作过于昂贵。因此，作者引入了两个技术来构造低维度的梯度特征：LoRA和随机投影。

通过使用 LoRA 训练模型，作者将可训练的参数数量限制在原始模型参数量的一小部分（例如 $2\%$）。使用 \texttt{LoRA} 的梯度向量 $\hat{\nabla}_{\boldsymbol{\theta}} \ell\left(\cdot; \boldsymbol{\theta}\right) \in \mathbb{R}^P$ 来计算 \texttt{Adam} 的更新 $\hat{\Gamma}\left(\boldsymbol{z}; \boldsymbol{\theta}\right)$。

为了进一步降低维度，作者应用了随机投影。采样一个随机投影矩阵 $\Pi \in \mathbb{R}^{P \times d}$，其中每个元素服从 Rademacher 分布（即 $\Pi_{ij} \sim \mathcal{U}({-1, 1})$）。然后，分别对梯度向量进行投影：
$$\tilde\nabla \ell\left(\boldsymbol z' ; \boldsymbol{\theta}\right)=\Pi^\top\hat\nabla \ell\left(\boldsymbol z' ; \boldsymbol{\theta}\right),\quad\tilde\Gamma\left(\boldsymbol z; \boldsymbol{\theta}\right)=\Pi^\top\hat\Gamma\left(\boldsymbol z; \boldsymbol{\theta}\right)$$

理论保证在随机投影下，向量之间的内积大概率保持不变。在实践中，作者选取投影维度$d=8192$。通过应用这些方法，就可以高效地计算捕获训练样本对测试样本影响的低维梯度特征，从而实现指令微调的数据选择。


### 总体流程

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
