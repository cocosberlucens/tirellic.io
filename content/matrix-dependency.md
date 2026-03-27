---
title: matrix rank and linear dependence
publish: true
created: 2026-02-10
updated: 2026-03-07
tags:
  - linear-algebra
  - matrices
---

# definition

the *rank* of a matrix is the maximum number of independent vectors within any axes.

# example

$$\begin{bmatrix} 
2 & 4 & 7 \\ 
1 & 2 & 5 \\ 
3 & 6 & 1
\end{bmatrix}$$
here $c_{2}=2 c_{1}$, rank is $r=2$.

## express a column as a linear weighted combination (LWC) of another

### $c_{1}$ as a LWC of $c_{2}$ and $c_{3}$

$$\begin{matrix} 
4b+7c=2 & \rightarrow & \mathbf{b=\frac{1}{2}} \\ 
2b+5c=1 & \rightarrow & \mathbf{c= 0} \\ 
6b+c=3 & \rightarrow & 3=3
\end{matrix}$$
then $c_{1}$

$$\begin{matrix} 
4b & & 7c & & 2 \\ 
2b & + & 5c & = & 1 \\ 
6b & & 1c & & 3
\end{matrix}$$

### $c_{2}$ as a LWC of $c_{1}$ and $c_{3}$
$$\begin{matrix} 
2a+7c=4 & \rightarrow & \mathbf{c= 0} \\ 
1a+5c=2 & \rightarrow &  \mathbf{a=2}\\ 
3a+c=6 & \rightarrow & 6=6
\end{matrix}$$
then $c_{2}$
$$\begin{matrix} 
2a & & 7c & & 4\\ 
1a & + & 5c & = & 2\\ 
3a & & 1c & & 6
\end{matrix}$$

### $c_{3}$ as a LWC of $c_{1}$ and $c_{2}$
$$\begin{matrix} 
2a+4b=7 & \rightarrow & b=\frac{7}{4}-\frac{1}{2}a \\ 
a+2b=5 & \rightarrow &  \frac{7}{2}=5\\ 
3a+6b=1 & \rightarrow & \frac{21}{2}=1
\end{matrix}$$
$c_{1}$ and $c_{2}$ are on the same line, they are *collinear*, thus they can never be combined to obtain $c_{3}$
$$\begin{matrix} 
2a & & 4b & & 7 \\ 
1a & + & 2b & \neq & 5\\ 
3a & & 6b & & 1
\end{matrix}
\forall c_{1}, c_{2} \in R$$
## a row as a linear weighted combination (LWC) of another

### $r_{1}$ as a LWC of $r_{2}$ and $r_{3}$
$$\begin{matrix} 
b+3c=2 & \rightarrow & \mathbf{b=\frac{19}{14}} \\ 
2b+6c=4 & \rightarrow & 4=4 \\ 
5b+c=7 & \rightarrow & \mathbf{c=\frac{3}{14}}
\end{matrix}$$
then $r_{1}$
$$\begin{matrix} 
b & 2b & 5b\\
 & + & \\
3c & 6c & c \\
 & = & \\
 2 & 1 & 3 
\end{matrix}
$$

### $r_{2}$ as a LWC of $r_{1}$ and $r_{3}$
$$\begin{matrix} 
2a+3c=1 & \rightarrow & \mathbf{a=\frac{14}{19}} \\ 
4a+6c=2 & \rightarrow & 2=2 \\ 
7a+c=5 & \rightarrow & \mathbf{c=-\frac{3}{19}} 
\end{matrix}$$
then $r_{2}$
$$\begin{matrix} 
2a & 4a & 7a\\ 
 & + & \\ 
3c & 6c & c \\
& = & \\ 
1 & 2 & 5
\end{matrix}$$
### $r_{3}$ as a LWC of $r_{1}$ and $r_{2}$
$$\begin{matrix} 
2a+b=3 & \rightarrow & \mathbf{b=-\frac{19}{3}} \\ 
4a+2b=6 & \rightarrow & 6=6 \\ 
7a+5b=1 & \rightarrow & \mathbf{a=-\frac{14}{3}} 
\end{matrix}$$
then $r_{3}$
$$\begin{matrix} 
2a & 4a & 7a\\ 
 & + & \\ 
1b & 2b & 5b \\
& = & \\ 
3 & 6 & 1
\end{matrix}$$
## what is happening?

dependency—as rank of which it is the complement—is a property of the whole set of vectors that constitute a matrix. 

the column set contains two collinear columns, and their relationship is apparent—even more because in the example it's an integer relationship, whereas in the rows set the dependency is more subtle, because it is distributed between the three row vectors. 

in the column set one column can not be expressed as a combination of the other two, which being collinear can move only within the line they both span and can be reciprocally be instead expressed as a multiple of the other;

in the row set there's no single row that can be expressed as a multiple of another, but all three can in turn be expressed by a combination of the other *two*.

the dependency is thus an inherent property of the matrix that can express itself as various relationships between the row and column vectors. 
