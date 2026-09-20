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
bedtools intersect -f 1 -a nhek-active.bed -b nhlf-active.bed | wc -l
# 4821

### 5. Require 100% of each NHLF region to overlap an NHEK active region.
bedtools intersect -F 1 -a nhek-active.bed -b nhlf-active.bed | wc -l
# 6731

### 6. Require complete reciprocal overlap between NHEK and NHLF regions.
bedtools intersect -f 1 -F 1 -a nhek-active.bed -b nhlf-active.bed | wc -l
# 1409

# -f 1 requires the entire NHEK region (file A) to be overlapped.
# -F 1 requires the entire NHLF region (file B) to be overlapped.
# -f 1 -F 1 requires complete reciprocal overlap, so the regions must have identical boundaries.

### 7. Find regions active in both NHEK and NHLF.
bedtools intersect -u -a nhek-active.bed -b nhlf-active.bed | wc -l
# 11608

### 8. Find NHEK active regions that overlap NHLF repressed regions.
bedtools intersect -u -a nhek-active.bed -b nhlf-repressed.bed | wc -l
# 320

### 9. Find NHEK repressed regions that overlap NHLF repressed regions.
bedtools intersect -u -a nhek-repressed.bed -b nhlf-repressed.bed | wc -l
# 17685