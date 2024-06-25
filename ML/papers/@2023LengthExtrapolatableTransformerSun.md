---
aliases:
  - A Length-Extrapolatable Transformer
  - A Length-Extrapolatable Transformer, 2023
  - xPos
---
# A Length-Extrapolatable Transformer

- **Journal**: Proceedings of the 61st Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers) #ACL/23 
- **Author**: Yutao Sun, Li Dong, Barun Patra, Shuming Ma, Shaohan Huang, Alon Benhaim, Vishrav Chaudhary, Xia Song, Furu Wei
- **Year**: 2023
- **URL**: https://aclanthology.org/2023.acl-long.816
- [**Zotero**](zotero://select/items/@2023LengthExtrapolatableTransformerSun)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4703487902382817281&noteId=2353574575063207936)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

$\operatorname{RoPE}(\boldsymbol{x}, m)=\mathcal{R}_m\boldsymbol{x}$

$\begin{cases}\operatorname{xPos}_q(\boldsymbol{q}^{(n)}, n)=\mathcal{R}_n\boldsymbol{q}^{(n)}\xi^{-n}\\ \operatorname{xPos}_k(\boldsymbol{k}^{(m)}, m)=\mathcal{R}_m\boldsymbol{k}^{(m)}\xi^m \end{cases}$

$\xi_i=\dfrac{\frac{2i}{d}+\gamma}{1+\gamma}\in(0,1]$

$\begin{align}\langle\operatorname{xPos}_q(\boldsymbol{q}^{(n)}, n),\ \operatorname{xPos}_k(\boldsymbol{k}^{(m)}, m)\rangle&=(\mathcal{R}_n\boldsymbol{q}^{(n)}\xi^{-n})^T\mathcal{R}_m\boldsymbol{k}^{(m)}\xi^m\\&=\boldsymbol{q}^{(n)T}\mathcal{R}_{m-n}\boldsymbol{k}^{(m)}\xi^{m-n}\\&=\langle\operatorname{xPos}_q(\boldsymbol{q}^{(n)}, 0),\ \operatorname{xPos}_k(\boldsymbol{k}^{(m)}, m-n)\rangle\\&=\xi^{m-n}\langle\operatorname{RoPE}(\boldsymbol{q}^{(n)}, 0),\ \operatorname{RoPE}(\boldsymbol{k}^{(m)}, m-n)\rangle\end{align}$

Causal LM: $m-n\le0\Rightarrow\xi^{m-n}\in(0,1]$

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/d4df4ed94482059dfa992864a072603e_6_Table_5_-1595916118.png)

## 相关研究

%% 如何归类。值得关注的研究员 %%
