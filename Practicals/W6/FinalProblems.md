 Week 6 Final Problems

 1. Debug this code

 What each line does
import pickle` loads the pickle module.

`genetic_code = pickle.load(...)` loads the genetic code.

`test_mRNA` is the mRNA sequence used to test the function.

`def get_amino_acids(mRNA)` creates a function that translates mRNA.

`i = 0` starts at the first base.

`aa_sequence = []` initializes an empty list to hold the amino acids.

The `while` loop goes through the mRNA sequence.

`codon = mRNA[i:(i + 3)]` gets three bases for one codon.

`aa = genetic_code[codon]` maps a codon to an amino acid.

It exits the loop if it encounters a stop codon.

`aa_sequence.append(aa)` adds each amino acid to the list.

`i = i + 3` moves to the next codon.

`return "".join(aa_sequence)`

Debugging

Using pdb to trace through the codons revealed that the first codon to be processed by the function was indeed AUG. However, upon continuing to trace through the function, the next codon reported by pdb was AAU, not GAA. It became clear that the line i = i + 4 was moving 4 bases at a time, not 3 as required by the nature of codons. Changing this line to i = i + 3 yielded results as expected, with the translated mRNA returning the sequence MEFSL.
