---
aliases:
  - "LongRoPE: Extending LLM Context Window Beyond 2 Million Tokens"
  - "LongRoPE: Extending LLM Context Window Beyond 2 Million Tokens, 2024"
  - LongRoPE
---

# LongRoPE: Extending LLM Context Window Beyond 2 Million Tokens

- **Journal**: arxiv:2402.13753
- **Author**: Yiran Ding, Li Lyna Zhang, Chengruidong Zhang, Yuanyuan Xu, Ning Shang, Jiahang Xu, Fan Yang, Mao Yang
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2402.13753
- [**Zotero**](zotero://select/items/@2024LongRoPEExtendingLLMDing)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=2193992302006420992&noteId=2356463258262913536)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### 8x extension without fine-tuning

前 $\hat{n}$ 个 token 保持不变，随后的 token 按维度（超参数）搜索最优 scale

搜索空间：

![tab4](https://pdf.cdn.readpaper.com/parsed/fetch_target/a5a48dbc104d5c815fd21b7f3903f81d_3_Table_4_109983830.png)

通过超参数搜索：4k → 32k （8x）

### Extending LLM Context Window to 2048K

- 搜索两组超参数：128k/256k (32x/64x)
    - 5B tokens evaluation, 1 x A100，3 days
- 在 128k/256k 长度上依次 FT（用对应的超参数）：128k 400 steps，256k 600 steps（比直接 256k FT 好）
    - 6.5B tokens (1.5B+5B)，8/16 x A100，1+2 weeks
- 超参数搜索到 2048k (8x, overall 512x)
    - 3B tokens evaluation, 8 x A100，5 days
- 对于短文本推理，额外搜索一组 4k/8k 的超参数

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
