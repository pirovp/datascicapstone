library(ggplot2)
library(quanteda)
library(dplyr)

# load
load("data/smallsample.Rdata")
merged_corpus <- corpus(c(blogs, news, twitter))

# number of >10 count n-grams
ngramFreqPlot <- function(corpus) {
      purrr::map_dfr(
            1:6,
            ~ textstat_frequency(dfm(
                  corpus,
                  ngrams = .x,
                  remove_punct = TRUE,
                  remove_numbers = TRUE, 
                  remove_symbols = TRUE,
                  remove_separators = TRUE,
                  remove_twitter = FALSE,
                  remove_hyphens = TRUE,
                  remove_url = TRUE
            )) %>%
                  mutate(ngram = as.numeric(.x)) %>%
                  rename(count = frequency) %>%
                  mutate(frequency = count / sum(count))
      ) %>%
            # cumulative frequencies
            group_by(ngram) %>%
            mutate(per_rank = rank(rank) / length(rank),
                   cum_freq = cumsum(frequency))
}

frequencies_16 <- ngramFreqPlot(merged_corpus)
subcorpus <- corpus_sample(merged_corpus, size = 3000)
frequencies_16_sub <- ngramFreqPlot(subcorpus)
frequencies_16_tot <- rbind(
      mutate(frequencies_16, sample = 30000),
      mutate(frequencies_16_sub, sample = 3000)
) %>% mutate(sample=as.factor(sample))

min_count_ngrams <- purrr::map_dfr(c(2:20),
                                   ~ filter(frequencies_16_tot, count >= .x) %>%
                                     #mutate(ngram = paste0(as.character(ngram), "-grams")) %>%
                                     group_by(ngram, sample) %>%
                                     summarise(min_n = .x, 'n'=n())
)

ngram_labeller <- function(n) {paste0(as.character(n), "-grams")}      
ggplot(min_count_ngrams, aes(x=min_n, y=n, colour = sample)) +
      geom_point() +
      facet_wrap(vars(ngram), scales = "free_y", labeller = labeller(ngram = ngram_labeller)) +
      labs(x = "minimum count", title = "Numbers of high-count (>1) n-grams in the sample")
      

# 1. examine distribution of n-grams
# histogram
ggplot(frequencies_16, aes(count))  +
      geom_histogram(bins= 20) +
      scale_y_log10() +
      facet_wrap(vars(ngram), scales = "free", labeller = labeller(ngram = ngram_labeller)) +
      labs(title="Distributions of n-gram counts")


#cum freq
# filter(count > 1)
ggplot(filter(frequencies_16, count>1)) +
      geom_line(aes(x=per_rank, y=cum_freq)) +
      facet_wrap(vars(ngram), scales= "free", labeller = labeller(ngram = ngram_labeller)) +
      labs(title="Cumulative frequencies of top n-grams in the sample")
# after 5% linear relationship --> they're all 1 count
# sanity check with 1000 lines read

ggplot(filter(frequencies_16_tot, count>1)) +
      geom_line(aes(x=per_rank, y=cum_freq, colour=as.factor(sample))) +
      facet_wrap(vars(ngram), scales= "free", labeller = labeller(ngram = ngram_labeller)) +
      labs(title="Cumulative frequencies of top n-grams in the sample of size 3000")

# ngram top dogs
frequencies_16 %>% ungroup() %>%
      filter(rank < 10) %>%
      mutate(feature = gsub("_", " ",feature)) %>%
      mutate(feature = factor(feature, levels = feature)) %>%
      ggplot(aes(feature, count))  +
      geom_point() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      facet_wrap(vars(ngram), scales = "free", labeller = labeller(ngram = ngram_labeller))