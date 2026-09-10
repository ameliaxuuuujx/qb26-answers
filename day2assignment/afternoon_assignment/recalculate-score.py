#!/usr/bin/env python3

###Write a script that for each feature (line) recalculates the score (column 5) such that
###new_score = original_score * feature_size
###new_score is positive or negative based on the strand (column 6)

import sys

fs = open(sys.argv[1])


for line in fs:
    field = line.strip('\n').split('\t')
    original_score = float(field[4])
    start_pos = int(field[1])
    end_pos = int(field[2])
    strand = field[5]
    

    if strand == "+":
        strand = 1
    else:
        strand = -1

    feature_size = end_pos - start_pos + 1
    new_score = original_score * feature_size * strand
    field[4] = str(new_score)


    sep = "\t"
    bed_line = sep.join(field)

    print(bed_line)
    
fs.close()