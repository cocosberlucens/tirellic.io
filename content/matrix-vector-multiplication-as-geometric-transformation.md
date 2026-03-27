---
title: matrix-vector multiplication as basis transformation
publish: true
created: 2026-01-15
updated: 2026-03-07
tags:
  - linear-algebra
  - matrices
  - transformations
---

The result of multiplying a simple vector by a matrix
$$A \cdot \mathbf{v} = \mathbf{u}$$
is a geometric transformation. Here's a 90° anti clockwise rotation
$$\begin{bmatrix} 0 & -1 \\ 1 & 0 \end{bmatrix} \cdot \begin{bmatrix} 2 \\ 1 \end{bmatrix}=\begin{bmatrix} -1 \\ 2 \end{bmatrix}$$
That is to say
$$ 2 \begin{bmatrix} 0 \\ 1 \end{bmatrix} + 1 \begin{bmatrix}-1 \\ 0\end{bmatrix} = \begin{bmatrix}-1 \\ 2 \end {bmatrix}$$
the resulting vector $\mathbf{u}$ is a linear combination of columns of $A$ times rows of $\mathbf{v}$ ([[four-ways-to-look-at-matrix-multiplication]]).

The role of each matrix element in the transformation is better understood by interpreting matrix vector multiplication as *basis transformation*. For example, in a 2 dimensional plane with $x$ and $y$ axis, the basis is defined as
$$\begin{bmatrix} a_{x} & c_{x} \\ b_{y} & d_{y} \end{bmatrix}$$
where the coefficients identify the amount of movement—the *standard unit*—that happens on their respective axis, given $1$ unit of movement along the corresponding axis in the multiplied vector, and it can be read like 

> *for every unit along the $x$ axis move $a_{x}$ along the $x$ axis and $b_{y}$ along $y$, and for every unit along the $y$ axis move $c_{x}$ along the $x$ axis and $d_{y}$ along $y$*

In other words, each matrix column corresponds to an input dimension—*what* input dimension gets transformed—each matrix row to an output dimension—*how* the input dimension is transformed
$$\begin{bmatrix} & \mathbf{v_{1,1}} \downarrow & \mathbf{v_{2,1}} \downarrow \\ \mathbf{u_{1,1}} \leftarrow & a_{x} & c_{x} \\ \mathbf{u_{1,2}} \leftarrow & b_{y} & d_{y} \end{bmatrix}$$
A look at the matrix representation of the familiar Cartesian plane makes it clearer 
$$\begin{bmatrix} 1 & 0 \\ 0 & 1 \end{bmatrix}$$
The first column is the $x$ axis, the second the $y$.

The initial transformation can thus be interpreted as moving $1$ unit along the $y$ axis (and $0$ along the $x$ axis) for every unit of movement along the $x$ axis and $-1$ along the $x$ axis (and $0$ along the $y$ axis) for every unit on the $y$ axis. 
