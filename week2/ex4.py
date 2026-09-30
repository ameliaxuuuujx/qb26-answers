#!/usr/bin/env python3

vcf_file = '/Users/cmdb/qb26-answers/week2/variants/biallelic.vcf'

af_out = open("AF.txt", "w")
gt_out = open("gt_long.txt", "w")



# Write headers
af_out.write("AF\n")
gt_out.write("sample\tchrom\tpos\tgenotype\n")

for line in open(vcf_file):
    # Read sample IDs from the VCF header; sample columns start at column 10.
    if line.startswith("#CHROM"):
        fields = line.rstrip("\n").split("\t")
        sample_ids = []
        sample_ids = fields[9:]
        continue

    # Skip metadata lines
    if line.startswith('#'):
        continue
    
    fields = line.rstrip('\n').split('\t')
    chrom = fields[0]
    pos = fields[1]

    # Skip mitochondrial variants.
    if chrom == "chrM":
        continue

    # Extract Allele Frequency (AF) from the INFO field
    info_entries = fields[7].split(';')

    for entry in info_entries:
        if entry.startswith("AF="):
            af = entry.split("=")[1]
            af_row = []
            af_row.append(af)

            af_out.write("\t".join(af_row) + "\n")

    # write the genotype of every sample at every variant
    for i in range(len(sample_ids)):
        sample_id = sample_ids[i]
        sample_data = fields[i + 9]
        genotype = sample_data.split(":")[0]

        if genotype == "0" or genotype == "1":
            row = []
            row.append(sample_id)
            row.append(chrom)
            row.append(pos)
            row.append(genotype)

            gt_out.write("\t".join(row) + "\n")

af_out.close()
gt_out.close()