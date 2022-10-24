# Python

## 换源

### conda

清华源：https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/

```bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
```

或者直接写在 `~/.condarc` 中，见上文链接

## conda sync

### 直接同步

一般来说虚拟环境在 <u>~/.conda</u> 下

scp 同步

下面的命令可以查看 conda 环境的安装位置

```
conda info
conda info -e
conda env list
```

### 元数据同步（not tested）

#### conda env

machine1:

```
conda env export > myenv.yml
```

machine2:

```
conda env create -f myenv.yml
# or
conda env update -f myenv.yml --prune
```

https://superuser.com/questions/1578221/synchronize-multiple-anaconda-installations

#### pip env: requirements.txt

导出当前环境依赖：

```bash
pip list --format=freeze > requirements.txt
```

或者 https://github.com/bndr/pipreqs ：

```bash
pipreqs
```

> `pip freeze` 会导致部分 conda 安装的包无法正常显示 https://stackoverflow.com/a/57845418/17347885

根据 `requirements.txt` 安装依赖：

```bash
pip install -r requirements.txt
```

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
