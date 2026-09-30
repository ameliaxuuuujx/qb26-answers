library(tidyverse)

# Read allele-frequency data.
af <- read_tsv("/Users/cmdb/qb26-answers/week2/AF.txt")

# Data visualization of AF.txt
paf <- af %>% 
  ggplot(aes(x = AF)) + 
  geom_histogram(bins = 11,
                 colour = "white",
                 fill = "seagreen") +
  labs(title = "Allele Frequency Spectrum",
       x = "Alternative allel frequency",
       y = "Number of variants") +
  theme_classic()

# Save as AF.png
ggsave("/Users/cmdb/qb26-answers/week2/AF.png", plot = paf, width = 7, height = 5)


# Read long format genotype data
gt <- read_tsv("/Users/cmdb/qb26-answers/week2/gt_long.txt")

# Keep chromosome order from the VCF and convert genotpye to a factor
chrom_order <- unique(gt$chrom)

gt <- gt %>% 
  mutate(chrom = factor(chrom, levels = chrom_order),
         genotype = factor(genotype,
                           levels = c("0","1"),
                           labels = c("BY/reference(0)", "RM/alternative(1)")))

# Creata a new df for chrII of sample A01_62.
a01_62_chrII <- gt %>% 
  filter(sample == "A01_62",
         chrom == "chrII") 

# Plot ancestry along chrII
pgl_chrII <- a01_62_chrII %>% 
  ggplot(aes(x = pos, y = genotype, colour = genotype)) +
  geom_point(size = 1) +
  labs(title = "Ancestry of A01_62 on chrII",
       x = "Position",
       y = "Genotype") +
  scale_color_manual(
    values = c(
      "BY/reference(0)" = "#2166AC",
      "RM/alternative(1)" = "#B2182B"
    )
  ) +
  theme_classic()

ggsave("/Users/cmdb/qb26-answers/week2/ancestry_A01_62_chrII.png", plot = pgl_chrII, width = 7, height = 5)

# Plot ancestry for all samples cross all chrs.
pgl_all <- gt %>% 
  ggplot(aes(x = pos,
             y = sample,
             colour = genotype)) +
  geom_point(size = 0.25,
             alpha = 0.8) +
  facet_grid(. ~ chrom,
             scales = "free_x",
             space = "free_x") +
  scale_color_manual(values = c("BY/reference(0)" = "#2166AC",
                                "RM/alternative(1)" = "#B2182B")) +
  theme_classic() +
  labs(title = "Genome-wide Ancestry of BY x RM segregants",
       x = "Genomic position",
       y = "Sample",
       color = "Ancestry") +
  scale_x_continuous(
    n.breaks = 3,
    labels = scales::label_number(
      scale = 1e-3,
      suffix = " kb"
    )
  ) +
  theme(axis.text.x = element_text(angle = 45,
                                   hjust = 1),
        strip.text.x = element_text(size = 8))
ggsave("/Users/cmdb/qb26-answers/week2/ancestry.png", plot = pgl_all, width = 22, height = 6)
