# Week 10 Final Problems

## 1. Are Most Toads Right Handed?

I simulated 100,000 experiments per toad under the null
hypothesis that right and left hands are equally likely.
I used a two-sided test with a significance level of 0.05.

| Toad | Sex | Rights/Trials | p-value | Classification |
|---|---|---|---|---|
| T1 | F | 14/16 | 0.00421 | Right handed |
| T2 | M | 12/15 | 0.03587 | Right handed |
| T3 | M | 3/17 | 0.01250 | Left handed |
| T4 | M | 15/15 | 0.00008 | Right handed |
| T5 | M | 12/16 | 0.07635 | No handedness |
| T6 | F | 16/16 | 0.00004 | Right handed |
| T7 | M | 15/16 | 0.00040 | Right handed |
| T8 | F | 15/16 | 0.00057 | Right handed |
| T9 | F | 2/16 | 0.00411 | Left handed |
| T10 | F | 15/16 | 0.00048 | Right handed |
| T11 | M | 15/15 | 0.00011 | Right handed |
| T12 | F | 12/17 | 0.14406 | No handedness |
| T13 | F | 16/18 | 0.00127 | Right handed |
| T14 | F | 8/18 | 0.81461 | No handedness |
| T15 | M | 14/15 | 0.00082 | Right handed |
| T16 | M | 15/16 | 0.00061 | Right handed |
| T17 | F | 2/16 | 0.00430 | Left handed |
| T18 | M | 9/16 | 0.80104 | No handedness |

There were 11 right-handed, 3 left-handed, and 4 unclassified toads.

### Right versus left handedness
Among the 14 toads classified as handed, the two-sided binomial test gave p = 0.05737.
I did not reject the null hypothesis of equal right and left handedness.

### Male versus female toads
I randomized the right-handed classification across sex groups 10,000 times.
The observed female-minus-male proportion difference was -0.1111.
The randomization p-value was 1.00000.
I did not find significant evidence of an association between sex and right handedness.

## 2. Assortative Mating in Animals

I calculated the mean correlation coefficient for each taxon.
For each taxon, I randomly sampled the same number of r values
from the full dataset 50,000 times without replacement.
I calculated a one-sided p-value for an unusually high mean r.

```r
mean_r <- function(taxon) {
  mean(jiang$r[jiang$Taxon == taxon])
}
```

| Taxon | Experiments | Mean r | p-value |
|---|---:|---:|---:|
| Amphibian | 143 | 0.1855 | 0.99998 |
| Annelids | 1 | 0.2000 | 0.59255 |
| Bird | 52 | 0.1318 | 0.99978 |
| Chelicerate | 9 | 0.4911 | 0.01128 |
| Crustacean | 149 | 0.4030 | 0.00002 |
| Fish | 37 | 0.3972 | 0.00274 |
| Gastropod | 10 | 0.4010 | 0.07912 |
| Insect | 106 | 0.1966 | 0.99834 |
| Mammal | 1 | 0.0090 | 0.84562 |
| Protist | 5 | 0.6140 | 0.00396 |
| Reptile | 8 | 0.1175 | 0.92972 |

Fish had a mean r of 0.3972 based on 37 experiments.
The fish mean was significantly high compared with random samples.

A positive mean r suggests assortative mating, but a
positive mean alone does not establish statistical significance.

The p-values are Monte Carlo estimates, so small
differences are possible with other random seeds.
