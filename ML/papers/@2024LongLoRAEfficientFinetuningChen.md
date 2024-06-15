---
aliases:
  - "LongLoRA: Efficient Fine-tuning of Long-Context Large Language Models"
  - "LongLoRA: Efficient Fine-tuning of Long-Context Large Language Models, 2024"
  - LongLoRA
---

# LongLoRA: Efficient Fine-tuning of Long-Context Large Language Models

- **Journal**: arxiv:2309.12307 #ICLR/24
- **Author**: Yukang Chen, Shengju Qian, Haotian Tang, Xin Lai, Zhijian Liu, Song Han, Jiaya Jia
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2309.12307
- [**Zotero**](zotero://select/items/@2024LongLoRAEfficientFinetuningChen)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=4864873844552237057&noteId=2356478157974563072)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

> PE 的 OOD 和 attention 的 OOD 有什么关联？本文（相当于？）只解决了 PE 的 OOD，而假设 attention 不存在 OOD
> Token 数量是否是 OOD 的原因？从本文的结论来看，似乎不是

## 论文的总体贡献

PI + $S^2$-Attn + PEFT(LoRA+Norm+Embed)

## 论文提供的关键元素、关键设计

$S^2$-Attn (shifted sparse attention)

![](https://pdf.cdn.readpaper.com/parsed/fetch_target/5be9deb96d9af2e0482f0ec4ffaf34b9_2_Figure_3_-1366528249.png)

### 总体流程

S2-Attn

```python
# B: batch size; S: sequence length or number of tokens; G: group size;
# H: number of attention heads; D: dimension of each attention head
# qkv in shape (B, N, 3, H, D), projected queries, keys, and values
# Key line 1: split qkv on H into 2 chunks, and shift G/2 on N
qkv = cat(
    (
        qkv.chunk(chunks=2, dim=3)[0],
        qkv.chunk(chunks=2, dim=3)[1].roll(shifts=-G/2, dim=1)
    ),
    dim=3,
).view(B*N/G, G, 3, H, D)
# standard self-attention function
out = self_attn(qkv)
# out in shape (B, N, H, D)
# Key line 2: split out on H into 2 chunks, and then roll back G/2 on N
out = cat(
    (
        out.chunk(chunks=2, dim=2)[0],
        out.chunk(chunks=2, dim=2)[1].roll(shifts=G/2, dim=1)
    ),
    dim=2,
)
```

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

简单的 LoRA FT 不能用于长度扩展，需要加上 Normalization 和 Embedding

![tab2](https://pdf.cdn.readpaper.com/parsed/fetch_target/5be9deb96d9af2e0482f0ec4ffaf34b9_5_Table_2_-129521261.png)

用稀疏注意力 FT 的 long context 模型，可以在测试时用稠密注意力

![tab6](https://pdf.cdn.readpaper.com/parsed/fetch_target/5be9deb96d9af2e0482f0ec4ffaf34b9_8_Table_6_467816176.png)

## 相关研究

%% 如何归类。值得关注的研究员 %%
