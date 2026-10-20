import re
import csv
from collections import Counter
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# Read PubMed data
with open("pubmed_results.txt", encoding="utf-8", errors="replace") as f:
    text = f.read()

# Extract US ZIP codes
zip_matches = re.findall(r"\b\d{5}(?:-\d{4})?\b", text)
counts = Counter(z[:5] for z in zip_matches)

zip_code = []
zip_long = []
zip_lat = []
zip_count = []

# Match ZIP codes to coordinates
with open("zipcodes_coordinates.txt", newline="", encoding="utf-8-sig") as f:
    reader = csv.reader(f)

    for row in reader:
        if len(row) < 3:
            continue

        code = row[0].strip()

        if code in counts:
            try:
                lat = float(row[1])
                lon = float(row[2])
            except ValueError:
                continue

            zip_code.append(code)
            zip_lat.append(lat)
            zip_long.append(lon)
            zip_count.append(counts[code])

if not zip_code:
    raise ValueError("No matching ZIP codes found. Check the data format.")

# Create the map
plt.figure(figsize=(15, 9))
plt.scatter(zip_long, zip_lat, s=zip_count, c=zip_count)
plt.colorbar(label="Number of occurrences")
plt.xlim(-125, -65)
plt.ylim(23, 50)
plt.xlabel("Longitude")
plt.ylabel("Latitude")
plt.title("Map of Science - 2015")
plt.tight_layout()
plt.savefig("map_of_science.png", dpi=200)
plt.close()

print("Unique ZIP codes mapped:", len(zip_code))
print("Map saved as map_of_science.png")
