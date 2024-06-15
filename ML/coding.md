# numpy

## 最佳实践

```python
assert a.shape == (n, m)  # act as documentation
```

## 广播 Broadcasting

### 简单广播

$A_{n\times m}+b_{n\times 1}\rightarrow A_{n\times m}+B_{n\times m}$

$A_{n\times m}+b_{1\times m}\rightarrow A_{n\times m}+B_{n\times m}$

$a_{n\times 1}+b_{1\times1}\rightarrow a_{n\times 1}+b_{n\times1}$

### 一般规则

https://numpy.org/doc/stable/user/basics.broadcasting.html#general-broadcasting-rules

从右向左逐项检查 shape：

- 相等
- 有一个是 1，把 1 广播成另一个的大小
- 维度较小的那一个可以向左填充 1（即 $n\times m$ 可以看成 $1\times1\times\cdots\times1\times n\times m$ ）

不兼容则 ValueError

广播举例：

```
A      (4d array):  8 x 1 x 6 x 1
B      (3d array):      7 x 1 x 5
Result (4d array):  8 x 7 x 6 x 5
```

### 常见错误

行向量+列向量会广播成矩阵，但这通常不是你想要的结果，只是你忘记转置了。

## shape

```python
a = np.random.randn(5)  # DO NOT USE
a.shape  # (5,)  rank 1 array, behave strangely on transpose and 

a = np.random.randn(5,1)  # good
a.shape  # (5,1)
```

# pytorch

pytorch 文档七宗罪：
- tutorial 不够入门，很多细节完全不讲，要自己查 document，甚至上论坛问
    - 当然，导致论坛比较活跃，或许是个优点
- 左侧导航栏不会自动跳转到当前位置，右侧导航栏不会自动高亮，总是不知道自己在看哪里的文档
- 左侧导航栏仅为顶层目录，有时会错过一些文档，这也是为什么找不着自己在看哪里。

### 增加维度 add new dimension

https://stackoverflow.com/a/59603631

### 内存连续性

- [python - What is the difference between contiguous and non-contiguous arrays? - Stack Overflow](https://stackoverflow.com/questions/26998223/what-is-the-difference-between-contiguous-and-non-contiguous-arrays/26999092#26999092)
- [Difference between view, reshape, transpose and permute in PyTorch - jdhao's digital space](https://jdhao.github.io/2019/07/10/pytorch_view_reshape_transpose_permute/#but-what-does-contiguous-mean)

### 分布式

 [基础数据并行（DDP）](https://pytorch.org/tutorials/intermediate/ddp_tutorial.html)

 [ZeRO-DP](https://pytorch.org/tutorials/recipes/zero_redundancy_optimizer.html)

 [ZeroRedundancyOptimizer](https://pytorch.org/tutorials/recipes/zero_redundancy_optimizer.html) （无用的文档，存在上位替代。。pytorch文档真烂）

### 复现/Reproducibility

 [李沐关于可重复性的讨论](https://www.bilibili.com/video/BV1Y5411c7aY/?p=3&share_source=copy_web&vd_source=ff9df13d97e77634f0683a5b6f354918&t=203)
- 如何保证可重复性
    - 随机数种子
    - 禁用 cudnn：cudnn 加速矩阵计算会乱序计算，因为浮点误差，所以每次乱序计算的结果不一样
- 但是实际上不用太关注可重复性，随机性也意味着稳定性、鲁棒性。我们最终想要的是模型的可用性，所以要设计出对初始值等随机因素不敏感的模型。

https://pytorch.org/docs/stable/notes/randomness.html

### 计算性能优化

https://pytorch.org/tutorials/recipes/recipes/tuning_guide.html

key points：
- [Disable gradient calculation for validation or inference](https://pytorch.org/tutorials/recipes/recipes/tuning_guide.html#disable-gradient-calculation-for-validation-or-inference)
- [Avoid unnecessary CPU-GPU synchronization](https://pytorch.org/tutorials/recipes/recipes/tuning_guide.html#avoid-unnecessary-cpu-gpu-synchronization)
    - `print(tensor)`
    - `cuda_tensor.item()`，`cuda_tensor.nonzero()`
    - 内存复制： `tensor.to(device)`
    - 依赖于 cuda tensor 的 python 控制流 `if (cuda_tensor != 0).all()`
- [Pre-allocate memory in case of variable input length](https://pytorch.org/tutorials/recipes/recipes/tuning_guide.html#pre-allocate-memory-in-case-of-variable-input-length)

https://docs.nvidia.com/deeplearning/performance/index.html#optimizing-performance

### tensorboard

https://pytorch.org/tutorials/recipes/recipes/tensorboard_with_pytorch.html

### profiler

https://pytorch.org/tutorials/recipes/recipes/profiler_recipe.html

benchmark by 李沐

https://github.com/mli/transformers-benchmarks

### typing nn.Module

**问题描述（错误方案）**：`nn.Module` 给 `forward` 加 typing，然后通过函数调用的方式（`foo()`）调用该 Module，返回类型的 typing 为 `Any` （pytorch 的内置 Module 就是这样做的，但是等于没做）

```python
class Foo(nn.Module):
    def forward(self, param1: torch.Tensor) -> torch.Tensor:
        print('Foo.forward')
        return param1

foo = Foo()
x = foo()  # x: Any
# x = foo.forward()  # don't do this, although typing works
```

**解决方案**：复制 `forward` 的 typing，定义 `__call__` ，调用 super 的 call，把所有参数传进去。

https://discuss.pytorch.org/t/adding-typing-to-call-of-nn-module/118295

```python
class Foo(nn.Module):
    def __call__(self, param1: torch.Tensor) -> torch.Tensor:
        return super().__call__(param1)

    def forward(self, param1: torch.Tensor) -> torch.Tensor:
        print('Foo.forward')
        return param1

foo = Foo()
x = foo()  # x: torch.Tensor
```

**该方法的局限性**：内置 Module 不适用（需要 pytorch 自己定义 `__call__` ）

> 但是内置 Module 的返回类型比较简单（例如就是 `torch.Tensor`），所以勉强可以接受。只有自己写的 Module 可能需要 typing 复杂类型（例如多个返回值）

**原因**：函数调用本质上调了基类 `nn.Module` 的 `__call__` ，根据源码（<u>torch/nn/modules/module.py</u>），它的返回类型是 `Any`，虽然内部调用了 `forward` ，但是 typing 并不能从代码中推断出 `__call__` 的真实返回类型。所以前面的解决方案就是直接重写子类的 `__call__` 方法，这样就能 typing 了。

```python
    __call__ : Callable[..., Any] = _call_impl
```

不过这个方法也不是完美的，`__call__` 的返回类型有报错：type incompatible， [这个 thread](https://github.com/pytorch/pytorch/issues/35566) 有一些分析（主要结论是违反了Liskov substitutability）。不过这里的类型报错不影响使用。

此外，不建议直接调 `forward` ，因为 `__call__` 里还有 hook 等其他处理。

相关内容：
- [相关 issue](https://github.com/pytorch/pytorch/issues?q=is%3Aissue+label%3A%22module%3A+typing%22+call+in%3Atitle)
- 1.4 之后 pyi 文件没了是因为 [inline 了](https://github.com/pytorch/pytorch/issues/36915#issuecomment-692999314)
- [一个 proxy trick(works for pycharm and mypy but not vscode)以及关于内置 module 的讨论](https://github.com/pytorch/pytorch/issues/74746)
- 我的 [提问](https://discuss.pytorch.org/t/how-to-get-correct-typing-from-nn-module-call/171577)

#### 灵异事件

pytorch1.4 有 pyi 文件，内置了 `__call__` trick，但是 pytorch1.12 没有了。不知道是安装方式问题还是其他原因。

# Huggingface

## datasets

预处理根据运行时相关函数和参数的 Hash 来复用预处理的 cache。需要避免 Hash 变化导致的重复预处理。具体来说：

- datasets 库版本需要保持一致
- `datasets.map()` 的 function 中不能直接用 args，否则非 dataset 相关 args 的变化会导致整个 Hash 变化。解决方案：用 partial 包一下，用到的每个 args 单独传进去（或仅传入 dataset 相关 args 的子 dataclass，而非整个 args dataclass）

> 实际上 huggingface 的 example 没有这个问题，因为 dataset args 是单独的 dataclass，在我把各个 args 组合为大的 dataclass 才导致的这个问题。

### 加载缓慢

通过 viztracer，看到 `_memory_mapped_arrow_table_from_file (datasets/table.py)` 中的 `RecordBatchStreamReader.read_all` 占用了大量时间。（v2.14.6）

搜索相关 issue：
- [Slow dataloading with big datasets issue persists · Issue #2252 · huggingface/datasets](https://github.com/huggingface/datasets/issues/2252)
    -
- 可能的改进： [Load a cached dataset as iterable · Issue #5481 · huggingface/datasets](https://github.com/huggingface/datasets/issues/5481)

## transformers

### config

 `PretrainedConfig.from_pretrained.kwargs` [doc](https://huggingface.co/docs/transformers/main_classes/configuration#transformers.PretrainedConfig.from_pretrained.kwargs) 是初始化之后覆盖，因此这里添加的参数在 `__init__()` 中不可见

> 见 [transformers/configuration_utils.py#L747](https://github.com/huggingface/transformers/blob/05de038f3d249ce96740885f85fd8d0aa00c29bc/src/transformers/configuration_utils.py#L747) ~ [transformers/configuration_utils.py#L763](https://github.com/huggingface/transformers/blob/05de038f3d249ce96740885f85fd8d0aa00c29bc/src/transformers/configuration_utils.py#L763)

在 `from_pretrained()` 里传模型 config 需要谨慎，避免 config 变量名与 HF 参数重名

### resize token embedding

`transformers/modeling_utils.py:1538(v4.35.2)`

- 通过模型定义的 `get_input_embeddings()` 和 `get_output_embeddings()` 获得输入输出 embedding
- 创建新的 embedding module：`transformers/modeling_utils.py:1682`
- 将旧的数据复制过去（无梯度）：`transformers/modeling_utils.py:1704`
- 同时迁移 embedding 模块上的 hook，否则会导致错误（例如 `device_map = 'auto'` 用到了 hook： [issue](https://github.com/huggingface/transformers/issues/25554#issuecomment-1683021010) ）
- 重新绑定输入输出 embedding：`modeling_utils.py:1572`

### transformers + flash attention

 [How to use Flash Attention 2 with huggingface models ? · Issue #320 · Dao-AILab/flash-attention (github.com)](https://github.com/Dao-AILab/flash-attention/issues/320)

 [Overview (huggingface.co)](https://huggingface.co/docs/optimum/bettertransformer/overview)

 [torch.nn.functional.scaled_dot_product_attention — PyTorch master documentation](https://pytorch.org/docs/master/generated/torch.nn.functional.scaled_dot_product_attention)

huggingface llama + flash attention: [[`core` ] Integrate Flash attention 2 in most used models by younesbelkada · Pull Request #25598 · huggingface/transformers (github.com)](https://github.com/huggingface/transformers/pull/25598)

blog [Extended Guide: Instruction-tune Llama 2](https://www.philschmid.de/instruction-tune-llama-2)

### trainer

根据 [文档](https://huggingface.co/docs/transformers/main_classes/trainer#transformers.Trainer.get_train_dataloader) ，trainer 的 dataloader 在 dataset 支持 len 时默认使用随机 sampler，否则（例如 streaming dataset）不使用 sampler ([论坛](https://discuss.huggingface.co/t/how-to-ensure-the-dataset-is-shuffled-for-each-epoch-using-trainer-and-datasets/4212/5))

## tricks

### 仅加载模型结构

load model without init

```python
from accelerate import init_empty_weights
from transformers import AutoModelForCausalLM

with init_empty_weights():
    model = AutoModelForCausalLM.from_pretrained("gpt2")
```

> 不要在 `init_empty_weights` 里比较参数是否相同（`parameter is parameter`）

# Monitor

### 基础 GPU 监控

N 卡之间的互连方式（Display topological information about the system.）

```
nvidia-smi topo -m
```

### wandb

# 神经网络

### 初始化

权重 $w$ 必须随机初始化，否则每个神经元都是对称的，梯度下降结果永远相同

偏置 $b$ 在 $w$ 已经初始化的情况下不需要随机，可以全 0

随机初始化通常 $\times 0.01$ ——用较小的值初始化。如果初始化值较大，如果用了 sigmoid 或 tanh 这样的激活函数，那么梯度下降就会很慢。如果不用这样的激活函数就无所谓。

如果网络较深，需要采用其他初始化策略

初始化主要目标是不让网络在一开始训练时梯度爆炸、消失

https://www.bilibili.com/video/BV1FT4y1E74V?p=35&spm_id_from=pageDriver

# CUDA

## Performance

https://docs.nvidia.com/deeplearning/performance/index.html

### 性能瓶颈

https://docs.nvidia.com/deeplearning/performance/dl-performance-gpu-background/index.html

影响 GPU 性能的三个因素：
- 显存带宽（memory bandwidth）
- 计算带宽（math bandwidth）
- 延迟（latency）

$$
T_\text{math}/T_\text{mem}=\dfrac{\#\text{ops}}{\mathrm{BW_{math}}}\left/\dfrac{\#\text{bytes}}{\mathrm{BW_{mem}}}\right.=\dfrac{\#\text{ops}}{\#\text{bytes}}\left/\dfrac{\mathrm{BW_{math}}}{\mathrm{BW_{mem}}}\right.
$$

- $\dfrac{\#\text{ops}}{\#\text{bytes}}$ 取决于算法，称作算术强度（Arithmetic Intensity）。单位：`FLOPs/B`
- $\dfrac{\mathrm{BW_{math}}}{\mathrm{BW_{mem}}}$ 取决于硬件，称作 `ops: byte` 比率。

于是，如果算法的 Arithmetic Intensity 大于硬件的 `ops:byte` 比率，则是计算瓶颈（math limited），即 GPU 性能饱和，否则是内存瓶颈（memory limited），即没有用满 GPU 性能。

#### 常见运算

- Elementwise Operations：一元或二元运算符
    - 内存瓶颈
    - 如：非线性运算（sigmoid、ReLU）、数乘、数加、矩阵加
- Reduction Operations： tensor to number
    - 内存瓶颈
    - 如：池化、Batch Norm、 Softmax
- Dot-Product Operations：
    - 矩阵足够大时是计算瓶颈，矩阵太小时是内存瓶颈
    - 如：全连接，卷积

### 矩阵乘法

https://docs.nvidia.com/deeplearning/performance/dl-performance-matrix-multiplication/index.html

对于矩阵 $A_{M\times K},B_{K\times N}$ ：

$$
\text {Arithmetic Intensity}=\frac{\text {number of FLOPS}}{\text {number of byte accesses}}=\frac{2 \cdot(M \cdot N \cdot K)}{2 \cdot(M \cdot K+N \cdot K+M \cdot N)}=\frac{M \cdot N \cdot K}{M \cdot K+N \cdot K+M \cdot N}
$$

例如：
- $M=8192,N=128,K=8192$ ，则 Arithmetic Intensity 是 `124.1 FLOPs/B` ，比 V100 GPU 的 `138.9 FLOPs/B` 要低，所以是内存瓶颈（memory limited）
- 对于矩阵和向量的乘法，有 $M=1$ 或者 $N=1$ 。这种情况下总是内存瓶颈，因为 Arithmetic Intensity 总是小于 1

#### 对齐

矩阵的大小是某个值的倍数。这个值与运算的类型（INT8、FP16、TF32、FP64）和库版本（cuBLAS、cuDNN）有关。通常是 2 的幂，越大越好。

实际上 GPU 已经做了优化（不用那么关心对齐问题），但是如果能对齐，性能会好一些。

因此，隐藏层维度最好设置为 512、1024 等足够大的“整数”。

### 混合精度

优点：
- 占据更少的内存
- 需要更小的内存带宽
- 计算速度更快

缺点：
- 降低模型性能（也有可能持平）

实践： https://developer.nvidia.com/automatic-mixed-precision

#### 数值类型

https://blogs.nvidia.com/blog/2020/05/14/tensorfloat-32-precision-format/

TF32 类型：1 位符号位、8 位指数位、10 位尾数位

## CUDA 编程优化

https://www.bilibili.com/video/BV1Ey4y1c7wM

- Global Memory 需要合并访问（所有线程访问同一连续区域）
    - Warp 的线程读写 memory 时会被合并为尽可能少的 transaction
    - Stride 是典型的非合并访问的例子，访问的范围因为 stride 间隔而分得很开
- Shared Memory 避免 memory bank 冲突（避免所有线程访问同一个 bank）

### FHMA

https://www.bilibili.com/video/BV1Ey4y1c7wM/?t=1353

# 开源库

## 框架

 [深度学习里面，请问有写 train 函数的模板吗？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/523869554)

 [Pytorch Lightning 和 HuggingFace 的 Trainer 哪个好用？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/521501258)

 [Pytorch Lightning 完全攻略 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/353985363)

### AllenNLP

 [allenai/allennlp: An open-source NLP research library, built on PyTorch. (github.com)](https://github.com/allenai/allennlp)

 [nyu-mll/jiant: jiant is an nlp toolkit (github.com)](https://github.com/nyu-mll/jiant/tree/master)

## 工具

### einops

可以支持不同框架的 Tensor，代码： https://github.com/arogozhnikov/einops/blob/master/einops/_backends.py

> 为什么要 lazy import

见 docstring：
- backends may not be installed
- importing all available backends will drive to significant memory footprint
- backends may by present but installed with errors (but never used), importing may drive to crashes

> 如何 lazy import

 `get_backend()` 函数获取 Tensor 对应的后端框架，返回 `AbstractBackend` 这个抽象类接口。
 - 其核心逻辑是查看 `sys.modules` （其中记录了目前已经 import 的所有模块），做到只 import 已经成功 import 的模块。
 - 然后再通过 `is_appropriate_type()` 判断 Tensor 是否属于这个框架。这是个抽象函数，由各个后端对应的子类实现。例如 `numpy` 实现为 `isinstance(tensor, self.np.ndarray)`
# 杂项

23.02.18

Tensor.shape 是 Tensor.size() 的别名： [add shape alias by hughperkins · Pull Request #1983 · pytorch/pytorch (github.com)](https://github.com/pytorch/pytorch/pull/1983)
