# Python 杂项

## objprint

```python
from objprint import op

op.config(color=True, line_number=True, arg_name=True)
op.install()
```

## better argparse

https://github.com/swansonk14/typed-argument-parser

竞品比较
- argparse：标准库，但是缺少代码补全，因为用了魔法（或者说魔法不够多）
- tap（本节）：
    - python原生，通过定义类+类型标注的方式生成元数据，所以有代码补全
    - ~~功能是否全面还有待观察~~
- docopt（在[CS224n作业里](https://web.stanford.edu/class/archive/cs/cs224n/cs224n.1214/assignments/a4.pdf)看到的）：
    - 需要自己写完整document，通过文档生成元数据，似乎有点麻烦
    - 支持了很多语言，或许其他语言可以试试

## Python 环境

### 换源

#### conda

清华源：https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/

```bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
```

或者直接写在 `~/.condarc` 中，见上文链接

### conda sync

#### 直接同步

一般来说虚拟环境在 <u>~/.conda</u> 下

scp 同步

下面的命令可以查看 conda 环境的安装位置

```
conda info
conda info -e
conda env list
```

#### 元数据同步

##### conda env

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

##### pip env: requirements.txt

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

## Python 并发

多进程（进程池）： https://superfastpython.com/processpoolexecutor-in-python/

GIL： https://en.wikipedia.org/wiki/Global_interpreter_lock

GIL 导致 python 解释器是单线程的，任何多线程的 python 程序，本质上是由单线程的 python 解释器在跑，所以任何依赖于 python 字节码的计算都是单线程的。python 多线程的正确应用场景：线程是 IO bound 的，而不是 CPU bound 的（或者说不以 python 字节码为主）

不过，只要用多进程就能规避 GIL 的影响，因为多进程跑了多个 python 解释器。

多线程（线程池）： https://superfastpython.com/threadpoolexecutor-in-python/

## 代码规范

[Google style](https://google.github.io/styleguide/)

一些重点：
- [Comprehensions & Generator Expressions](https://google.github.io/styleguide/pyguide.html#27-comprehensions--generator-expressions)
- [Indentation](https://google.github.io/styleguide/pyguide.html#indentation)
- [type-annotations](https://google.github.io/styleguide/pyguide.html#type-annotations)
- [Naming](https://google.github.io/styleguide/pyguide.html#316-naming)

## 运算符 -> 函数

[operator — Standard operators as functions — Python 3.11.2 documentation](https://docs.python.org/3/library/operator.html#mapping-operators-to-functions)
