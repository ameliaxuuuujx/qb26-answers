#!/usr/bin/env python3

# Read sample IDs from gt_long.txt
gt_fl = "/Users/cmdb/qb26-answers/week2/gt_long.txt"

# Create a list of sample id
sample_ids = []
for line in open(gt_fl):
    if line.startswith("sample"):
        continue

    fields =  line.rstrip("\n").split("\t")
    sid = fields[0]

    if sid not in sample_ids:
        sample_ids.append(sid)

# Open the output file
out_file = open("crossovers.txt", "w")
out_file.write("sample\tcrossovers\n")

# Analyze one sample at a time
for sid in sample_ids:
    current_chrom = ""
    current_geno = ""
    candidate_geno = ""
    candidate_count = 0
    crossover_count = 0
    # Read gt_long.txt from the beginning of each sample
    for line in open(gt_fl):
        if line.startswith("sample"):
            continue
        fields = line.rstrip("\n").split("\t")
        row_sample = fields[0]
        chrom = fields[1]
        genotype = fields[3]
        # skip rows from other samples
        if row_sample != sid:
            continue
        # reset the ancestry tracking at the start of each chr
        if chrom != current_chrom:
            current_chrom = chrom
            current_geno = genotype
            candidate_geno = ""
            candidate_count = 0
            continue
        # Reset the candidate if genotype matched the cuurent ancestry
        if genotype == current_geno:
            candidate_geno = ""
            candidate_count = 0
        else: #track consecutive SNPs supporting a new ancestry
            if genotype == candidate_geno:
                candidate_count += 1
            else:
                candidate_geno = genotype
                candidate_count = 1
            # Count a crossover after 20
            if candidate_count >= 20: 
                crossover_count += 1
                current_geno = candidate_geno
                candidate_geno = ""
                candidate_count = 0
    # write the result for this sample
    output_row = []
    output_row.append(sid)
    output_row.append(str(crossover_count))
    out_file.write("\t".join(output_row) + "\n")

# close the file
out_file.close()
