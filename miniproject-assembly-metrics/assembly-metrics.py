#!/usr/bin/env python3

import sys
import fasta

file = open(sys.argv[1])
genomes = fasta.FASTAReader(file)


count = 0
total_length = 0
for ident, sequence in genomes:
    # Count the num of contigs
    count += 1
    # Calculate the total length
    total_length += len(sequence)

# Calculate the average length
avg_length = total_length / count

# Answer
print("Number of contigs: ", count)
print("Total length:", total_length)
print("Average length:", avg_length)



# Close the file
file.close()