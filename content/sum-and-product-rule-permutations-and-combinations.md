---
title: sum and product rule, permutations and combinations
publish: true
created: 2026-03-28
updated: 2026-03-28
tags:
  - probability
  - combinatorics
---
## Sum and Product rule

In combinatorics the Sum and Product rule can be understood in terms of the number of nested iterations needed to count the possible outcomes. Choosing elements

- between a set *or* another—*zero iterations*—is the Sum rule
- from a set *and* from another, or repeatedly on the same, entails *multiple iterations* and is the Product rule

### Sum rule

The *Sum rule* entails choosing *one* outcome between either of two (or more) sets—call them $A$ and $B$—among all the possible ones, that, *with no overlap*, is given by the *sum* of each set's number of elements $|A| + |B|$, and it's equivalent to the *union* operation $A \cup B$. When sets overlap the simple sum overcounts, see [[inclusion-exclusion-principle]] for the correction.

### Product rule

The iterative process of finding *more than one* outcome is represented by the the *Product rule*, the possible outcomes of drawing one element in $N$ successive iterations from a set $A$ *with repetition* is given by $|A_{1}| \times |A_{2}| \times \dots |A_{N}|$ or $|A|^N$ where each $N^{th}$ iteration represents a different set, so that the Product rule, generalizing, is equivalent to the Cartesian product of all the involved sets $|A| \times |B| \times \dots |Z|$.

## Special cases of the Product rule: Permutations and Combinations

### Permutation

The Product rule allows to compute all the possible arrangements with repetition, and it's therefore the largest number of possible elements' arrangements attainable. *Permutation* is a special case of the Product rule on the same set, where at each iteration the chosen element is discarded, until the set is exhausted, that is to say the elements are drawn without repetition*. This operation has its own name, *factorization*

$$
N! = N \cdot (N-1) \cdot (N-2) \cdot \dots 1 = \prod_{j=1}^{N} j
$$

and it symbolizes the operation of *choosing the possible arrangements of all set's elements*.
Notice that in the compact $\prod$ product notation the sequence here is forward (from $1$ to $N$), whereas factorization $N!$ is depicted backwards (from $N$ to $1$).

### $k$-Permutation

If the set isn't completely exhausted, I'm *choosing the possible arrangements of some*—call them $k$—*set's elements* and I'm doing a *partial permutation*. Like this

$$
\prod_{j=N-k+1}^{N} j = N \cdot (N-1) \cdot (N-2) \dots (N-k+1)
$$

For example, choosing $3$ numbers between $1$ and $7$: first iteration has $7$ numbers available, second has $6$, third has $5$, that is to say $7 \cdot 6 \cdot 5$. But *why*?

If I were to exhaust all the elements, I'd do

$$
7! = 7 \cdot 6 \cdot 5 \cdot 4 \cdot 3 \cdot 2 \cdot 1
$$


but since I don't want anything but $3$ elements, I need to *subtract* those iterations from the formula, like so

$$
7 \cdot 6 \cdot 5 = \frac{7 \cdot 6 \cdot 5}{1} \cdot \frac{4 \cdot 3 \cdot 2 \cdot 1}{4 \cdot 3 \cdot 2 \cdot 1} 
$$

or more compact

$$
= \frac{7!}{(7-3)!}
$$

generalizing 

$$
P(N, k) = N \cdot (N-1) \cdot (N-2) \dots (N-k+1) = \frac{N!}{(N-k)!}
$$

that spoken in natural language is defined as *the number of $k$-Permutations of $N$ objects is $P(N,k)$*, that reads as *$N$ pick $k$*.

### $k$-Combination

$k$-Permutations forget about *some elements*, what if I want to *forget also about the ordering*? I may, for example, be interested in knowing how many sums of some set elements arrangements I can compute. The ordering, here, clearly doesn't matter. 

In how many ways can I arrange the 3 numbers of the $k$-Permutations example? This is a simple permutation, hence $3!$, and it represents something I don't want because these $3!$ arrangements all give me the same sum. 

Just like I have done to subtract the $N-k$ elements from the permutation $N!$

$$
\frac{N!}{(N-k)!}
$$

I need to subtract $k!$ repeated arrangements, hence

$$
\frac{P(N,k)}{k!}
$$

that, expanding, gives me

$$
C(N, k) = \binom{N}{k} = \frac{N!}{k!(N-k)!}
$$

that reads as *$N$ choose $k$*.

This, incidentally, means that *if order doesn't matter* there is only $1$ way to *choose all the elements of a set*. This is useless and trivial, but it closes the circle beautifully.

## Progressive layers of forgetting

There is a thread that runs across these operation, starting from the Product rule, through *Permutations*, to $k$-Combinations: the progressive shrinking of the number of possible arrangements. From the largest, obtained by application of the *Product rule*, forget about

- repetitions $\rightarrow$ *permutations*
- some elements $\rightarrow$ *$k$-permutations*
- ordering $\rightarrow$ *$k$-combinations*

Each of these computes a smaller sets of the possible arrangements universe represented by the application of the *Product rule*. This is the same pattern found in the relationship between the *Dot product* and *Pearson correlation* described in the [[cosine-similarity-and-pearson-correlation]|dedicated note]].

## Related

- [[conditional-probability-and-bayes-rule]] — permutations and combinations are the counting tools that underpin event probability
