---
aliases: ["Generative Adversarial Networks", "Generative Adversarial Networks, 2014", "GAN"]
---
# Generative Adversarial Networks

- **Journal**: arxiv:1406.2661 [cs, stat]
- **Author**: Ian J. Goodfellow, Jean Pouget-Abadie, Mehdi Mirza, Bing Xu, David Warde-Farley, Sherjil Ozair, Aaron Courville, Yoshua Bengio
- **Year**: 2014
- **URL**: http://arxiv.org/abs/1406.2661
- [**Zotero**](zotero://select/items/@2014GenerativeAdversarialNetworksGoodfellow)
- [**ReadPaper**](https://readpaper.com/pdf-annotate/note?noteId=744420300007636992)
- [bilibili](https://www.bilibili.com/video/BV1rb4y187vD/)

## 论文试图解决的问题（是否是新的问题）

判别式模型容易，生成式模型困难（因为最大似然估计是困难的）

## 论文的总体贡献

## 论文提供的关键元素、关键设计

### 总体流程

- 生成器 $G(z;\theta_g)$：将噪声数据（采样自 $p_z$ ）映射到目标分布 $p_{data}$
    - 目标：让判别器无法分辨是否来自目标分布
    - 优化目标： $\underset{G}{\min}\log(1−D(G(z)))$
- 判别器 $D(x;\theta_d)$：判断某个数据是否来自目标分布
    - 优化目标： $\underset{D}{\max}\log D(x)$
- 总体目标： $\underset{G}{\min}\underset{D}{\max}V(D, G)=\mathbb{E}_{x \sim p_{\text {data }}(x)}[\log D(x)]+\mathbb{E}_{z \sim p_{z}(z)}[\log (1-D(G(z)))]$

## 实验（设置、数据集）

## 有什么疑问，如何继续深入，如何吸取到你的工作中

## 相关研究（如何归类，值得关注的研究员）
