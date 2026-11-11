# Week 11 Practical - Data Visualization

## Problem 1: pch Symbols

I recreated the R plotting symbols chart using a for loop.

The script uses symbols 0 through 25. I used integer
division and the modulo operator to calculate the row
and column for each symbol.

I did not use expand.grid().

The points() function draws each symbol, and text()
adds the number underneath it.

### My Figure

![R Plotting Symbols](pch_symbols.png)

### Code

See [pch_symbols.R](pch_symbols.R) for my complete code.

## Problem 2: Scientific Data Visualization

### Scientific Source

Fisher, R. A. (1936).
The Use of Multiple Measurements in Taxonomic Problems.
Annals of Eugenics, 7, 179-188.

https://doi.org/10.1111/j.1469-1809.1936.tb02137.x

### Dataset

I used the iris dataset available in R.

The dataset includes measurements from three iris species:
setosa, versicolor, and virginica.

### My Figure

![Iris Figure](recreated_figure.png)

### Explanation

I created a boxplot comparing petal lengths for the
three iris species.

I chose a boxplot because it makes it easy to compare
the median, spread, and differences between groups.

I also added individual data points so the reader
can see the observations.

The different colors help identify each species.

The figure shows that setosa generally has shorter
petals than versicolor and virginica.

### Code

See [recreate_figure.R](recreate_figure.R) for my
complete R code.

### Note on the Original Figure

This visualization uses the dataset associated with
Fisher's paper. It is not yet a verified recreation
of a specific original figure from that paper.
The original figure must be added before submission.
