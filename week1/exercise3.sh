#!/bin/bash

### 1. Is there any overlap between 1_Active and 12_Repression in a given condition
bedtools intersect -a nhek-active.bed -b nhek-repressed.bed | wc -l
# 0

### 2. Find regions that are active in both NHEK and NHLF (corrected)
bedtools intersect -u -a nhek-active.bed -b nhlf-active.bed | wc -l
# 11608

### 3. Find regions that are active in NHEK, but not active in NHLF
bedtools intersect -v -a nhek-active.bed -b nhlf-active.bed | wc -l
# 2405

# Commands 2 and 3 do not necessarily add up to the number of NHEK active regions because one NHEK region can overlap multiple NHLF regions.
# The -u option reports each NHEK region only once and prevents duplicates.

### 4. Require 100% of each NHEK region to overlap an NHLF active region.
bedtools intersect -f 1 -a nhek-active.bed -b nhlf-active.bed | head -n 1
# chr1	25558413	25559413	1_Active_Promoter	0	.	25558413	25559413

### 5. Require 100% of each NHLF region to overlap an NHEK active region.
bedtools intersect -F 1 -a nhek-active.bed -b nhlf-active.bed | head -n 1
# chr1	19923013	19924213	1_Active_Promoter	0	.	19922613	19924613


### 6. Require complete reciprocal overlap between NHEK and NHLF regions.
bedtools intersect -f 1 -F 1 -a nhek-active.bed -b nhlf-active.bed | head -n 1
# chr1	1051137	1051537	1_Active_Promoter	0	.	1051137	1051537

# As the overlap requirement becomes more stringent, the selected regions show
# increasingly similar boundaries between NHEK and NHLF. With -f 1, the entire
# NHEK active region is covered by an NHLF active region, but the NHLF region
# may extend beyond the boundaries of the NHEK region. In the UCSC view, both
# cell lines show an active promoter state at the selected locus, while the
# NHLF active promoter segment is broader than the NHEK segment.
#
# With -F 1, the entire NHLF active region is covered by an NHEK active region,
# but the NHEK region may extend beyond the NHLF region. Thus, -f 1 and -F 1
# both identify complete containment, but they differ in which cell line has
# the larger active interval.
#
# With -f 1 -F 1, both regions must completely overlap each other. The selected
# NHEK and NHLF regions have the same boundaries and are both labeled
# 1_Active_Promoter. Therefore, reciprocal overlap identifies the most
# stringent and most concordant chromatin-state relationship between the two
# cell lines.


### 7. Find regions active in both NHEK and NHLF.
bedtools intersect -u -a nhek-active.bed -b nhlf-active.bed | head -n 1
# chr1	19922613	19924613	1_Active_Promoter	0	.	19922613	19924613
# Active in NHEK and active in NHLF: At this locus, both NHLF and NHEK show
# the 1_Active_Promoter state across the shared region. HSMM, HepG2, H1-hESC,
# and GM12878 also show an active promoter state across much of the central
# region. K562, HUVEC, and HMEC contain adjacent 1_Active_Promoter and
# 4_Strong_Enhancer segments at this locus, indicating promoter-active and
# enhancer-active subregions within the same broader genomic region. The
# active promoter segments are often flanked by strong or weak enhancer, or
# weak promoter. Therefore, this region is broadly promoter-active across the
# nine cell lines, although the exact boundaries and flanking states differ.


### 8. Find NHEK active regions that overlap NHLF repressed regions.
bedtools intersect -u -a nhek-active.bed -b nhlf-repressed.bed | head -n 1
# chr1	1981140	1981540	1_Active_Promoter	0	.	1981140	1981540
# Active in NHEK and repressed in NHLF: NHLF labels the selected region as
# 12_Repressed, whereas NHEK labels it as 1_Active_Promoter. This difference
# shows cell-type-specific chromatin regulation. K562 displays an insulator
# state near this region, while HUVEC and HSMM also show repressed states.
# In contrast, HMEC, H1-hESC, and GM12878 show active promoter states, and
# HepG2 shows a strong enhancer state. Thus, the same genomic region is
# inactive in some cell lines but promoter- or enhancer-active in others.


### 9. Find NHEK repressed regions that overlap NHLF repressed regions.
bedtools intersect -u -a nhek-repressed.bed -b nhlf-repressed.bed | head -n 1
# chr1	11534013	11538613	12_Repressed	0	.	11534013	11538613
# Repressed in NHEK and repressed in NHLF: The central overlapping interval is
# labeled 12_Repressed in both NHEK and NHLF. Also, there is a repressed state
# in HSMM, HMEC, and H1-hESC at the central loci. Moving away from this shared
# interval, the chromatin state changes differently among the other cell
# lines. The flanking regions include 13_Heterochromatin/low-signal,
# 8_Insulator, 2_Weak_Promoter, 3_Poised_Promoter, 6_Weak_Enhancer, and
# 1_Active_Promoter states. Therefore, NHEK and NHLF agree that the core
# overlap is repressed, whereas the surrounding chromatin state is
# cell-type-specific.
