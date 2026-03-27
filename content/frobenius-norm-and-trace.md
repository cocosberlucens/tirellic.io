---
title: Frobenius norm and trace
publish: true
created: 2026-01-12
updated: 2026-03-07
tags:
  - linear-algebra
  - matrices
  - norms
---

## Frobenius norm

The *euclidean norm* ([[dot-product-and-law-of-cosines]])

$$
|\mathbf{v}| = \sqrt{\sum_{i=1}^{n} \mathbf{v}_i^2}
$$

is the most common measure of length of a vector, the *Frobenius norm* defined as

$$
\|A\|_F = \sqrt{\sum_{i,j} \mathbf{a}_{ij}^2}
$$

is the matrix generalization of the *euclidean norm* for vectors. 

## Trace

Beyond the definition formula, another way of calculating it is summing the diagonal—computing the *trace*—of the dot product between the matrix and its transpose and taking the square root

$$
\|A\|_F = \sqrt{\text{trace}(A^T A)}
$$

This stems from the fact that the diagonal of $A^T A$ contains the squared column norms—or the squared row norms in reverse order $A A^T$.

## Matrix distance

Replacing $A$ with $A-B$ defines the distance between matrices

$$
d(A, B) = \|A - B\|_F
$$


