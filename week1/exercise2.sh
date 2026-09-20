#!/bin/bash

### do the same as exercise 1 on hg16 genome assembly
grep -v _ hg16.chrom.sizes > hg16-main.chrom.sizes

bedtools makewindows -g hg16-main.chrom.sizes -w 1000000 > hg16-1mb.bed

cut -f1-3,5 hg16-kc.tsv > hg16-kc.bed

bedtools intersect -a hg16-1mb.bed -b hg16-kc.bed -c > hg16-kc-count.bed

### Calculate how many genes are unique to each assembly
grep -v '^#' hg19-kc.bed | wc -l
grep -v '^#' hg16-kc.bed | wc -l
# There are 80308 genes in hg19, 21364 in hg16.


### How many genes are in hg19 but not in hg16?
bedtools intersect -v -a hg19-kc.bed -b hg16-kc.bed | wc -l
# 42737

### How many genes are in hg16 but not in hg19?
bedtools intersect -v -b hg19-kc.bed -a hg16-kc.bed | wc -l
# 3458

### Why are some records present in one assembly but not the other?
# hg16 and hg19 were created at different times using different versions of the human reference genome and gene annotations.
# Therefore, some genes or transcripts may have been newly dicovered or re-annotated in hg19, while they were not included in the older hg16 assembly.
# Additionaly, genomic coordinates are not identical between the two assenblies.
# The same gene may have different coordinates in hg16 and hg19.
# Because we compares coordinates directly withour using liftOver, some indentical genes may be incorrectly identified as unique to one assembly.