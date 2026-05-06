---
title: expanding by the binomial theorem
publish: true
created: 2026-05-05
updated: 2026-05-06
tags:
  - combinatorics
  - probability
---

## The binomial theorem

This


$$(x+y)^n = \sum_{k=0}^{n} \binom{n}{k} x^{k} y^{(n-k)}\tag{1}$$


is the *binomial theorem*, and it's a way to fill $n$ slots with *combinations* of $x$'s and $y$'s that happens to also be a way to compute the coefficient of a *binomial expansion*. How so?

![[Pasted image 20260506232401.png|529]]

### Expanding a binomial

Expanding a binomial $(x+y)^{n}$ is the result of combining—by multiplying, because each $(x+y)$ factor is an independent choice and the [[sum-and-product-rule-permutations-and-combinations|product rule]] is applied—$n$ times the binomial's elements $x$ and $y$, here with $n=3$ as the diagram above shows

$$(x+y)^{3} = (x+y)(x+y)(x+y)\tag{2}$$

$$= xxx + xxy + xyx + xyy + yxx + yxy + yyx + yyy$$

What the binomial theorem is really saying, thus, is that a binomial expansion $\sum_{k=0}^{n}\binom{n}{k} x^{k} y^{(n-k)}$ is the sum of all the combinations of the binomial elements $x$ and $y$ required to fill $n$ sized slots—since, and maybe obviously, $k + n - k = n$—or, in other words, that *every term in the expansion is one path through those slots*.

### Compact expansion

What this means, in other words, is that *each step of the summation counts*—because summing *is* counting—*the number of times a specific combination of the binomial elements* ($k$-times the first and $(n-k)$-times the second) *appears in the final expansion*. 

In example $(2)$ above, the second $xxy$, third $xyx$ and fifth $yxx$ addends are no more than the elements resulting from the summation step with $k=2$

$$\binom{3}{2}x^{2}y^{3-2}$$

that is 

$$\frac{3!}{2!\cdot(3-2)!} x^{2}y^{1} = \frac{6}{2}x^{2}y^{1} = 3x^{2}y$$

and that is like saying that an addend consisting of $2$ times $x$ and $1$ time $y$ appears $3$ times—and $3$ as the result of the binomial coefficient $\binom{n}{k}$, that is telling me in how many ways $k$ and $n-k$ [[combinations-vs-permutations-in-path-counting|indistinguishable elements]] can be arranged—in the expanded binomial that, in turn, means that $3$ is the coefficient of the expanded binomial element with $x^{2}$—and consequently and inevitably $y^{1}$.

## A worked example

Find the coefficient of $a^{3}$ in


$$(2a - 3)^{7}\tag{3}$$


Recall $(1)$: what are my $x$ and $y$ and $n$ here? Given the obvious $n=7$, $x$ and $y$ map into the theorem like

$$x=2a$$
$$y=-3$$

These are just symbols, that happen to take the form of numbers, but they really can be just literally *anything*, and need to be treated as such!

Here I'm doing algebra and I want to make mathematical operations on them, because they are many—example $(3)$ expanded has $2^{7}=128$ addends—and I want to have a compact notation, and numbers happen to be a really compact notation—writing 1M is indeed more compact than collecting 1M pebbles—but their function is just to serve as bases for the $k$ and $(n-k)$ exponents that in turn represent really just a number of repetition (remember exponentiation is repeated multiplication): $k$ and $(n-k)$ repetitions!

So, if i want to know the coefficient of $x^{3}$—equivalently $a^{3}$ in $(3)$—the exponent of $y$ must be $(n-k)=(7-3)=4$. When mapping the binomial elements to $x$ and $y$ there's therefore absolutely really nothing to think about, just go autopilot, even though the second binomial element $-3$ has no attached variable or exponent in $(3)$: its combination's exponent $4$ is just the number of times i have to take $-3$ in that precise expansion addend (step of combinations summation) that corresponds to $x^{3}y^{4}$!

Thus

$$\binom{7}{3} \cdot x^{3} \cdot y^{4}$$

$$=\binom{7}{3} \cdot (2a)^{3} \cdot (-3)^{4}$$

$$=\frac{7!}{3! (7-3)!} \cdot 8 \cdot 81 \cdot a^{3}$$

$$=35 \cdot 8 \cdot 81 \cdot a^{3}= 22680a^{3} $$

and $22680a^{3}$ is the expansion element with exponent $3$. And that also shows how the actual number of possible ways to arrange a number $k$ of $x$ elements and a number $(n-k)$ of $y$ elements is entirely given by the binomial coefficient $\binom{n}{k}$; the multiplication by the coefficients of each binomial element in turn represents just an *algebraic* tool, not a *combinatorial one*, to find the expansion's coefficients.
