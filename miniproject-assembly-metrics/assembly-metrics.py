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

file.close()

###OPTIONAL PART
file = open(sys.argv[1])
genomes = fasta.FASTAReader(file)
# Create a list to store contig lengths
contig_leng = []

# Append the list
for ident, sequence in genomes:
    contig_leng.append(len(sequence))


# Sort the list
contig_leng.sort(reverse=True)

# Iterate through the list using a for loop and at each iteration
cum_leng = 0
for i in contig_leng:
    cum_leng += i # Sum up the cumulative length thus far
    if cum_leng > 0.5 * total_length:
        break #Stop when the cumulative length is greater than half the total length
    


print("N50 statistics:", cum_leng)




# Close the file
file.close()