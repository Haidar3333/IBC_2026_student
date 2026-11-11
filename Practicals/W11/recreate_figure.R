# Week 11 - Scientific data visualization
# Data: Fisher's Iris dataset (1936)

data(iris)

png("recreated_figure.png",
    width=1000, height=750, res=120)

par(mar=c(5,5,4,2))

species_colors <- c("gold", "darkgreen", "orchid")

boxplot(Petal.Length ~ Species,
        data=iris,
        col=species_colors,
        main="Petal Length by Iris Species",
        xlab="Iris Species",
        ylab="Petal Length (cm)",
        border="black")

stripchart(Petal.Length ~ Species,
           data=iris,
           vertical=TRUE,
           method="jitter",
           pch=16,
           col=rgb(0,0,0,0.35),
           add=TRUE)

dev.off()

cat("Scientific figure created successfully!\n")
