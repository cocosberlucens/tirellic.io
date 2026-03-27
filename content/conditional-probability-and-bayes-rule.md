---
title: conditional probability and Bayes' rule
publish: true
created: 2026-02-14
updated: 2026-03-07
tags:
  - probability
  - bayes
---

## conditional probability

probability questions are asked relative to some universe of possibilities, the *sample space* $\Omega$, the *universe*—i like *cosmos*. the probability of an event $A$, $P(A)$, is thus a fraction of the universe.
in $P(A|B)$, read as $\textit{the probability of A given B}$ , $B$ becomes the universe relative to which the part of $A$ that lives inside of $B$ gets compared, thus *conditional probability* is defined

$$
P(A|B)=\frac{P(A \cap B)}{P(B)}
$$

or, in other words

```sql
select sum(case when condition_a = 'A' then 1 else 0 end) / count(*) 
from omega
where condition_b = 'B' 
```

### disjoint and independent events

two *disjoint* events have no intersection $(A \cap B)=\varnothing$ , and hence, from the formula above $P(A|B)=0$. if $B$ happens, $A$ doesn't. 

whereas $A$ and $B$ are *independent* when shrinking the universe to $B$ doesn't change the probability of $A$, i.e. $P(A|B)=P(A)$. 

it's worth noting that two disjoint events are *maximally dependent*! knowing that $A$ happened tells everything about $B$, when shrinking the universe to $B$, $A$ vanishes completely.

## bayes' rule

from 

$$
P(A|B)=\frac{P(A \cap B)}{P(B)}
$$

also the probability of $B$ given $A$ is

$$
P(B|A)=\frac{P(A \cap B)}{P(A)}
$$

hence the intersection of $A$ and $B$ can be expressed by both

$$
P(A \cap B)=P(A|B) \cdot P(B)
$$

and 

$$
P(A \cap B)=P(B|A) \cdot P(A)
$$

that is to say that *knowing $P(A|B)$ makes it possible to know $P(B|A)$*

$$
P(B|A)=\frac{P(A|B) \cdot P(B)}{P(A)}
$$

### practical bayes

two events $D$, a disease and a positive test $\mathit{Positive}$. $D$ prevalence is $1 \text{ in } 10\,000$, test accuracy is $80 \text{ in } 100$, and false positive rate $5 \text{ in } 100$.

lay out the events probabilities
- $P(D)=0.0001$
- $P(\mathit{Positive}|D)=0.8$
- $P(\mathit{Positive}|\neg D)=0.05$
- $P(\neg\mathit{Positive}|\neg D)=0.95$

remembering that, from rearranging the conditional probability formula

$$
P(A \cap B)=P(B|A) \cdot P(A)
$$
and

$$
P(A \cap B)=P(A|B) \cdot P(B)
$$

what is the probability $P(D|\mathit{Positive})$ of actually having the disease upon a positive test?

what is the *universe* here? the set of all *tested subjects*. 

think of the *tested subject*, they have a chance of $1 \text{ in } 10\,000$ of having the disease and if they do, they have a $0.8$ chance of testing positive: $0.8 \cdot 0.0001 = 0.00008$: this is  

$$
P(\mathit{Positive}|D) \cdot P(D)
$$
at the same time, they have $9\,999 \text{ in } 10\,000$ chances of *not having* the disease and if they don't, they have $0.05$ chances of testing nonetheless positive: $0.05 \cdot 0.9999 = 0.049995$ and this is

$$
P(\mathit{Positive}|\neg D) \cdot P(\neg D)
$$


but what are these? from the conditional probability formula, they are *intersections*! 
the intersections of the probability of testing positive with the probabilities of both having $P(D)$ 

$$
P(\mathit{Positive} \cap D) = P(\mathit{Positive}|D) \cdot P(D)
$$

and not having $P(\neg D)$ 

$$
P(\mathit{Positive} \cap \neg D) = P(\mathit{Positive}|\neg D) \cdot P(\neg D)
$$

the disease.

what is the interesting question? it's what is the probability of having the disease upon having tested positive, and the chance of a positive outcome, whether having the disease or not, is 

$$
P(\mathit{Positive} \cap D) + P(\mathit{Positive} \cap \neg D)
$$
representing the microcosm of all positive tests, hence

$$
P(D|\mathit{Positive})=\frac{P(\mathit{Positive}|D) \cdot P(D)}{P(\mathit{Positive}|D) \cdot P(D) + P(\mathit{Positive}|\neg D) \cdot P(\neg D)}
$$

or, intuitively

$$
P(D|\mathit{Positive})=\frac{P(\mathit{Positive} \cap D)}{P(\mathit{Positive} \cap D) + P(\mathit{Positive} \cap \neg D)}
$$

the tested subject, for the record, has a $\approx 0.16\%$ probability of having the disease after a positive test.
