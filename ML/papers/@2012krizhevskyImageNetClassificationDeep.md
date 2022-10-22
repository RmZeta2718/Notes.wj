---
aliases: ["ImageNet Classification with Deep Convolutional Neural Networks", "ImageNet Classification with Deep Convolutional Neural Networks, 2012"， "AlexNet"]
---
# ImageNet Classification with Deep Convolutional Neural Networks

- **Journal**: Advances in Neural Information Processing Systems
- **Author**: Alex Krizhevsky, Ilya Sutskever, Geoffrey E Hinton
- **Year**: 2012
- **URL**: https://papers.nips.cc/paper/2012/hash/c399862d3b9d6b76c8436e924a68c45b-Abstract.html
- [**Zotero**](zotero://select/items/@2012krizhevskyImageNetClassificationDeep)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?pdfId=551651939155394560&from_extension=true&noteId=742971682610896896)
- [bilibili](https://www.bilibili.com/video/BV1ih411J7Kz/)

## 论文试图解决的问题（是否是新的问题）

图片分类

## 论文的总体贡献

将深度学习领域的方向指向了supervised learning
- 在AlexNet之前，深度学习比不过传统方法（如SVN），所以被迫做无监督学习
- 最近（2022），Bert的兴起引发另一波无监督学习浪潮

AlexNet对图片的语义表示非常好：最后一层隐层表示接近的图片，语义也很接近（从人能看懂的图片变成机器能读懂的特征向量 $224\times224\times3\rightarrow4096\times1$ 

端到端的图片分类：输入raw pixel，而不需要手动抽取特征，开创了新的方向

模型并行：将模型切分为2块，放到2张GPU上训练。虽然很长一段时间内这个不是主流做法，但是最近随着Bert等大模型出现，模型并行又火了起来

### 讨论

原文指出去掉一层卷积层会导致2%的性能下降。这一点并不完全正确，因为还有可能是其他参数的影响。但是结论总体上正确。宽而浅或者深而窄的网络都不好。

## 论文提供的关键元素、关键设计

使用大模型，通过正则手段防止大模型过拟合。现在的观点：正则化可能不太重要，更重要的是模型设计。

## 实验（设置、数据集）



## 有什么疑问，如何继续深入，如何吸取到你的工作中



## 相关研究（如何归类，值得关注的研究员）


