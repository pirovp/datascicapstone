load("data/smallsample.Rdata")
library(quanteda)
library(dplyr)
merged_corpus <- corpus(c(blogs, news, twitter))
source("scripts/model_aux_functions.R")
source("scripts/preproc.R")

#test model
freq_list <- purrr::map(generateDfms(merged_corpus), 
                        function(x) {textstat_frequency(x) %>%
                                    rename(count = frequency) %>%
                                    mutate(frequency = count / sum(count))}
)
prob_list <- purrr::map(freq_list[1:3], ~head(.,1000))
rm(blogs, news, twitter, merged_corpus, freq_list)

model1 <-
      new(
            "langmodel",
            prob_list = prob_list,
            max_n = length(prob_list),
            unk_prob = purrr::map_dbl(prob_list, ~min(.$frequency)),
            ngramProbability = stupidBackoffProb
      )
model1@cond_probs <- condProbabilities(model1@prob_list, model1@unk_prob)

predict(model1, ngram_in)