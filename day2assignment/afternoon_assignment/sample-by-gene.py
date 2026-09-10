#!/usr/bin/env python3

import sys
import gzip

fs = gzip.open(sys.argv[1],mode = "rt")

# Skip first two lines
fs.readline()
fs.readline()

#Read the next header line and save the fields after splitting
header = fs.readline().rstrip('\n').split('\t')
# print(header[0], header[1]) -->Name Description


# Read the next data line and save the fields after splitting
data = fs.readline().rstrip('\n').split('\t')
# print(data[0], data[1]) -->ENSG00000223972.5 DDX11L1

#close the file
fs.close()

# Print sample ID and expression
for i in range(2, len(header)):
    sample_id = header[i]
    expression = float(data[i])

    if expression > 1:
        print(sample_id, expression, sep="\t")


