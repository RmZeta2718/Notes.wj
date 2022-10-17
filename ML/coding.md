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

scp同步

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

从右向左逐项检查shape：

- 相等
- 有一个是1，把1广播成另一个的大小
- 维度较小的那一个可以向左填充1（即 $n\times m$ 可以看成 $1\times1\times\cdots\times1\times n\times m$ ）

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

### 基础GPU监控

N卡之间的互连方式（Display topological information about the system.）

```
nvidia-smi topo -m
```



### wandb



# 神经网络

### 初始化

权重 $w$ 必须随机初始化，否则每个神经元都是对称的，梯度下降结果永远相同

偏置 $b$ 在 $w$ 已经初始化的情况下不需要随机，可以全0

随机初始化通常 $\times 0.01$ ——用较小的值初始化。如果初始化值较大，如果用了 sigmoid 或 tanh 这样的激活函数，那么梯度下降就会很慢。如果不用这样的激活函数就无所谓。

如果网络较深，需要采用其他初始化策略



https://www.bilibili.com/video/BV1FT4y1E74V?p=35&spm_id_from=pageDriver
