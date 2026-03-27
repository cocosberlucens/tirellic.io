---
title: dot product and law of cosines
publish: true
created: 2026-01-10
updated: 2026-03-07
tags:
  - linear-algebra
  - vectors
---

## Dot product and Law of cosines

Since the *euclidean norm* is defined as
$$|\mathbf{v}| = \sqrt{\sum_{i=1}^{n} \mathbf{v}_i^2}$$
and the dot product as
$$\delta=\sum_{i=1}^{n} \mathbf{a}_i \mathbf{b}_i$$
the dot product of a vector with itself is the squared norm of that vector
$$\begin{equation}\mathbf{v} \cdot \mathbf{v} = \sum_{i=1}^{n} \mathbf{v}_i \mathbf{v}_i = \sum_{i=1}^{n} \mathbf{v}_i^2 = |\mathbf{v}|^2\tag{1}\end{equation}$$
Then, I consider the not immediately related fact that two vectors $\mathbf{a}$ and $\mathbf{b}$, and their subtraction $\mathbf{c}$ actually form a triangle having sides $\mathbf{a},\mathbf{b},\mathbf{c}$ $$\mathbf{c} = \mathbf{b} - \mathbf{a}$$
with $\mathbf{c}$ thus having length 
$$|\mathbf{c}|^2=|\mathbf{b}-\mathbf{a}|^2 $$expanding, that means $$= (\mathbf{b}-\mathbf{a}) \cdot (\mathbf{b}-\mathbf{a}) = |\mathbf{b}|^2 + |\mathbf{a}|^2 - 2(\mathbf{a} \cdot \mathbf{b})$$
Given the fact that $c=|\mathbf{c}|$—and consequently $c^2=|\mathbf{c}|^2$, that is to say the vector norm *is* the length of the triangle side $c$ in vector interpretation, the *Law of Cosines* $$c^2=a^2 + b^2 - 2 a b \cos{(\theta_{a,b})}$$ can thus also have a vector interpretation $$|\mathbf{c}|^2 = |\mathbf{a}|^2 + |\mathbf{b}|^2 - 2|\mathbf{a}||\mathbf{b}| \cos({\theta_{\mathbf{a},\mathbf{b}}})$$I have therefore to conclude that  $$|\mathbf{b}|^2 + |\mathbf{a}|^2 - 2(\mathbf{a} \cdot \mathbf{b}) = |\mathbf{a}|^2 + |\mathbf{b}|^2 - 2|\mathbf{a}||\mathbf{b}| \cos({\theta_{\mathbf{a},\mathbf{b}}})$$that is to say $$\begin{equation}\mathbf{a} \cdot \mathbf{b} = |\mathbf{a}| |\mathbf{b}|\cos({\theta_{\mathbf{a},\mathbf{b}}})\tag{2}\end{equation}$$
the dot product is the product of the vectors norms scaled by the cosine of the angle between the two vectors.
