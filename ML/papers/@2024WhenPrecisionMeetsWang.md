---
aliases:
  - "When Precision Meets Position: BFloat16 Breaks Down RoPE in Long-Context Training"
  - "When Precision Meets Position: BFloat16 Breaks Down RoPE in Long-Context Training, 2024"
---

# When Precision Meets Position: BFloat16 Breaks Down RoPE in Long-Context Training

- **Journal**: arXiv:2411.13476
- **Author**: Haonan Wang, Qian Liu, Chao Du, Tongyao Zhu, Cunxiao Du, Kenji Kawaguchi, Tianyu Pang
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2411.13476
- [**Zotero**](zotero://select/items/@2024WhenPrecisionMeetsWang)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4959598380958351361)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

- bf16+RoPE 有精度问题
- ID 的 sink token 也有好处（multi-doc 阶梯型 attn 场景）

## 论文提供的关键元素、关键设计

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/5815484b1d4acfab8d0d636dc59f0b76_2_Figure_2_-1316443042.png)

- cross-document masking（左）：比 dense attn 的长文本性能好 (llama3)
- reset ID（中）：ID 的平移在 bf16 中存在精度问题，重置ID可以解决。但是最大ID受限
- AnchorAttention（右）：sink token+cross-document masking

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%

cross-doc masking
- [[@2024HowTrainLongContextGao|How to Train Long-Context Language Models (Effectively), 2024]]
- [[@2024FewerTruncationsImproveDing|Fewer Truncations Improve Language Modeling, 2024]]
- llama3
