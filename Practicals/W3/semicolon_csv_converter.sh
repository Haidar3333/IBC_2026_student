#!/bin/bash

input_file="$1"
output_file="${input_file%.*}_converted.csv"

tr ';' ',' < "$input_file" > "$output_file"

echo "Converted file saved as $output_file"

Save and run:

chmod +x Practicals/W3/semicolon_csv_converter.sh
printf 'gene;count;species\nBRCA1;10;human\nTP53;8;mouse\n' > Practicals/W3/file_to_convert.csv
bash Practicals/W3/semicolon_csv_converter.sh Practicals/W3/file_to_convert.csv
cat Practicals/W3/file_to_convert_converted.csv

