#!/bin/bash

# Step 1.1 Prepare the reference genome
cd genomes
cp ~/Data/References/sacCer3/sacCer3.fa.gz .
gunzip sacCer3.fa.gz
bwa index sacCer3.fa

# Step 1.2: Map one sample
cd ../variants
bwa mem -t 4 -R "@RG\tID:A01_09\tSM:A01_09" ../genomes/sacCer3.fa ../BYxRM/fastq/A01_09.fq.gz > A01_09.sam

# Step 1.3: Sort, convert, and index
samtools sort -@ 4 -O bam -o A01_09.bam A01_09.sam
samtools index A01_09.bam

# Step 1.4: A short detour on variables and loops
my_sample=A01_09
echo ${my_sample}
my_sample=A01_09
samtools index ${my_sample}.bam
for my_sample in A01_09 A01_11 A01_23
do
    echo "Now processing" ${my_sample}
done

#Step 1.5: Build a workflow for all 10 samples

# the 10 segregants we will analyze
for my_sample in A01_09 A01_11 A01_23 A01_24 A01_27 A01_31 A01_35 A01_39 A01_62 A01_63
do
    echo "***" ${my_sample}

    # align reads to the reference genome
    bwa mem -t 4 -R "@RG\tID:${my_sample}\tSM:${my_sample}" ../genomes/sacCer3.fa ../BYxRM/fastq/${my_sample}.fq.gz > ${my_sample}.sam

    # sort the alignments by position and convert to BAM
    samtools sort -@ 4 -O bam -o ${my_sample}.bam ${my_sample}.sam

    # index the BAM file
    samtools index ${my_sample}.bam
done
