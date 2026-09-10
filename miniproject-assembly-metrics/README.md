# Mini Project: Genome Assembly Metrics

### Instructions:

This assignment downloads and analyzes four *Caenorhabditis remanei* genome FASTA assemblies. The bash script [getGenome.sh](./getGenome.sh) is used for data downloading, and the python [assembly-metrics](./assembly-metrics.py) parses FASTA files to compute basic assembly metrics. Results are compared to examine how sequencing technology influences genome assembly quality.

### Compare four C. remanei assemblies.

- BioProject PRJNA248909 (2014): https://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS19/species/caenorhabditis_remanei/PRJNA248909/caenorhabditis_remanei.PRJNA248909.WBPS19.genomic.fa.gz

    - Uncompressed file size: 120564187B
    - Number of contigs:  1591
    - Total length: 118549266
    - Average length: 74512.42363293526

- BioProject PRJNA248911 (2015): https://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS19/species/caenorhabditis_remanei/PRJNA248911/caenorhabditis_remanei.PRJNA248911.WBPS19.genomic.fa.gz

    - Uncompressed file size: 126639400B
    - Number of contigs:  912
    - Total length: 124541912
    - Average length: 136559.11403508772

- BioProject PRJNA53967 (No record): https://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS19/species/caenorhabditis_remanei/PRJNA53967/caenorhabditis_remanei.PRJNA53967.WBPS19.genomic.fa.gz

    - Uncompressed file size: 147929855B
    - Number of contigs:  3670
    - Total length: 145442736
    - Average length: 39630.17329700272


- BioProject PRJNA577507 (2019): https://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS19/species/caenorhabditis_remanei/PRJNA577507/caenorhabditis_remanei.PRJNA577507.WBPS19.genomic.fa.gz

    - Uncompressed file size: 132662265B
    - Number of contigs:  187
    - Total length: 130480874
    - Average length: 697758.6844919786

### Summary of results

The results show a clear improvement in assembly contiguity over time. The 2014 assembly has 1,591 contigs with an average contig length of 74.5 kb, while the 2015 assembly has fewer contigs (912) and a larger average contig length (136.6 kb). The 2019 assembly is the most contiguous, with only 187 contigs and an average contig length of 697.8 kb. This trend is consistent with advances in sequencing and genome-assembly methods, such as longer sequencing reads and improved software. However, these metrics alone cannot prove that sequencing technology was the only cause, since coverage, sample quality, and assembly parameters may also affect assembly quality.
