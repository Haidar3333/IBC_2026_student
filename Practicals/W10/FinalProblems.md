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


## Complete R Code

The following R code was used to complete the analyses above.

```r
# Week 10: Simulation and Randomization
set.seed(2026)

output_dir <- "Practicals/W10"
data_dir <- file.path(
  path.expand("~"),
  "IntroBiolComp-2026", "R", "DataFiles"
)

# Read the data
toads <- read.delim(file.path(data_dir, "Toad_Handedness.tsv"))
jiang <- read.delim(file.path(data_dir, "Jiang2013_data.csv"))

# PART 1: TOAD HANDEDNESS
n_sim <- 100000

toad_results <- data.frame(
  Toad = toads$Toad,
  Sex = toads$Sex,
  N_trials = toads$N_trials,
  N_rights = toads$N_rights,
  p_value = numeric(nrow(toads)),
  Classification = character(nrow(toads))
)

for (i in seq_len(nrow(toads))) {
  n <- toads$N_trials[i]
  observed <- toads$N_rights[i]

  simulated <- rbinom(n_sim, size = n, prob = 0.5)

  p <- (sum(abs(simulated - n/2) >=
            abs(observed - n/2)) + 1) / (n_sim + 1)

  toad_results$p_value[i] <- p

  toad_results$Classification[i] <- if (p >= 0.05) {
    "No handedness"
  } else if (observed > n/2) {
    "Right handed"
  } else {
    "Left handed"
  }
}

write.csv(toad_results,
          file.path(output_dir, "ToadResults.csv"),
          row.names = FALSE)

# Test right vs left among classified toads
right_n <- sum(toad_results$Classification == "Right handed")
left_n <- sum(toad_results$Classification == "Left handed")
handed_n <- right_n + left_n

p_handed <- if (handed_n > 0) {
  binom.test(right_n, handed_n, p = 0.5)$p.value
} else {
  NA_real_
}

# Randomization test: sex and right-handedness
is_right <- as.integer(
  toad_results$Classification == "Right handed"
)
female <- toad_results$Sex == "F"
male <- toad_results$Sex == "M"

if (!any(female) || !any(male)) {
  stop("Both male and female toads are required.")
}

observed_sex <- mean(is_right[female]) -
                mean(is_right[male])

n_perm <- 10000
sex_diffs <- replicate(n_perm, {
  shuffled <- sample(is_right)
  mean(shuffled[female]) - mean(shuffled[male])
})

p_sex <- (sum(abs(sex_diffs) >=
              abs(observed_sex)) + 1) / (n_perm + 1)

# PART 2: ASSORTATIVE MATING
jiang$r <- as.numeric(jiang$r)
jiang <- jiang[!is.na(jiang$r) &
               !is.na(jiang$Taxon), ]

mean_r <- function(taxon) {
  mean(jiang$r[jiang$Taxon == taxon])
}

taxa <- sort(unique(jiang$Taxon))
n_random <- 50000

taxon_results <- data.frame(
  Taxon = taxa,
  N = integer(length(taxa)),
  Mean_r = numeric(length(taxa)),
  p_value = numeric(length(taxa))
)

for (i in seq_along(taxa)) {
  taxon <- taxa[i]
  values <- jiang$r[jiang$Taxon == taxon]
  n <- length(values)
  observed_mean <- mean_r(taxon)

  random_means <- replicate(n_random, {
    mean(sample(jiang$r, size = n, replace = FALSE))
  })

  # One-sided test for unusually high mean r
  p <- (sum(random_means >= observed_mean) + 1) /
       (n_random + 1)

  taxon_results$N[i] <- n
  taxon_results$Mean_r[i] <- observed_mean
  taxon_results$p_value[i] <- p
}

write.csv(taxon_results,
          file.path(output_dir, "TaxonResults.csv"),
          row.names = FALSE)

# Generate Markdown answers
fmt <- function(x) {
  ifelse(is.na(x), "N/A", sprintf("%.5f", x))
}

lines <- c(
  "# Week 10 Final Problems",
  "",
  "## 1. Are Most Toads Right Handed?",
  "",
  "I simulated 100,000 experiments per toad under the null",
  "hypothesis that right and left hands are equally likely.",
  "I used a two-sided test with a significance level of 0.05.",
  "",
  "| Toad | Sex | Rights/Trials | p-value | Classification |",
  "|---|---|---|---|---|"
)

for (i in seq_len(nrow(toad_results))) {
  x <- toad_results[i, ]
  lines <- c(lines, sprintf(
    "| %s | %s | %d/%d | %s | %s |",
    x$Toad, x$Sex, x$N_rights, x$N_trials,
    fmt(x$p_value), x$Classification
  ))
}

lines <- c(
  lines, "",
  sprintf(
    "There were %d right-handed, %d left-handed, and %d unclassified toads.",
    right_n, left_n, sum(toad_results$Classification == "No handedness")
  ),
  "",
  "### Right versus left handedness",
  sprintf(
    "Among the %d toads classified as handed, the two-sided binomial test gave p = %s.",
    handed_n, fmt(p_handed)
  ),
  if (is.na(p_handed)) {
    "There were no classified toads to compare."
  } else if (p_handed < 0.05) {
    "I rejected the null hypothesis of equal right and left handedness."
  } else {
    "I did not reject the null hypothesis of equal right and left handedness."
  },
  "",
  "### Male versus female toads",
  "I randomized the right-handed classification across sex groups 10,000 times.",
  sprintf(
    "The observed female-minus-male proportion difference was %.4f.",
    observed_sex
  ),
  sprintf("The randomization p-value was %s.", fmt(p_sex)),
  if (p_sex < 0.05) {
    "I found evidence of an association between sex and right handedness."
  } else {
    "I did not find significant evidence of an association between sex and right handedness."
  },
  "",
  "## 2. Assortative Mating in Animals",
  "",
  "I calculated the mean correlation coefficient for each taxon.",
  "For each taxon, I randomly sampled the same number of r values",
  "from the full dataset 50,000 times without replacement.",
  "I calculated a one-sided p-value for an unusually high mean r.",
  "",
  "```r",
  "mean_r <- function(taxon) {",
  "  mean(jiang$r[jiang$Taxon == taxon])",
  "}",
  "```",
  "",
  "| Taxon | Experiments | Mean r | p-value |",
  "|---|---:|---:|---:|"
)

for (i in seq_len(nrow(taxon_results))) {
  x <- taxon_results[i, ]
  lines <- c(lines, sprintf(
    "| %s | %d | %.4f | %s |",
    x$Taxon, x$N, x$Mean_r, fmt(x$p_value)
  ))
}

fish <- taxon_results[taxon_results$Taxon == "Fish", ]

if (nrow(fish) == 1) {
  lines <- c(
    lines, "",
    sprintf(
      "Fish had a mean r of %.4f based on %d experiments.",
      fish$Mean_r, fish$N
    ),
    if (fish$p_value < 0.05) {
      "The fish mean was significantly high compared with random samples."
    } else {
      "The fish mean was not significantly high compared with random samples."
    }
  )
}

lines <- c(
  lines, "",
  "A positive mean r suggests assortative mating, but a",
  "positive mean alone does not establish statistical significance.",
  "",
  "The p-values are Monte Carlo estimates, so small",
  "differences are possible with other random seeds."
)

writeLines(lines, file.path(output_dir, "FinalProblems.md"))

cat("Week 10 analysis completed.\n")
print(toad_results)
cat("\nRight vs left p-value:", p_handed, "\n")
cat("Sex randomization p-value:", p_sex, "\n")
print(taxon_results)
```
