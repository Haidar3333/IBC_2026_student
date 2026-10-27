# Find matrix files in the class repository
folder <- "../IntroBiolComp-2026/Unix/DataFiles/Saavedra2013"
files <- list.files(folder, pattern = "\\.txt$", full.names = TRUE)

results <- data.frame(File=character(), Nrow=integer(), Ncol=integer(), p_1=numeric(), p_0=numeric())
for (file in files) {
  mat <- as.matrix(read.table(file))
  results <- rbind(results, data.frame(File=basename(file), Nrow=nrow(mat), Ncol=ncol(mat), p_1=mean(mat == 1), p_0=mean(mat == 0)))
}
write.table(results, "Practicals/W9/MatrixStats.tsv", sep="\t", row.names=FALSE, quote=FALSE)
