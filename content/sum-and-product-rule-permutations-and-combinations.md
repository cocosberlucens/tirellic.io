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

The iterative process of finding *more than one* outcome is represented by the the *Product rule*, the possible outcomes of drawing one element in $n$ successive iterations from a set $A$ *with repetition* is given by $|A_{1}| \times |A_{2}| \times \dots |A_{n}|$ or $|A|^n$ where each $n^{th}$ iteration represents a different set, so that the Product rule, generalizing, is equivalent to the Cartesian product of all the involved sets $|A| \times |B| \times \dots |Z|$.

## Special cases of the Product rule: Permutations and Combinations

### Permutation

The Product rule allows to compute all the possible arrangements with repetition, and it's therefore the largest number of possible elements' arrangements attainable. *Permutation* is a special case of the Product rule on the same set, where at each iteration the chosen element is discarded, until the set is exhausted, that is to say the elements are drawn *without repetition*. This operation has its own name, *factorization*

$$
n! = n \cdot (n-1) \cdot (n-2) \cdot \dots 1 = \prod_{j=1}^{n} j \tag{1}
$$

and it symbolizes the operation of *choosing the possible arrangements of all set's elements*.
Notice that in the compact $\prod$ product notation the sequence here is forward (from $1$ to $n$), whereas factorization $n!$ is depicted backwards (from $n$ to $1$).

### $k$-Permutation

If the set isn't completely exhausted, I'm *choosing the possible arrangements of some*—call them $k$—*set's elements* and I'm doing a *partial permutation*. Like this

$$
\prod_{j=n-k+1}^{n} j = n \cdot (n-1) \cdot (n-2) \dots (n-k+1)
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
P(n, k) = n \cdot (n-1) \cdot (n-2) \dots (n-k+1) = \frac{n!}{(n-k)!}\tag{2}
$$

that spoken in natural language is defined as *the number of $k$-Permutations of $n$ objects is $P(n,k)$*, that reads as *$n$ pick $k$*.

### $k$-Combination

$k$-Permutations forget about *some elements*, what if I want to *forget also about the ordering*? I may, for example, be interested in knowing how many sums of some set elements arrangements I can compute. The ordering, here, clearly doesn't matter. 

In how many ways can I arrange the 3 numbers of the $k$-Permutations example? This is a simple permutation, hence $3!$, and it represents something I don't want because these $3!$ arrangements all give me the same sum. 

Just like I have done to subtract the $n-k$ elements from the permutation $n!$

$$
\frac{n!}{(n-k)!}
$$

I need to subtract $k!$ repeated arrangements, hence

$$
\frac{P(n,k)}{k!}
$$

that, expanding, gives me

$$
C(n, k) = \binom{n}{k} = \frac{n!}{k!(n-k)!}\tag{3}
$$

that reads as *$n$ choose $k$*.

This, incidentally, means that *if order doesn't matter* there is only $1$ way to *choose all the elements of a set*. This is useless and trivial, but it closes the circle beautifully.

## Progressive layers of forgetting

There is a thread that runs across these operation, starting from the Product rule, through *Permutations*, to $k$-Combinations: the progressive shrinking of the number of possible arrangements. From the largest, obtained by application of the *Product rule*, forget about

- repetitions $\rightarrow$ *permutations*
- some elements $\rightarrow$ *$k$-permutations*
- ordering $\rightarrow$ *$k$-combinations*

Each of these computes a smaller sets of the possible arrangements universe represented by the application of the *Product rule*. This is the same pattern found in the relationship between the *Dot product* and *Pearson correlation* described in the [[cosine-similarity-and-pearson-correlation|dedicated note]].

## Related

- [[conditional-probability-and-bayes-rule]] — permutations and combinations are the counting tools that underpin event probability
