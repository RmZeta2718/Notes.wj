---
aliases:
  - "Found in the Middle: How Language Models Use Long Contexts Better via Plug-and-Play Positional Encoding"
  - "Found in the Middle: How Language Models Use Long Contexts Better via Plug-and-Play Positional Encoding, 2024"
---
# Found in the Middle: How Language Models Use Long Contexts Better via Plug-and-Play Positional Encoding

- **Journal**: arXiv:2403.04797 #NeurIPS/24 
- **Author**: Zhenyu Zhang, Runjin Chen, Shiwei Liu, Zhewei Yao, Olatunji Ruwase, Beidi Chen, Xiaoxia Wu, Zhangyang Wang
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2403.04797
- [**Zotero**](zotero://select/items/@2024FoundMiddleHowZhang)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

逐head PI，手工设计scale系数，根据head的熵排序，以分配系数

## 论文提供的关键元素、关键设计

对于一个q，用attn得分超过平均值3倍的kv个数（公式1），衡量head对不同位置的关注程度（差不多等同于熵，熵有消融）

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
