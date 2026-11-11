# Week 11 - Plotting symbols
# Recreate the pch symbols chart without expand.grid()

png("pch_symbols.png", width=1000, height=750, res=120)

par(mar=c(2,2,3,2))

plot(0, 0, type="n",
     xlim=c(0,6), ylim=c(0,5),
     axes=FALSE, xlab="", ylab="",
     main="R Plotting Symbols (pch 0-25)")

for (i in 0:25) {
  row <- i %/% 6
  column <- i %% 6

  x <- column + 0.5
  y <- 4.5 - row

  points(x, y, pch=i, cex=2.5,
         col="blue", bg="lightblue")

  text(x, y-0.35, labels=i, cex=0.9)
}

dev.off()
