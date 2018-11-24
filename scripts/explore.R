library(ggplot2)
library(quanteda)
library(dplyr)

# load
load("data/smallsample.Rdata")

# number of >10 count n-grams
frequencies_16 <- purrr::map_dfr(1:6,
                                 ~ textstat_frequency(dfm(
                                       twitter,
                                       ngrams = .x,
                                       remove_punct = TRUE
                                 )) %>%
                                 mutate(ngram = as.numeric(.x))) %>%
                                 rename(count = frequency) %>%
                                 mutate(frequency = count / sum(count))

min_count_ngrams <- purrr::map_dfr(c(1,2,3,5,10,15,20),
                                   ~ filter(frequencies_16, count > .x) %>%
                                     #mutate(ngram = paste0(as.character(ngram), "-grams")) %>%
                                     group_by(ngram) %>%
                                     summarise(min_n = .x, 'n'=n())
)

ngram_labeller <- function(n) {paste0(as.character(n), "-grams")}      
ggplot(min_count_ngrams, aes(x=min_n, y=n)) +
      geom_point() +
      facet_wrap(vars(ngram), scales = "free_y", labeller = labeller(ngram = ngram_labeller)) +
      labs(x = "minimum count", title = "Numbers of high-count n-grams in the sample")
      

# 1. examine distribution of n-grams
# histogram
ggplot(frequencies_16, aes(count))  +
      geom_histogram(bins= 20) +
      scale_y_log10() +
      facet_wrap(vars(ngram), scales = "free", labeller = labeller(ngram = ngram_labeller)) +
      labs(title="Distributions of n-gram counts")

# cumulative frequencies
z <- arrange(frequencies_3, rank) %>%
      rename(count = frequency) %>%
      mutate(frequency = count/sum(count)) %>%  # maybe swap these two
      filter(count > 1)
ggplot(z) +
      geom_step(aes(x=percent_rank(rank),y=cumsum(frequency)))
# after 5% linear relationship --> they're all 1 count

# sanity check with 100000 lines read


# ngram top dogs
collocations_2 <- textstat_collocations(blogs, size = 2, min_count = 50)
collocations_2 <- arrange(collocations_2, desc(count))
collocations_2$collocation <- factor(collocations_2$collocation, 
                                     levels = collocations_2$collocation)
ggplot(collocations_2[1:15,], aes(collocation, count))  +
      geom_point() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
# repeat for 3,4,5
