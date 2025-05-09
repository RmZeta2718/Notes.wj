---
aliases:
  - "DuoAttention: Efficient Long-Context LLM Inference with Retrieval and Streaming Heads"
  - "DuoAttention: Efficient Long-Context LLM Inference with Retrieval and Streaming Heads, 2024"
---
# DuoAttention: Efficient Long-Context LLM Inference with Retrieval and Streaming Heads

- **Journal**: arXiv:2410.10819 #ICLR/25
- **Author**: Guangxuan Xiao, Jiaming Tang, Jingwei Zuo, Junxian Guo, Shang Yang, Haotian Tang, Yao Fu, Song Han
- **Year**: 2024
- **URL**: http://arxiv.org/abs/2410.10819
- [**Zotero**](zotero://select/items/@2024DuoAttentionEfficientLongContextXiao)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

## 论文的总体贡献

通过端到端的监督信号（而非只关注attn得分），识别retrieval head，并训练streaming和full attn结合的attn

- 训练时：
    - 结构上引入streaming和full attn的线性组合
    - 通过蒸馏loss（引入线性组合前后的最后隐层表示的MSE loss）训练线性组合系数
    - 通过系数的L1正则化，驱使模型倾向于streaming attn
    - 训练数据：passkey（而非普通文本），保证监督信号充分（所有监督信号均用于识别压缩策略）
- 推理时：
    - 选择一个超参数，将线性组合系数二值化为0/1，从而压缩kv cache
    - 重排序两种head，从而可以直接切片而非 scattering and gathering
    - streaming head prefilling：分块处理。本就是推理时的常见优化，与本方法可以结合

## 论文提供的关键元素、关键设计

### 总体流程

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
