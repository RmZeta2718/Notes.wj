---
aliases: ["End-to-End Object Detection with Transformers", "End-to-End Object Detection with Transformers, 2020", "DETR"]
---
# End-to-End Object Detection with Transformers

- **Journal**: arxiv:2005.12872 [cs]
- **Author**: Nicolas Carion, Francisco Massa, Gabriel Synnaeve, Nicolas Usunier, Alexander Kirillov, Sergey Zagoruyko
- **Year**: 2020
- **URL**: http://arxiv.org/abs/2005.12872
- [**Zotero**](zotero://select/items/@2020EndtoEndObjectDetectionCarion)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4556929152427499521&noteId=1553282941923476224)
- [bilibili](https://www.bilibili.com/video/BV1GB4y1X72R/)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

端到端目标检测

## 论文的总体贡献

将 Transformer 应用到目标检测中。并且提出一个非常简单的端到端模型，不再受限于以往目标检测的各种人工设计目标（如 NMS）。

## 论文提供的关键元素、关键设计

### 总体流程

![fig2](https://pdf.cdn.readpaper.com/parsed/fetch_target/fe95d3164d4c868cd30406f698068bdf_6_Figure_2.png)

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

Encoder Attention:
![fig3](https://pdf.cdn.readpaper.com/parsed/fetch_target/fe95d3164d4c868cd30406f698068bdf_10_Figure_3.png)

Decoder Attention:
![fig6](https://pdf.cdn.readpaper.com/parsed/fetch_target/fe95d3164d4c868cd30406f698068bdf_12_Figure_6.png)

作者猜想：Encoder 关注全局信息，Decoder 关注边界/局部信息

*We hypothesise that after the encoder has separated instances via global attention, the decoder only needs to attend to the extremities to extract the class and object boundaries.*



## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
