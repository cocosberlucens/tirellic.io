---
title: orthogonal decomposition and projection
publish: true
created: 2026-01-13
updated: 2026-03-07
tags:
  - linear-algebra
  - projection
---

## Orthogonal decomposition



### The parallel component

In orthogonal decomposition of a target vector $t$ the parallel component $t_{\parallel r}$ is represented by a fraction $\beta$ of the reference vector $r$. $\beta r$ is the vector along $r$ where the difference with $t$, the vector $t - \beta r$, forms a right angle, or in other words the dot product between the two is zero.
$$r \cdot (t - \beta r) = 0$$
$$r \cdot t - r \cdot \beta r = 0$$
$$\beta = \frac{r \cdot t}{r \cdot r}$$
$$\beta r = \frac{r \cdot t}{r \cdot r} r$$
where $\beta r$ is the parallel component $t_{\parallel r}$.

### The perpendicular component

The perpendicular component is found by considering the orthogonal decomposition identity
$$t = t_{\perp r} + t_{\parallel r}$$$$t_{\perp r} = t - t_{\parallel r}$$
$$x = \underbrace{x_{\text{row}}}{\text{projection onto row space}} + \underbrace{x{\text{null}}}_{\text{perpendicular (lives in null space)}}$$
