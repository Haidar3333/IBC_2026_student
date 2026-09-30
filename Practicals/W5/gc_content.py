# Calculate GC content from Turkey FASTA sequences

fasta_file = "/Users/arsalanhaidari/Library/Mobile Documents/com~apple~CloudDocs/untitled folder/Arsalan/Arsalan/IntroBiolComp-2026/Python/DataFiles/Turkey_transcripts_15.fasta"

with open(fasta_file, "r") as infile, open("gc_content.txt", "w") as outfile:
    sequence_name = ""
    sequence = ""

    for line in infile:
        line = line.rstrip()

        if line.startswith(">"):
            if sequence:
                gc = (sequence.count("G") + sequence.count("C")) / len(sequence)
                outfile.write(sequence_name + "\t" + str(round(gc, 3)) + "\n")

            sequence_name = line[1:].split()[0]
            sequence = ""
        else:
            sequence = sequence + line

    if sequence:
        gc = (sequence.count("G") + sequence.count("C")) / len(sequence)
        outfile.write(sequence_name + "\t" + str(round(gc, 3)) + "\n")