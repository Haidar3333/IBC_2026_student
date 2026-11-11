# Week 11 - Recreating a published iris figure
# Source: Murphy, Machine Learning: A Probabilistic Perspective
# Figure 1.4
# Dataset: Edgar Anderson's iris measurements

data(iris)

# Species colors and plotting symbols
colors <- c("red", "darkgreen", "blue")
symbols <- c(16, 18, 8)

# Create a scatterplot matrix with histograms on diagonal
png("recreated_figure.png", width=1400, height=1400, res=150)

par(mar=c(2,2,2,2))

# Function for diagonal histograms
panel_hist <- function(x, ...) {
  usr <- par("usr")
  on.exit(par(usr=usr))
  par(usr=c(usr[1:2], 0, 1.5))
  h <- hist(x, plot=FALSE)
  breaks <- h$breaks
  y <- h$counts / max(h$counts)
  rect(breaks[-length(breaks)], 0,
       breaks[-1], y,
       col="lightblue", border="white")
}

# Function for colored scatterplots
panel_points <- function(x, y, ...) {
  points(x, y,
         col=colors[as.integer(iris$Species)],
         pch=symbols[as.integer(iris$Species)],
         cex=0.65)
}

pairs(iris[,1:4],
      diagonal.panel=panel_hist,
      lower.panel=panel_points,
      upper.panel=panel_points,
      labels=c("Sepal Length",
               "Sepal Width",
               "Petal Length",
               "Petal Width"),
      main="Iris Measurements by Species")

dev.off()

cat("Recreated scientific figure saved.\n")
