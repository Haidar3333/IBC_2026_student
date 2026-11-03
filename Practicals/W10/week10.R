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
