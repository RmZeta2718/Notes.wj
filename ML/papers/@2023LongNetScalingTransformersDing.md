---
aliases: ["LongNet: Scaling Transformers to 1,000,000,000 Tokens", "LongNet: Scaling Transformers to 1,000,000,000 Tokens, 2023"]
---
# LongNet: Scaling Transformers to 1,000,000,000 Tokens

- **Journal**: arxiv:2307.02486
- **Author**: Jiayu Ding, Shuming Ma, Li Dong, Xingxing Zhang, Shaohan Huang, Wenhui Wang, Furu Wei
- **Year**: 2023
- **URL**: http://arxiv.org/abs/2307.02486
- [**Zotero**](zotero://select/items/@2023LongNetScalingTransformersDing)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=1858940418413090560&noteId=1862231726845828608)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

长序列的意义：
- 更强的记忆能力，提升模型感受野，对与人类和世界交互有帮助
- 包含更多的复杂的因果链和推理链，模型在训练时可以更加充分地利用数据
- 探索在超长序列上in-context learning的能力，避免因持续学习导致的灾难性遗忘。

## 论文的总体贡献

LongNet
- 线性时间复杂度，token之间对数依赖（无法理解）
- 可以分布式地在超长序列上训练
- dilated attention是即插即用的，可以集成到已有的模型上。且可以利用现有的所有优化方法（如量化）

官方代码： [torchscale/torchscale/component/dilated_attention.py at main · microsoft/torchscale (github.com)](https://github.com/microsoft/torchscale/blob/main/torchscale/component/dilated_attention.py)

非官方代码： [dilated-attention-pytorch/dilated_attention_pytorch/dilated_attention.py at main · fkodom/dilated-attention-pytorch (github.com)](https://github.com/fkodom/dilated-attention-pytorch/blob/main/dilated_attention_pytorch/dilated_attention.py)

## 论文提供的关键元素、关键设计

### 总体流程

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/e0d48c233f7baccf79681c78c9f79b7b_3_Figure_2_-83808065.png)

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

数据集：Stack，a source code collection in over 300 programming languages

PPL


## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
