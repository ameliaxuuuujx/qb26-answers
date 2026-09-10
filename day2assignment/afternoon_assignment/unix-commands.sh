#!/bin/bash


### Question 1
wc -l ce11_genes.bed 
#    53935 ce11_genes.bed

cut -f 1 ce11_genes.bed | uniq -c
# 5460 chrI
#   12 chrM
# 9057 chrV
# 6840 chrX
# 6299 chrII
# 21418 chrIV
# 4849 chrIII

cut -f 6 ce11_genes.bed | sort | uniq -c
# 26626 -
# 27309 +


### Question 3
cut -f 7 GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | sort | uniq -c | sort -n | tail -n 3
#  867 Lung
# 1132 Muscle - Skeletal
# 3288 Whole Blood

grep -w "RNA" GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | wc -l
#    20016

grep -vw "RNA" GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | wc -l
    # 2936

