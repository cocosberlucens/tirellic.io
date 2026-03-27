---
title: matrix multiplication perspectives
publish: true
created: 2026-01-10
updated: 2026-03-07
tags:
  - linear-algebra
  - matrices
---

## Challenge 2.3 Appendix

Take these two matrices

$\mathbf{A}=\begin{bmatrix} 1 & 2 & 3 \\\ 4 & 5 & 6 \end{bmatrix}$

$\mathbf{B}=\begin{bmatrix} 1 & 2 \\\ 3 & 4 \\\ 5 & 6 \end{bmatrix}$

$\mathbf{A} \cdot \mathbf{B} = \mathbf{C} = \begin{bmatrix} 22 & 28 \\\ 49 & 64 \end{bmatrix}$

from Challenge 2.3. 
### Four ways to look at matrix multiplication
#### 1) A row times a column $\rightarrow$ Number (it's the dot product)

$\mathbf{A}_{1,}=\begin{bmatrix} 1 & 2 & 3 \end{bmatrix}$

$\mathbf{B}_{,1}=\begin{bmatrix} 1 \\ 3 \\ 5 \end{bmatrix}$

$\mathbf{A}_{1,} \cdot \mathbf{B}_{,1}=1 \cdot 1 + 2 \cdot 3 + 3 \cdot 5 = 22$
#### 2) Matrix times a column $\rightarrow$ Whole column

$\mathbf{A} \cdot \mathbf{B}_{,1}=\begin{bmatrix} 1 & 2 & 3 \\ 4 & 5 & 6 \end{bmatrix} \cdot \begin{bmatrix} 1 \\ 3 \\ 5 \end{bmatrix}=1 \cdot \begin{bmatrix} 1 \\ 4 \end{bmatrix} + 3 \cdot \begin{bmatrix} 2 \\ 5 \end{bmatrix} + 5 \cdot \begin{bmatrix} 3 \\ 6 \end{bmatrix} =\begin{bmatrix} 22 \\ 49 \end{bmatrix}$

Columns of $\mathbf{C}$ are linear combinations of columns of $\mathbf{A}$
#### 3) Row times a matrix $\rightarrow$ Whole row

$\mathbf{A}_{1,} \cdot \mathbf{B}=\begin{bmatrix} 1 & 2 & 3 \end{bmatrix} \cdot \begin{bmatrix} 1 & 2 \\ 3 & 4\\ 5 & 6 \end{bmatrix}=1 \cdot \begin{bmatrix} 1 & 2 \end{bmatrix} + 2 \cdot \begin{bmatrix} 3 & 4 \end{bmatrix} + 3 \cdot \begin{bmatrix} 5 & 6 \end{bmatrix} =\begin{bmatrix} 22 & 28 \end{bmatrix}$

Rows of $\mathbf{C}$ are linear combinations of rows of $\mathbf{B}$
#### 4) Column times a row $\rightarrow$ Matrix

$\mathbf{A}_{,j} \cdot \mathbf{B}_{i,}=\begin{bmatrix} 1 \\ 4 \end{bmatrix} \cdot \begin{bmatrix} 1 & 2 \end{bmatrix} + \begin{bmatrix} 2 \\ 5 \end{bmatrix} \cdot \begin{bmatrix} 3 & 4 \end{bmatrix} + \begin{bmatrix} 3 \\ 6 \end{bmatrix} \cdot \begin{bmatrix} 5 & 6 \end{bmatrix}=$ 

$= \begin{bmatrix} 1 & 2 \\ 4 & 8 \end{bmatrix} + \begin{bmatrix} 6 & 8 \\ 15 & 20 \end{bmatrix} + \begin{bmatrix} 15 & 18 \\ 30 & 36 \end{bmatrix} =\begin{bmatrix} 22 & 28 \\ 49 & 64 \end{bmatrix}$
