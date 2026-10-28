import csv
from collections import Counter

counts = Counter()

with open("Gesquiere2011_data.csv", newline="") as file:
    reader = csv.DictReader(file)
    for row in reader:
        individual = row["maleID"]
        counts[individual] += 1

with open("Num_samples.csv", "w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["maleID", "Num_samples"])

    for individual in sorted(counts, key=int):
        writer.writerow([individual, counts[individual]])

print("Created Num_samples.csv")
