---
aliases:
  - "Data Engineering for Scaling Language Models to 128K Context"
  - "Data Engineering for Scaling Language Models to 128K Context, 2024"
---

# Data Engineering for Scaling Language Models to 128K Context

- **Journal**: arxiv:2402.10171
- **Author**: Yao Fu, Rameswar Panda, Xinyao Niu, Xiang Yue, Hannaneh Hajishirzi, Yoon Kim, Hao Peng
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2402.10171
- [**Zotero**](zotero://select/items/@2024DataEngineeringScalingFu)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=2188252869613413120&noteId=2275326445297674496)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

基于 [[@2023EffectiveLongContextScalingXiong|ABF]]

- 持续预训练的数据量不需要多，1-5B 就够
- 不应单独上采样 book 等长文档数据集，而应该均匀地上采样每个领域的长文本（Per-source upsampling）

### 总体流程

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

模型训练成本

![tab2](https://pdf.cdn.readpaper.com/parsed/fetch_target/24146e69ee6f24feba5e9bfa95404d59_4_Table_2_-1964182539.png)

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/24146e69ee6f24feba5e9bfa95404d59_6_Table_5_-1964182539.png)

PPL 相近的模型，在长文本任务上差异巨大

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/24146e69ee6f24feba5e9bfa95404d59_7_Figure_4_-225505368.png)

少量数据足以长度外推

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/24146e69ee6f24feba5e9bfa95404d59_5_Figure_3_-1595916118.png)

## 相关研究

%% 如何归类。值得关注的研究员 %%
