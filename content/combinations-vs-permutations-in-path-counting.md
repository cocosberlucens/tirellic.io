---
title: combinations vs permutations in path counting
publish: true
created: 2026-04-11
updated: 2026-04-11
tags:
  - combinatorics
  - probability
---
## The "*order doesn't matter*" in combinations

In the combinations formula (equation $(3)$ in [[sum-and-product-rule-permutations-and-combinations]])


$$C(n, k) = \binom{n}{k} = \frac{n!}{k!(n-k)!}$$



the first $k!$ in the denominator is the "*order doesn't matter*" element, it acts as a *deduplicator*, removing duplicate arrangements that differ only in element order.

## A subtle case of confusion

However, when I considered the classic combinatorics problem of finding the number of paths within a grid, such as 

![[lattice-path-counting.png]]

something felt off.

### Lattice path counting solution

The problem solution is simplified by leveraging the binomial coefficients symmetry


$$\binom{n}{k} = \frac{n!}{k!(n-k)!} = \frac{n!}{(n-k)!k!} = \binom{n}{n-k}$$


and modeling as a single combination, because by *choosing* the 4 East steps, the 3 North steps become a residual, implied by the first choice—no degrees of freedom remain. Therefore, to find the number of possible paths I compute either the North or the East steps combinations, the others follow accordingly and inevitably.

### Combinations vs. Permutations

But that for *combinations* is the "*order doesn't matter*" combinatorics formula, nevertheless here order does matter: $\mathit{ENEENEN}$ is different from $\mathit{NNNEEEE}$—at first sight, this could therefore look more like a *permutation*


$$P(n, k) = \frac{n!}{(n-k)!}$$


where ordering precisely matters, than a *combination*.

### What the first $k!$ in $C(n, k)$ really is?

But the ordering that matters in path counting problems is the ordering of the *whole* arrangement, whilst the first $k!$ in $C(n, k)$ actually gets rid of ordering *within* the chosen elements' set. In other words, I'm not choosing which North step goes into step $i$, I'm choosing whether step $i$ gets a North or an East step: I'm choosing the *positions* not the elements that need to be instead considered *indistinguishable*. 

What the first $k!$ in $C(n, k)$—the *deduplicator*—is really saying, thus, is that the North (or East for what matters) steps $N_{1}$, $N_{2}$, $N_{3}$ are indeed the same thing, but it sort of *whispers* it subtly as "*order doesn't matter*": the first $k!$ in the denominator of $C(n, k)$ is a *deduplicator/anonymizator*.

This is another application of a *counting correction* mechanism, like in [[inclusion-exclusion-principle]].

## On identity

There, lying, is a deep philosophical question about identity: what is identity? 

> identity is what makes exchanging two elements noticeable

