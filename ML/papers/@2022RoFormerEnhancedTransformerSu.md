---
aliases: ["RoFormer: Enhanced Transformer with Rotary Position Embedding", "RoFormer: Enhanced Transformer with Rotary Position Embedding, 2022", "RoPE"]
---
# RoFormer: Enhanced Transformer with Rotary Position Embedding

- **Journal**: arxiv:2104.09864 [cs]  #Neurocomputing
- **Author**: Jianlin Su, Yu Lu, Shengfeng Pan, Ahmed Murtadha, Bo Wen, Yunfeng Liu
- **Year**: 2022
- **URL**: http://arxiv.org/abs/2104.09864
- [**Zotero**](zotero://select/items/@2022RoFormerEnhancedTransformerSu)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4662765722829586433&noteId=1671207901605221376)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

[Transformer升级之路：7、长度外推性与局部注意力 - 科学空间|Scientific Spaces (kexue.fm)](https://kexue.fm/archives/9431)
## 论文的总体贡献

## 论文提供的关键元素、关键设计

### RoPE

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/9afc4f8e4881d0163bb93a44ff9e0476_4_Figure_1.png)

二维情况：$\operatorname{RoPE}(\boldsymbol{x}, m)=\mathcal{R}_m\boldsymbol{x}=\left(\begin{array}{cc} \cos m \theta & -\sin m \theta \\ \sin m \theta & \cos m \theta \end{array}\right)\begin{pmatrix} x_1 \\ x_2 \end{pmatrix}, \quad \boldsymbol{x}\in\mathbb{R}^{2}$

$\begin{align}\langle\operatorname{RoPE}(\boldsymbol{q}^{(n)}, n),\ \operatorname{RoPE}(\boldsymbol{k}^{(m)}, m)\rangle&=(\mathcal{R}_n\boldsymbol{q}^{(n)})^T\mathcal{R}_m\boldsymbol{k}^{(m)}=\boldsymbol{q}^{(n)T}(\mathcal{R}_n^T\mathcal{R}_m)\boldsymbol{k}^{(m)}\\&=\boldsymbol{q}^{(n)T}\mathcal{R}_{m-n}\boldsymbol{k}^{(m)}\\&=\langle\operatorname{RoPE}(\boldsymbol{q}^{(n)}, 0),\ \operatorname{RoPE}(\boldsymbol{k}^{(m)}, m-n)\rangle\end{align}$

$$
\begin{align}\operatorname{RoPE}(\boldsymbol{x}, m)&=\underset{\mathcal{R}_m}{\underbrace{\left(\begin{array}{cc:cc:c:cc}
\cos{m\theta_1}& -\sin{m\theta_1}&0&0&\cdots&0&0\\
\sin{m\theta_1}&\cos{m\theta_1}&0&0&\cdots&0&0 \\
\hdashline 0&0&\cos{m\theta_2}& -\sin{m\theta_2}&\cdots&0&0\\
0&0&\sin{m\theta_2}&\cos{m\theta_2}&\cdots&0&0 \\
\hdashline\vdots&\vdots&\vdots&\vdots&\ddots&\vdots&\vdots\\
\hdashline 0&0&0&0&\cdots&\cos{m\theta_{d/2}}& -\sin{m\theta_{d/2}}\\
0&0&0&0&\cdots&\sin{m\theta_{d/2}}&\cos{m\theta_{d/2}}
\end{array}\right)}}\begin{pmatrix}x_0\\x_1\\x_2\\x_3\\\vdots\\x_{d-2}\\x_{d-1}\end{pmatrix}\\
&=\left(\begin{array}{c}\cos m \theta_{0} \\\cos m \theta_{0} \\\cos m \theta_{1} \\\cos m \theta_{1} \\\vdots \\\cos m \theta_{d / 2-1} \\\cos m \theta_{d / 2-1}\end{array}\right)
\otimes\left(\begin{array}{c} x_{0} \\x_{1} \\x_{2} \\x_{3} \\\vdots \\x_{d-2} \\x_{d-1}\end{array}\right)
+\left(\begin{array}{c}\sin m \theta_{0} \\\sin m \theta_{0} \\\sin m \theta_{1} \\\sin m \theta_{1} \\\vdots \\\sin m \theta_{d / 2-1} \\\sin m \theta_{d / 2-1}\end{array}\right)
\otimes\left(\begin{array}{c}-x_{1} \\x_{0} \\-x_{3} \\x_{2} \\\vdots \\-x_{d-1} \\x_{d-2}\end{array}\right)\end{align}
$$

其中：$\theta_i=b^{-2i/d}, b=10000$

### 实现

huggingface LLaMA code ([link](https://github.com/huggingface/transformers/blob/5728b5ad0071be8fa062f8b72c1345343d9b1a48/src/transformers/models/llama/modeling_llama.py#L177)) 交换了配对顺序，从实现角度更方便

$\xcancel{(0,1),(2,3),\dots,(d-2,d-1)}\rightarrow (0,\frac d2),(1,\frac d2+1),\dots,(\frac d2-1,d-1)$

$$
\operatorname{RoPE}(\boldsymbol{x}, m)=\left(\begin{array}{c}\cos m \theta_{0} \\\cos m \theta_{1} \\\vdots \\\cos m \theta_{d / 2-1} \\\cos m \theta_{0}\\\cos m \theta_{1}\\\vdots \\\cos m \theta_{d / 2-1} \\\end{array}\right)
\otimes\left(\begin{array}{c} x_{0} \\x_{1} \\ \vdots\\ x_{d/2-1} \\ x_{d/2} \\ x_{d/2+1} \\\vdots \\x_{d-1}\end{array}\right)
+\left(\begin{array}{c}\sin m \theta_{0} \\\sin m \theta_{1} \\\vdots \\\sin m \theta_{d / 2-1} \\\sin m \theta_{0}\\\sin m \theta_{1}\\\vdots \\\sin m \theta_{d / 2-1} \\\end{array}\right)
\otimes\left(\begin{array}{c}-x_{d/2} \\-x_{d/2+1} \\ \vdots \\ -x_{d-1} \\ x_0 \\ x_1 \\ \vdots \\x_{d/2-1}\end{array}\right)
$$

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%

[[@2023LengthExtrapolatableTransformerSun|xPos]]
