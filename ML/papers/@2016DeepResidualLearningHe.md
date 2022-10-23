---
aliases: ["Deep Residual Learning for Image Recognition", "Deep Residual Learning for Image Recognition, 2016", "ResNet"]
---
# Deep Residual Learning for Image Recognition

- **Journal**: 2016 IEEE Conference on Computer Vision and Pattern Recognition (CVPR)
- **Author**: Kaiming He, Xiangyu Zhang, Shaoqing Ren, Jian Sun
- **Year**: 2016
- **URL**: 
- [**Zotero**](zotero://select/items/@2016heDeepResidualLearning)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=551653359610970112&noteId=742986815718449152)
- [bilibili](https://www.bilibili.com/video/BV1Fb4y1h73E/?spm_id_from=333.788&vd_source=0351845a83270d548d966eeb2ab72c06)

## 论文试图解决的问题（是否是新的问题）

提出了新的深度神经网络架构，让深的神经网络更容易训练，并应用在图片分类、目标检测等多种任务上

深的网络存在的问题：
- 梯度消失/爆炸，在此之前可以通过一些正则化方式（例如batch norm）来缓解
- 越深性能越差。论文认为这不是过拟合，因为训练误差也很高（而不是训练误差低、测试误差高）

## 论文的总体贡献

SGD的精髓：需要训练得动（一直有梯度）。收敛没有用，因为可能收敛到性能不好的地方。

ResNet的贡献：避免了梯度消失，让SGD能训练得动

## 论文提供的关键元素、关键设计

考虑加深神经网络，存在这样一种结果，使得性能不会下降：新增的网络学到identity mapping，即输出=输入。但是论文认为SGD找不到这个结果。于是论文显式的构造identity mapping。

### 残差连接

如果 $x$ 和 $f(x)$ 的size不同：
- zero-padding
- 。。。

## 实验（设置、数据集）



## 有什么疑问，如何继续深入，如何吸取到你的工作中

为什么1000层的ResNet也能训练得动，不会过拟合？延伸到Transformer

> 李沐：open question
> - ResNet中的残差连接实际上降低了内在的（intrinsic）复杂度，模型能更方便地找到不那么复杂的方式来拟合数据
>     - 如果不引导（加残差连接）网络去找到identity mapping，网络没办法自发的找到这条路，于是复杂度变得很高

## 相关研究（如何归类，值得关注的研究员）

和机器学习中的residual（如gradient boosting，GBDT）不太一样
