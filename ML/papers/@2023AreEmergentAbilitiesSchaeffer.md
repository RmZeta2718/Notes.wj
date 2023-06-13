---
aliases: ["Are Emergent Abilities of Large Language Models a Mirage?", "Are Emergent Abilities of Large Language Models a Mirage?, 2023"]
---
# Are Emergent Abilities of Large Language Models a Mirage?

- **Journal**: arxiv:2304.15004
- **Author**: Rylan Schaeffer, Brando Miranda, Sanmi Koyejo
- **Year**: 2023
- **URL**: http://arxiv.org/abs/2304.15004
- [**Zotero**](zotero://select/items/@2023AreEmergentAbilitiesSchaeffer)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4750609643118526465&noteId=1767936741342278912)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

假设使用交叉熵（CE）作为 loss，且对模型规模 $N$ 服从幂律分布（$c>0, \alpha<0$）：

$$
\mathcal{L}_{C E}(N)=\left(\frac{N}{c}\right)^{\alpha}
$$

对长度为 $L$ 的序列求 Accuracy 是非线性的 metric：

$$
\operatorname{Accuracy}(N) \approx p_{N}(\text { single token correct })^{\text {num. of tokens }}=\exp \left(-(N / c)^{\alpha}\right)^{L}
$$

而token编辑距离对模型规模 $N$ 是近线性的：

$$
\text { Token } \operatorname{Edit} \operatorname{Distance}(N) \approx L\left(1-p_{N}(\text { single token correct })\right)=L\left(1-\exp \left(-(N / c)^{\alpha}\right)\right)
$$

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
