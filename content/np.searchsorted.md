---
title: eCDF estimation with np.searchsorted
publish: true
created: 2026-02-28
updated: 2026-03-07
tags:
  - numpy
  - probability
  - statistics
---

## `np.searchsorted`for estimating $P(X)$ from an *eCDF*

`np.searchsorted(a, v, side)` returns the indices of `a` where the elements of `v` should be inserted to keep `a` sorted.

when looking for the probabilities—or the quantiles—from a $\textit{CDF}$ probability function $F(u) = P(X \leq u)$, `np.searchsorted` enables an useful pattern by operating either on the sorted events list $X$—to find probabilities—or on the list of probabilities (`np.searchsorted` parameter `a`), obtained by computing the actual *eCDF* values—to find quantiles.

the `side` parameter takes values `left` or `right` and understanding it is very important to obtain the correct results. `side` controls whether the boundary value(s)—`side` can be an array—contained in `v` are included:

- `side="right"` is equivalent to $\ell \leq v$ 
- `side="left"` to $\ell \lt v$ 

whilst this is an useful general mental model, things get subtle when i have to use it irl to estimate "complex" probabilities. the $\textit{CDF}$ probability function is, i know from above, $F(u) = P(X \leq u)$ and when combined to compute an interval probability, the `side` parameter unlocks handling sophisticated cases. for example, given $\ell$ and $u$ where $\ell<u$ calculating the probability of $\ell \lt X \leq u$, that is $(\ell,u]$, the correct solution is to 

```python
np.searchsorted(a=sorted_values, v=l, side="right") - np.searchsorted(a=sorted_values, v=u, side="right")
```

but why `side="right"` on `v=l`? since `side="right"` is equivalent to $\ell \leq v$ it appears counterintuitive because i'm interested in $\ell \lt X \leq u$. calculating the probability of an interval entails $P(B) - P(A)$, and here since i'm interested in *excluding* $\ell$ i have to *include* it in the subtraction operation to have it *excluded* from the result! hence the need for `side="right"` on both sides.

what is important to remember here is that i don't have to apply the `side="right"`$\rightarrow$`include` and `side="left"`$\rightarrow$`exclude` pattern mechanically, but always think about the composite operation i'm interested in doing with the $\textit{CDF}$ probabilities.
