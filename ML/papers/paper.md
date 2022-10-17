### Understanding deep learning requires rethinking generalization. In ICLR, 2017.

https://dl.acm.org/doi/pdf/10.1145/3446776

Q：如何提升泛化性能

- The randomization test: Deep neural networks easily fit random labels.
- 正则化的作用：不是泛化性能提升的关键（但有一定帮助）
  - SGD acts as an implicit regularizer

### [ICML20]Do We Need Zero Training Loss After Achieving Zero Training Error?

$$
\begin{align}
\theta_{n}&=\theta_{n-1}-\varepsilon \widehat R'(\theta_{n-1})\\
\theta_{n+1}&=\theta_{n}+\varepsilon \widehat R'(\theta_{n})\\
&=\theta_{n-1}-\varepsilon \widehat R'(\theta_{n-1})+\varepsilon \widehat R'(\theta_{n-1}-\varepsilon \widehat R'(\theta_{n-1}))\\
&=\theta_{n-1}-\varepsilon \widehat R'(\theta_{n-1})+\varepsilon \left(\widehat R'(\theta_{n-1})-\varepsilon \widehat R'(\theta_{n-1})\cdot \widehat R''(\theta_{n-1})\right)\\
&=\theta_{n-1}-\dfrac{\varepsilon^2}2\dfrac{\mathrm d||\widehat R'(\theta_{n-1})||^2}{\mathrm d \theta}\qquad (y\dfrac{\mathrm d y}{\mathrm d x}=\dfrac 12\cdot\dfrac{\mathrm d y^2}{\mathrm d x})
\end{align}
$$

