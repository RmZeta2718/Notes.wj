---
aliases: ["In-context Learning and Induction Heads", "In-context Learning and Induction Heads, 2022"]
---
# In-context Learning and Induction Heads

- **Journal**: Transformer Circuits Thread
- **Author**: Catherine Olsson
- **Year**: 2022
- **URL**: https://transformer-circuits.pub/2022/in-context-learning-and-induction-heads/index.html
- [**Zotero**](zotero://select/items/@2022IncontextLearningInductionCatherineOlsson)

## 论文试图解决的问题

%% 是否是新的问题。现状、难点。motivation %%

### Mechanistic interpretability

定义：attempting to reverse engineer the detailed computations performed by the model
- Mechanistic interpretability is a subset of the broader field of interpretability, which encompasses many different methods for explaining the outputs of a neural network.
- Mechanistic interpretability is distinguished by a specific focus on trying to systematically characterize the internal circuitry of a neural net.

作用
- 更系统地定位和预测大模型的安全和伦理相关问题

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### induction heads

https://transformer-circuits.pub/2021/framework/index.html

指出两层的 Attention 存在如下行为（这种行为似乎是 in-context learning 的来源）：
> 2-layer induction heads “complete the pattern” by copying and completing sequences that have occurred before. `[A][B] … [A] → [B]`

具体来说：
- 第一层注意力头会把 A 的信息复制到每个 token 上
- 第二层注意力头（也就是 induction head）试图寻找曾经出现过的 A，然后输出曾经的 A 后面的 B

并且 induction heads 没有尝试记住一个 AB 的统计表格，而是倾向于将 AB 分离开，AB 可以是任意的。所以这也导致 induction heads 可以 OOD （out of distribution）地工作。

但是更多层 Attention，或者 MLP 的加入，都让事情变得十分复杂，无法从数学上确定模型对应的电路（circuitry）。因此只能间接地——从经验上观察、扰动这些模型。

本文提出假设：induction heads 或许是大模型能够实现 in-context learning 的核心机制，存在类似于 2-layer induction heads 的机制，即存在一种“fuzzy” or “nearest neighbor” version of pattern completion `[A*][B*] … [A] → [B]` ，其中 `A* ≈ A` ，`B* ≈ B` 在某个空间内成立。

通过如下实验佐证本文的假设：
1. **Macroscopic co-occurrence**： LLM 训练中会经历一个 phase change，此时 induction heads 形成，且 in-context learning 的能力大幅提升
2. **Macroscopic co-perturbation**：对 LLM 的结构进行扰动，干扰 induction heads 形成的时间，in-context learning 的性能也相应偏移
3. **Direct ablation**：测试时显式破坏小模型的 induction heads，in-context 性能也会显著下降
4. **Specific examples of induction head generality**：虽然对 induction heads 的定义是复制序列，但是经验上观察到它们也能实现更高级的 in-context learning，包括一些抽象的行为。
5. **Mechanistic plausibility of induction head generality**：基于小模型解释 induction heads 的工作方式，及其对 in-context 的贡献。这种机制也暗示它可以自然地迁移到一般的 in-context 中。
6. **Continuity from small to large models**：前 5 个实验的结论，在小模型上表现得更显著，而一些行为和数据表明，这些结论可以平滑地迁移到大模型上。

## 实验

%% 实现细节、设置。数据集。评估。消融实验 %%

### 评估

**In-context learning score**: the loss of the 500th token in the context minus the average loss of the 50th token in the context, averaged over dataset examples.
- 位置是随意选取的：500 比较接近末尾；50 接近开头，且已经有了一些信息

**Per-Token Loss Analysis**:
1. 在模型或快照上跑同一个测试集，每个测试句子收集一个 token 的 loss
2. 将这些 token 的 loss 组成一个向量，表示这个模型或快照的 loss
3. 通过主成分分析（PCA）降维到 2D 并可视化

### Argument 1

phase change

![[derivative of loss with respect to log token index.png]]

![[per-token loss PCA.png]]

![[per-token losses over training.png]]

### Argument 2

#### smeared key

期望通过扰动，使 1 层的 Attention 也可以有 phase change，多层的 Attention 可以更早地 phase change

对每个头 $h$ 有一个可学习的参数 $\alpha^h$ ，将 $\sigma(\alpha^{h}) \in[0,1]$ 作为插值系数，对当前 token 和前一个 token 的 key 进行插值。
$$
k_{j}^{h}=\sigma\left(\alpha^{h}\right) k_{j}^{h}+\left(1-\sigma\left(\alpha^{h}\right)\right) k_{j-1}^{h}
$$

![[smeared key in-context learning score.png]]

由于扰动形式比较特殊，不一定能推广到大模型。

### 其他

#### in-context learning score

in-context learning score 似乎与模型无关，只要经过了 phase change，各个模型的 score 都差不多。

但是大模型 loss 仍然是更低的，只不过差值相同。

*It seems that large models are able to pull a lot of information out of the very early context.*

#### Phase Change Effect on Loss Derivatives

phase change 时 loss 剧烈波动，且前后大小模型的 loss 的相对关系翻转（前面小模型 loss 大，后面大模型 loss 大）

![[loss derivative order appears to invert at phase change.png]]

## 后续工作

%% 有什么疑问。如何继续深入。如何吸取到你的工作中 %%

## 相关研究

%% 如何归类。值得关注的研究员 %%
