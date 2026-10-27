library(EBImage)
# Load the supplied leaf area function
folder <- "../IntroBiolComp-2026/R/DataFiles/leafarea"
source("../IntroBiolComp-2026/R/DataFiles/getArea.R")
files <- list.files(folder, pattern="\\.JPG$", full.names=TRUE, ignore.case=TRUE)

results <- data.frame(Plant=character(), Time=character(), Area=numeric())
for (file in files) {
  name <- tools::file_path_sans_ext(basename(file))
  parts <- strsplit(name, "_")[[1]]
  results <- rbind(results, data.frame(Plant=paste(parts[-1], collapse="_"), Time=parts[1], Area=getArea(basename(file))))
}

# Compare each plant's t1 and t2 measurements
wide <- reshape(results, idvar="Plant", timevar="Time", direction="wide")
wide$Growth <- wide$Area.t2 - wide$Area.t1
print(mean(wide$Growth, na.rm=TRUE))
write.csv(wide, "Practicals/W9/LeafAreaResults.csv", row.names=FALSE)
