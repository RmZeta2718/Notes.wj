---
aliases:
  - "Long Context is Not Long at All: A Prospector of Long-Dependency Data for Large Language Models"
  - "Long Context is Not Long at All: A Prospector of Long-Dependency Data for Large Language Models, 2024"
---

# Long Context is Not Long at All: A Prospector of Long-Dependency Data for Large Language Models

- **Journal**: arXiv:2405.17915 #ACL/24
- **Author**: Longze Chen, Ziqiang Liu, Wanwei He, Yunshui Li, Run Luo, Min Yang
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2405.17915
- [**Zotero**](zotero://select/items/@2024LongContextNotChen)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=2338081999971508992&noteId=2384055322055686144)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/735b114c6c6af55ebc381a5c4d74224d_3_Figure_2_-1598470550.png)

- Dependency Strength：相对的 $\Delta \text{PPL}$ （小模型）
- Dependency Distance：相对距离
- Dependency Specificity： $\Delta \text{PPL}$ 遍历 $j$ 过 Softmax 得到概率，计算熵。熵越高越重复越不好。

context length 32768, segment length $L=128$, $N=256$, sampling size $T=5000$

所有 segment 求和即为 data 的 long dependency score。为了降低计算量，采样 $T$ 个pair，而不是计算所有 $O(N^2)$ 个

重复数据样例

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/735b114c6c6af55ebc381a5c4d74224d_12_Figure_5_-1598470550.png)

可视化

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/735b114c6c6af55ebc381a5c4d74224d_7_Figure_3_256293151.png)

### 总体流程

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

$b=\mathrm{160k}$ 

6k/3k steps, 128 bs, 32k len, 24B/12B tokens

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/735b114c6c6af55ebc381a5c4d74224d_5_Table_1_1766057005.png)

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/735b114c6c6af55ebc381a5c4d74224d_6_Table_4_1900478814.png)

## 相关研究

%% 如何归类。值得关注的研究员 %%

Lost in the Middle: How Language Models Use Long Contexts
- 构造任务实验设置参考（KV Retrieval、MQA）
