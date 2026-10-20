import csv
import re
from collections import Counter
from pathlib import Path
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

folder = Path(__file__).resolve().parent

text = (folder / "pubmed_results.txt").read_text(
    encoding="utf-8", errors="replace"
)

# Extract ZIP codes from publication records
codes = re.findall(r"\b\d{5}(?:-\d{4})?\b", text)
counts = Counter(code[:5] for code in codes)

zip_code = []
zip_long = []
zip_lat = []
zip_count = []

# Read the ZIP coordinate file
with open(folder / "zipcodes_coordinates.txt",
          newline="", encoding="utf-8-sig") as file:

    reader = csv.reader(file)

    for row in reader:
        if len(row) < 3:
            continue

        code = row[0].strip()

        if code not in counts:
            continue

        try:
            latitude = float(row[1])
            longitude = float(row[2])
        except ValueError:
            continue

        zip_code.append(code)
        zip_lat.append(latitude)
        zip_long.append(longitude)
        zip_count.append(counts[code])

if not zip_code:
    raise ValueError("No matching ZIP codes found. Check data format.")

plt.figure(figsize=(15, 9))
plt.scatter(zip_long, zip_lat, s=zip_count, c=zip_count)
plt.colorbar(label="ZIP code occurrences")
plt.xlim(-125, -65)
plt.ylim(23, 50)
plt.xlabel("Longitude")
plt.ylabel("Latitude")
plt.title("Map of Science - Science Magazine 2015")
plt.tight_layout()

plt.savefig("map_of_science.png", dpi=200)
plt.close()

print("Unique ZIP codes mapped:", len(zip_code))
print("Map saved as map_of_science.png")
