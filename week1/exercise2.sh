#!/bin/bash

# do the same as exercise 1 on hg16 genome assembly
grep -v _ hg16.chrom.sizes > hg16-main.chrom.sizes

bedtools makewindows -g hg16-main.chrom.sizes -w 1000000 > hg16-1mb.bed

cut -f1-3,5 hg16-kc.tsv > hg16-kc.bed

bedtools intersect -a hg16-1mb.bed -b hg16-kc.bed -c > hg16-kc-count.bed