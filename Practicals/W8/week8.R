# BIOL 2214 - Week 8 Practical
# Run from the IBC_2026_student repository root

out <- "Practicals/W8"
dir.create(out, recursive=TRUE, showWarnings=FALSE)

# -----------------------------------
# PART 1: Vector exercises
# -----------------------------------

z <- seq(2, 100, by=2)

print(z)
print(sum(z))
print(sum(z) == 51 * 50)
print(z^2)
print(z >= 90)
print(which(z >= 90))

# -----------------------------------
# PART 2: Cherry tree exercises
# -----------------------------------

data(trees)

print(dim(trees))
str(trees)

tree_height <- mean(trees$Height)
tall_trees <- sum(trees$Height > 75)
tree_girth <- mean(trees$Girth[trees$Height > 75])

print(tree_height)
print(tall_trees)
print(tree_girth)

# -----------------------------------
# PART 3: Find assignment data
# -----------------------------------

find_data <- function(filename) {
  folders <- c(
    "R/DataFiles",
    "../IntroBiolComp-2026/R/DataFiles",
    path.expand("~/IntroBiolComp-2026/R/DataFiles")
  )

  paths <- file.path(folders, filename)
  found <- paths[file.exists(paths)]

  if (length(found) == 0) {
    stop(paste("Cannot find:", filename))
  }

  found[1]
}

# -----------------------------------
# PART 4: Genetic disease risks
# -----------------------------------

geno <- read.table(
  find_data("H938_Euro_chr6.geno"),
  header=TRUE
)

risks <- read.csv(
  find_data("SNP_risks.csv")
)

required <- c("nA1A1", "nA1A2", "nA2A2")

stopifnot(all(required %in% names(geno)))
stopifnot(ncol(risks) >= 3)

# Calculate number of sampled individuals
total <- geno$nA1A1 + geno$nA1A2 + geno$nA2A2

sample_count <- max(total, na.rm=TRUE)

# Verify with rowSums()
total_check <- rowSums(geno[,required])
sample_check <- max(total_check, na.rm=TRUE)

stopifnot(isTRUE(all.equal(sample_count, sample_check)))

# Verify genotype and risk data alignment
if (nrow(geno) != nrow(risks)) {
  stop("Genotype and risk row counts differ")
}

if ("SNP" %in% names(risks) &&
    "SNP" %in% names(geno)) {
  if (!identical(as.character(geno$SNP),
                 as.character(risks$SNP))) {
    stop("SNP ordering does not match")
  }
}

# Join risk information from column 3
geno$disease_risk <- risks[[3]]

# Calculate average heterozygous individuals
risk_means <- aggregate(
  geno$nA1A2,
  by=list(risk=geno$disease_risk),
  FUN=mean,
  na.rm=TRUE
)

names(risk_means)[2] <- "mean_heterozygous"

write.csv(
  risk_means,
  file.path(out, "risk_means.csv"),
  row.names=FALSE
)

print(risk_means)

# -----------------------------------
# PART 5: Mammal data
# -----------------------------------

# The mammal dataset has NO header row
smith <- read.delim(
  find_data("Smith2003_data.txt"),
  header=FALSE,
  check.names=FALSE,
  stringsAsFactors=FALSE
)

if (ncol(smith) < 8) {
  stop("Mammal data must contain at least 8 columns")
}

# Column 5 = genus
# Column 6 = species

species_names <- paste(
  trimws(smith[[5]]),
  trimws(smith[[6]])
)

valid_species <- !is.na(smith[[5]]) &
                 !is.na(smith[[6]]) &
                 nzchar(trimws(smith[[5]])) &
                 nzchar(trimws(smith[[6]]))

species_count <- length(
  unique(species_names[valid_species])
)

print(species_count)

# -----------------------------------
# PART 6: Clean missing values
# -----------------------------------

# Column 7 = log body mass
# Column 8 = raw body mass

for (j in c(7, 8)) {
  smith[[j]] <- as.numeric(smith[[j]])

  missing_values <- !is.na(smith[[j]]) &
                    smith[[j]] == -999

  smith[[j]][missing_values] <- NA
}

# Verify no -999 remains
stopifnot(
  !any(smith[[7]] == -999, na.rm=TRUE),
  !any(smith[[8]] == -999, na.rm=TRUE)
)

write.table(
  smith,
  file.path(out, "Smith2003_clean.tsv"),
  sep="\t",
  row.names=FALSE,
  col.names=FALSE,
  quote=FALSE,
  na="NA"
)

# -----------------------------------
# PART 7: Create assignment answers
# -----------------------------------

lines <- c(
  "# Week 8 Practical - Final Problems",
  "",
  "## 1. Vector Exercises",
  "",
  paste0("- Number of even numbers: **", length(z), "**"),
  paste0("- Sum: **", sum(z), "**"),
  paste0("- Sum equals 51 * 50: **",
         sum(z) == 51 * 50, "**"),
  "- `z^2` returns the square of each element.",
  "- `z >= 90` identifies values from 90 through 100.",
  paste0("- Positions: **",
         paste(which(z >= 90), collapse=", "),
         "**"),
  "",
  "## 2. Cherry Tree Exercises",
  "",
  paste0("- Dimensions: **",
         nrow(trees), " rows, ",
         ncol(trees), " columns**"),
  paste0("- Mean height: **", tree_height, "**"),
  paste0("- Trees above 75 feet: **",
         tall_trees, "**"),
  paste0("- Mean girth of taller trees: **",
         round(tree_girth, 3), "**"),
  "",
  "## 3. Disease Risk Analysis",
  "",
  paste0("- Maximum sampled individuals: **",
         sample_count, "**"),
  paste0("- Verified using rowSums(): **",
         sample_check, "**"),
  "",
  "### Average Heterozygous Individuals"
)

for (i in seq_len(nrow(risk_means))) {
  lines <- c(
    lines,
    paste0(
      "- ", risk_means$risk[i], ": **",
      round(risk_means$mean_heterozygous[i], 3),
      "**"
    )
  )
}

lines <- c(
  lines,
  "",
  "## 4. Mammal Data Analysis",
  "",
  paste0("- Number of species represented: **",
         species_count, "**"),
  "- Species identified using genus and species columns.",
  "",
  "## 5. Missing Data Cleanup",
  "",
  "- Column 7 contains log body mass.",
  "- Column 8 contains raw body mass.",
  "- Missing values coded as -999 were replaced with NA.",
  "- Cleaned data saved as Smith2003_clean.tsv.",
  "",
  "## Output Files",
  "",
  "- week8.R",
  "- risk_means.csv",
  "- Smith2003_clean.tsv",
  "- FinalProblems.md"
)

writeLines(
  lines,
  file.path(out, "FinalProblems.md")
)

cat("\nWEEK 8 COMPLETED\n")
cat("Sample count:", sample_count, "\n")
cat("Species count:", species_count, "\n")
cat("Output directory:", out, "\n")
