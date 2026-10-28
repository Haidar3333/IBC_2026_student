#!/bin/bash

# $1 is the input file
# $2 is the individual ID
# Count matching IDs in the first column
awk -F '[,\t]' -v id="$2" '$1 == id {count++} END {print count+0}' "$1"
