#!/usr/bin/env python3

# Exercise 6.2: Codon to Amino Acid

# Create an empty dictionary
codon_dictionary = {}

# Open the codon table
with open("CodonTable.tsv") as file:
    headers = file.readline().strip().split("\t")

    codon_index = headers.index("Codon")
    symbol_index = headers.index("Symbol")

    for line in file:
        columns = line.strip().split("\t")

        codon = columns[codon_index]
        symbol = columns[symbol_index]

        codon_dictionary[codon] = symbol

# Define the DNA sequence
dna_sequence = "CTA GGA GTG ATT TCG"

# Split the DNA sequence into codons
codons = dna_sequence.split()

# Create an empty list for amino acids
amino_acids = []

# Translate each codon
for codon in codons:
    amino_acid = codon_dictionary[codon]
    amino_acids.append(amino_acid)

# Print the results
print("DNA sequence:", dna_sequence)
print("Codons:", codons)
print("Amino acid sequence:", amino_acids)
