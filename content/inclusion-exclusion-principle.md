---
title: inclusion-exclusion principle
publish: true
created: 2026-03-29
updated: 2026-03-29
tags:
  - probability
  - combinatorics
---
## Inclusion-Exclusion principle

When sets overlap, the [[sum-and-product-rule-permutations-and-combinations|Sum rule]] overcounts because shared elements are added more than once. The *Inclusion-Exclusion* principle corrects this by alternating between adding and subtracting the cardinalities of progressively deeper intersections: add singles, subtract pairs, add triples, and so on.

For two sets: $|A \cup B| = |A| + |B| - |A \cap B|$

For three: $|A \cup B \cup C| = |A| + |B| + |C| - |A \cap B| - |A \cap C| - |B \cap C| + |A \cap B \cap C|$

Here's an implementation that generalises to any number of sets.

```python
# 1. Setup
import itertools as it

# define patients' cohorts
cohort_cardiac = {"P001", "P003", "P007", "P012", "P015", "P018", "P022"}
cohort_respiratory = {"P002", "P003", "P005", "P009", "P012", "P019"}
cohort_metabolic = {"P004", "P007", "P010", "P015", "P020"}

# collect them in tuple
cohorts = (cohort_cardiac, cohort_respiratory, cohort_metabolic)

# 2. Define functions

# intersection of variable length tuples of sets
def intersect(tup):
    inner_list = list(tup)
    intersection = inner_list.pop()
    for _i in range(len(inner_list), 0, -1):
        item = inner_list.pop()
        intersection = intersection & item
    return intersection

def include_exclude(cohorts):
    _u = 0
    for _i in range(0, len(cohorts)):
        _k = _i + 1
        combinations = it.combinations(cohorts, _k)
        if _k % 2 == 1:
            for c in combinations:
                _u = _u + len(intersect(c))
        else:
            for c in combinations:
                _u = _u + len(intersect(c)) * -1
    return _u
    
# 3. Apply

print(f"Cardinality of union: {include_exclude(cohorts)}")
```
