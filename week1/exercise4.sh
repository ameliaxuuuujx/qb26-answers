#!/bin/bash
# Count the number of Common SNPs overlapping each canonical transcript.
# Column 5 in the output is the SNP count for each transcript.
bedtools intersect -c -a hg19-kc.bed -b snps-chr1.bed > transcript-snp-counts.bed

# Display the canonical transcript with the largest number of overlapping SNPs.
sort -nr -k5,5 transcript-snp-counts.bed | head -n 1
# Result from Bash: chr1	245912648	246670581	ENST00000490107.6_7	5445
# The canonical transcript with the largest number of Common SNPs is
# ENST00000490107.6_7 (SMYD3). It contains 5445 SNPs.
# Position: hg19 chr1:245,912,648-246,670,581
# Size: 757,933 bp
# Exon count: 7
# This transcript may have the largest number of SNPs because it spans a large genomic region. Longer genes contain more nucleotide positions and therefore have more opportunities to contain SNPs.

# Randomly sample 20 SNPs using a fixed seed for reproducibility.
bedtools sample -i snps-chr1.bed -n 20 -seed 42 > snps-20.bed

# Sort the sampled SNP intervals before running bedtools closest.
bedtools sort -i snps-20.bed > snps-20-sorted.bed

# Sort the canonical transcript intervals before running bedtools closest.
bedtools sort -i hg19-kc.bed > hg19-kc-sorted.bed

# Find the nearest canonical transcript for every sampled SNP.
# -d reports the distance and -t first selects the first transcript in a tie.
bedtools closest -a snps-20-sorted.bed -b hg19-kc-sorted.bed -d -t first > snps-closest.bed

# How many SNPs are inside the gene?
grep -c $'\t0$' snps-closest.bed
# 15

# What is the range of distances for the ones outside a gene?
# Maximum Distance
awk '$NF > 0 {print $NF}' snps-closest.bed | sort -n | tail -n 1
# Minimum Distance
awk '$NF > 0 {print $NF}' snps-closest.bed | sort -n | head -n 1
# 1664 to 22944
