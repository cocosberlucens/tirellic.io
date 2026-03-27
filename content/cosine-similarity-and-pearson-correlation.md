---
title: cosine similarity and Pearson correlation
publish: true
created: 2026-01-10
updated: 2026-03-07
tags:
  - linear-algebra
  - similarity
  - statistics
---

## Cosine similarity and Pearson correlation coefficient

### The dot product

The problem of the *dot product* $\mathbf{a} \cdot \mathbf{b}$ as a measure of alignment is that it's always influenced by the magnitude of the compared vectors, therefore comparing two dot products trying to infer alignment similarity is meaningless.
### Cosine similarity

Equation $(2)$ in [[dot-product-and-law-of-cosines]] when solved for $\cos(\theta_{\mathbf{a},\mathbf{b}})$ gives the *cosine similarity* formula $$\cos({\theta_{\mathbf{a},\mathbf{b}}}) = \frac{\mathbf{a} \cdot \mathbf{b}}{  |\mathbf{a}| |\mathbf{b}|}$$
that scales the dot product by the norms of the compared vectors, thus *ignoring* their magnitudes and therefore making *cosine similarity* a comparable measure of alignment similarity. 

It's worth noting, though, that *cosine similarity*, whether with normalized vectors $\frac{\mathbf{v}}{|\mathbf{v}|}$—which have norms equal to 1, and would thus simplify the *cosine similarity* formula to $\cos({\theta_{\mathbf{a},\mathbf{b}}}) = \mathbf{a} \cdot \mathbf{b}$ since the denominator would precisely equal $1$—or not, is **always** influenced by the baseline of the vectors: vectors with different offsets but equal deviations aren't perfectly cosine-similar.
### Pearson correlation coefficient

Take this one step further and do *mean centering* to also remove the baseline: get *Pearson correlation coefficient* 
$$\rho = \frac{\widetilde{\mathbf{a}} \cdot \widetilde{\mathbf{b}}}{\|\widetilde{\mathbf{a}}\| \|\widetilde{\mathbf{b}}\|}$$
where the $\sim$ represents mean centering. *Pearson correlation* thus is an even more comparable measure of alignment similarity because it ignores both magnitudes and offsets.
### Cosine similarity versus Pearson correlation 

*Cosine similarity* measures alignment of raw vectors from the origin. *Pearson correlation* measures alignment of deviations from the mean. 
$\rho  = 1$ captures perfect linear relationship ($y = ax + b$), while $\cos({\theta_{\mathbf{a},\mathbf{b}}}) = 1$ captures perfect proportionality through the origin ($y = ax$, no intercept).

### Progressive layers of forgiveness

Here's a summary of the progressive layers of normalization

| Measure of similarity | Formula                                                                                                               | = 1 when                                                                                                                                                                                                                                           | Ignores                             |
| --------------------- | --------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| Dot product           | $$\mathbf{a} \cdot \mathbf{b}$$                                                                                       | never reaches an highest possible limit, $\mathbf{a} \cdot \mathbf{b}=1$ has no real meaning in the context of alignment similarity. however, $\mathbf{a} \cdot \mathbf{b} = 0$ is meaningful: it indicates orthogonality regardless of magnitudes | nothing, any difference is captured |
| Cosine similarity     | $$\frac{\mathbf{a} \cdot \mathbf{b}}{\|\mathbf{a}\| \|\mathbf{b}\|}$$                                                 | $\mathbf{a} = k\mathbf{b}$, the two vectors are proportional, regardless of magnitude                                                                                                                                                              | magnitude                           |
| Pearson correlation   | $$\frac{\widetilde{\mathbf{a}} \cdot \widetilde{\mathbf{b}}}{\|\widetilde{\mathbf{a}}\| \|\widetilde{\mathbf{b}}\|}$$ | $\widetilde{\mathbf{a}} = k\widetilde{\mathbf{b}}$, when the two *centered* vectors are proportional                                                                                                                                               | magnitude and baseline              |

### Examples

| Vector a  | Vector b        | Dot   | Cosine  | Pearson |
| --------- | --------------- | ----- | ------- | ------- |
| $[1,2,3]$ | $[2,4,6]$       | $28$  | $1$     | $1$     |
| $[1,2,3]$ | $[101,102,103]$ | $611$ | $0.997$ | $1$     |
 
