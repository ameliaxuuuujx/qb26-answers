library(tidyverse)

# read the crossovers.txt
df <- read_tsv("/Users/cmdb/qb26-answers/week2/crossovers.txt")

# Plot the histogram
pcross <- df %>% 
  ggplot(aes(x = crossovers)) +
  geom_histogram(colour = "black",
                 fill = "steelblue") +
  labs(title = "Crossovers per segregant",
       x = "Number of crossovers",
       y = "Number of samples") +
  theme_classic() 

df %>% 
  summarise(mean = mean(crossovers))

ggsave("/Users/cmdb/qb26-answers/week2/crossovers.png", plot = pcross, width = 7, height = 5)
