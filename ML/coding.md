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

### 分布式

https://pytorch.org/tutorials/intermediate/ddp_tutorial.html

### 复现/Reproducibility

https://pytorch.org/docs/stable/notes/randomness.html

### 调优

https://pytorch.org/tutorials/recipes/recipes/tuning_guide.html

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

**该方法的局限性**：内置 Module 不适用（需要pytorch自己定义 `__call__` ）

> 但是内置 Module 的返回类型比较简单（例如就是 `torch.Tensor`），所以勉强可以接受。只有自己写的 Module 可能需要 typing 复杂类型（例如多个返回值）

**原因**：函数调用本质上调了基类 `nn.Module` 的 `__call__` ，根据源码（<u>torch/nn/modules/module.py</u>），它的返回类型是 `Any`，虽然内部调用了 `forward` ，但是 typing 并不能从代码中推断出 `__call__` 的真实返回类型。所以前面的解决方案就是直接重写子类的 `__call__` 方法，这样就能 typing 了。

```python
    __call__ : Callable[..., Any] = _call_impl
```

不过这个方法也不是完美的，`__call__` 的返回类型有报错：type incompatible， [这个 thread](https://github.com/pytorch/pytorch/issues/35566) 有一些分析（主要结论是违反了Liskov substitutability）。不过这里的类型报错不影响使用。

此外，不建议直接调 `forward` ，因为 `__call__` 里还有 hook 等其他处理。

相关内容：
- [相关issue](https://github.com/pytorch/pytorch/issues?q=is%3Aissue+label%3A%22module%3A+typing%22+call+in%3Atitle)
- 1.4之后pyi文件没了是因为[inline了](https://github.com/pytorch/pytorch/issues/36915#issuecomment-692999314)
- [一个proxy trick(works for pycharm and mypy but not vscode)以及关于内置module的讨论](https://github.com/pytorch/pytorch/issues/74746)
- 我的[提问](https://discuss.pytorch.org/t/how-to-get-correct-typing-from-nn-module-call/171577)

#### 灵异事件

pytorch1.4 有 pyi 文件，内置了 `__call__` trick，但是 pytorch1.12 没有了。不知道是安装方式问题还是其他原因。

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

https://www.bilibili.com/video/BV1FT4y1E74V?p=35&spm_id_from=pageDriver

# Performance (on Nvidia GPU)

https://docs.nvidia.com/deeplearning/performance/index.html

## 性能瓶颈

https://docs.nvidia.com/deeplearning/performance/dl-performance-gpu-background/index.html

影响 GPU 性能的三个因素：
- 显存带宽（memory bandwidth）
- 计算带宽（math bandwidth）
- 延迟（latency）

$$
T_\text{math}/T_\text{mem}=\dfrac{\#\text{ops}}{\mathrm{BW_{math}}}\left/\dfrac{\#\text{bytes}}{\mathrm{BW_{mem}}}\right.=\dfrac{\#\text{ops}}{\#\text{bytes}}\left/\dfrac{\mathrm{BW_{math}}}{\mathrm{BW_{mem}}}\right.
$$

- $\dfrac{\#\text{ops}}{\#\text{bytes}}$ 取决于算法，称作算术强度（Arithmetic Intensity）。单位：`FLOPS/B`
- $\dfrac{\mathrm{BW_{math}}}{\mathrm{BW_{mem}}}$ 取决于硬件，称作 `ops: byte` 比率。

于是，如果算法的 Arithmetic Intensity 大于硬件的 `ops: byte` 比率，则是计算瓶颈（math limited），即 GPU 性能饱和，否则是内存瓶颈（memory limited），即没有用满 GPU 性能。

### 常见运算

- Elementwise Operations：一元或二元运算符
    - 内存瓶颈
    - 如：非线性运算（sigmoid、ReLU）、数乘、数加、矩阵加
- Reduction Operations： tensor to number
    - 内存瓶颈
    - 如：池化、Batch Norm、 Softmax
- Dot-Product Operations：
    - 矩阵足够大时是计算瓶颈，矩阵太小时是内存瓶颈
    - 如：全连接，卷积

## 矩阵乘法

https://docs.nvidia.com/deeplearning/performance/dl-performance-matrix-multiplication/index.html

对于矩阵 $A_{M\times K},B_{K\times N}$ ：

$$
\text {Arithmetic Intensity}=\frac{\text {number of FLOPS}}{\text {number of byte accesses}}=\frac{2 \cdot(M \cdot N \cdot K)}{2 \cdot(M \cdot K+N \cdot K+M \cdot N)}=\frac{M \cdot N \cdot K}{M \cdot K+N \cdot K+M \cdot N}
$$

例如：
- $M=8192,N=128,K=8192$ ，则 Arithmetic Intensity 是 `124.1 FLOPS/B` ，比 V100 GPU 的 `138.9 FLOPS: B` 要低，所以是内存瓶颈（memory limited）
- 对于矩阵和向量的乘法，有 $M=1$ 或者 $N=1$ 。这种情况下总是内存瓶颈，因为 Arithmetic Intensity 总是小于 1

### 对齐

矩阵的大小是某个值的倍数。这个值与运算的类型（INT8、FP16、TF32、FP64）和库版本（cuBLAS、cuDNN）有关。通常是 2 的幂，越大越好。

实际上 GPU 已经做了优化（不用那么关心对齐问题），但是如果能对齐，性能会好一些。

因此，隐藏层维度最好设置为 512、1024 等足够大的“整数”。

## 混合精度

优点：
- 占据更少的内存
- 需要更小的内存带宽
- 计算速度更快

缺点：
- 降低模型性能（也有可能持平）

实践： https://developer.nvidia.com/automatic-mixed-precision

### 数值类型

https://blogs.nvidia.com/blog/2020/05/14/tensorfloat-32-precision-format/

TF32 类型：1 位符号位、8 位指数位、10 位尾数位

# 代码框架

[深度学习里面，请问有写train函数的模板吗？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/523869554)
