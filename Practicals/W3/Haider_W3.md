# Week 3 Practical

## 5.1 Markdown Homework

I converted my Week 1 practical answers into Markdown format and saved them as `Haider_P1.txt`.

```bash
git add Practicals/W3/Haider_P1.txt
git commit -m "Add Week 1 practical in Markdown format"
git push
```

## 5.2 Semicolon-Delimited to Comma-Delimited

I created a script that converts semicolons into commas and saves the results under a different filename.

```bash
#!/bin/bash

input_file="$1"
output_file="${input_file%.*}_converted.csv"

tr ';' ',' < "$input_file" > "$output_file"

echo "Converted file saved as $output_file"
```

I tested the script using:

```bash
chmod +x Practicals/W3/semicolon_csv_converter.sh
bash Practicals/W3/semicolon_csv_converter.sh Practicals/W3/file_to_convert.csv
```

The converted output was:

```text
gene,count,species
BRCA1,10,human
TP53,8,mouse
```

Save and exit.
6. Connect and upload everything

git add .
git commit -m "Complete Week 3 practical"
git remote add origin git@github.com:Haidar3333/IBC_2026_student.git
git push -u origin main
git status

Haider should submit this link on Canvas:
# Week 3 Practical

## 5.1 Markdown Homework

I converted my Week 1 practical answers into Markdown format and saved them as `Haider_P1.txt`.

```bash
git add Practicals/W3/Haider_P1.txt
git commit -m "Add Week 1 practical in Markdown format"
git push
```

## 5.2 Semicolon-Delimited to Comma-Delimited

I created a script that converts semicolons into commas and saves the results under a different filename.

```bash
#!/bin/bash

input_file="$1"
output_file="${input_file%.*}_converted.csv"

tr ';' ',' < "$input_file" > "$output_file"

echo "Converted file saved as $output_file"
```

I tested the script using:

```bash
chmod +x Practicals/W3/semicolon_csv_converter.sh
bash Practicals/W3/semicolon_csv_converter.sh Practicals/W3/file_to_convert.csv
```

The converted output was:

```text
gene,count,species
BRCA1,10,human
TP53,8,mouse
``
