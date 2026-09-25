**Question 1.1:** Use ls `-lh` to compare the sizes of `A01_09.fq.gz`, `A01_09.sam`, and `A01_09.bam`. Why is the SAM file so much larger than the FASTQ file it came from? Why is the BAM file so much smaller than the SAM file?

- **Answer 1.1:** The SAM file is much larger than the FASTQ file because it is an uncompressed text file that stores not only the read sequences and quality scores, but also alignment information for every read, including genomic coordinates, FLAG values, CIGAR strings, mapping quality scores, mate information, and optional tags. The BAM file is much smaller than the SAM file because BAM is the compressed binary version of the same alignment data.

**Question 1.2**: `${my_sample}` appears four times in the `bwa mem` command. Write out that command exactly as bash would run it on the third trip through the loop, with every variable replaced by its value.

`bwa mem -t 4 -R "@RG\tID:A01_23\tSM:A01_23" ../genomes/sacCer3.fa ../BYxRM/fastq/A01_23.fq.gz > A01_23.sam`