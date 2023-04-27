# Python 杂项

## objprint

```python
from objprint import op

op.config(color=True, line_number=True, arg_name=True)
op.install()
```

## better argparse

### Tap

https://github.com/swansonk14/typed-argument-parser

竞品比较
- argparse：标准库，但是缺少代码补全，因为用了魔法（或者说魔法不够多）
- tap（本节）：
    - python 原生，通过定义类+类型标注的方式生成元数据，所以有代码补全
    - ~~功能是否全面还有待观察~~
- docopt（在 [CS224n 作业里](https://web.stanford.edu/class/archive/cs/cs224n/cs224n.1214/assignments/a4.pdf) 看到的）：
    - 需要自己写完整 document，通过文档生成元数据，似乎有点麻烦
    - 支持了很多语言，或许其他语言可以试试

### HfArgumentParser

https://huggingface.co/docs/transformers/v4.26.1/en/internal/trainer_utils#transformers.HfArgumentParser

类似于 tap

- 基于 dataclass 定义
- 文档不全面，因为以 huggingface 内部使用为主（官方用例是 [TrainingArguments](https://huggingface.co/docs/transformers/v4.26.1/en/main_classes/trainer#transformers.TrainingArguments) ），自己也可以用
- `from transformers.hf_argparser import HfArg` 可以用于声明字段（ [PR](https://github.com/huggingface/transformers/pull/20323) ），无文档，typing有问题（于是自己重写了）

## Package

 [__init__.py 样例](https://stackoverflow.com/a/29509611)

自动导入 dir 下所有 py（可能已经过时了）： https://stackoverflow.com/a/1057534

## Python 环境

### 换源

#### conda

清华源：https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/

```bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
```

或者直接写在 `~/.condarc` 中，见上文链接

### conda sync

#### 基于复制的同步

下面的命令可以查看 conda 环境的安装位置

```bash
conda info
conda info -e
conda env list
```

下面假设虚拟环境在 <u>~/.conda</u> 下

Linux 系统上，conda 会尝试硬链接 <u>~/.conda/pkgs</u> 以节省空间 [Is it safe to manually delete all files in pkgs folder in anaconda python? - Stack Overflow](https://stackoverflow.com/questions/56266229/is-it-safe-to-manually-delete-all-files-in-pkgs-folder-in-anaconda-python)

可以用 du 检验（ [du 可以正确计算 hardlink 情况下的磁盘空间占用](https://stackoverflow.com/questions/19951883/du-counting-hardlinks-towards-filesize) ）：`du` 只计算第一次遇到的硬链接，于是：
- `du -hcd 0 ~/.conda/envs ~/.conda/pkgs` ：<u>pkgs</u> 里有多少没有被 <u>envs</u> 引用（可清理空间）
- `du -hcd 0 ~/.conda/pkgs ~/.conda/envs` ：<u>envs</u> 里有多少没有被 <u>pkgs</u> 引用（未复用空间，可能因为错误地清理了 <u>pkgs</u>）

清理空间：
- `conda clean -t` 清理空间（删除 tar）
- **不要**用 `conda clean -a` 或 `conda clean -p` ，这会删除 <u>pkgs/</u> 下的硬链接，导致新环境无法复用存储空间。

如何在保留硬链接的情况下传输文件？
 - [`tar` preserve hard links](https://stackoverflow.com/questions/38333481/tar-archive-preserving-hardlinks) + `scp`（不要用纯 `scp`，不能正确处理硬链接）
 - [`rsync -H` preserve hard links](https://unix.stackexchange.com/questions/44247/how-to-copy-directories-with-preserving-hardlinks) ，但是 [据说](https://serverfault.com/questions/207370/rsync-with-hard-links-freezes/207693#207693) 内存占用很高，不适合大量文件（实践中可以，或许已经优化了）

从 `$host` 同步到本地：
```bash
rsync -avhH --partial-dir=.rsync-partial --delete $host:~/.conda ~/
```

该方法缺陷：需要用户名相同，否则部分库存在问题（使用了绝对路径的解释器）

#### 基于元数据的同步

本质上需要重新建立（下载）整个环境，效率较低

##### conda env

machine1:

```
conda env export > myenv.yml
```

machine2:

```bash
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

#### 基于 sshfs 的同步

根据 vscode 提供的教程（见[[terminal_notes#远程文件同步]]），我认为 conda 环境不适用于 sshfs。

经实验，rsync 可以工作，因此采用 rsync。

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

返回类型有多种，但是用户确切地知道是哪一种，如何更优雅地指定（open）：
- [AnyOf - Union for return types · Issue #566 · python/typing --- AnyOf - 返回类型联合 · Issue #566 · python/typing (github.com)](https://github.com/python/typing/issues/566)
- [Document why having a union return type is often a problem · Issue #1693 · python/mypy --- 记录为什么具有联合返回类型通常是一个问题 · Issue #1693 · python/mypy (github.com)](https://github.com/python/mypy/issues/1693)
