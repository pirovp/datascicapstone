load("data/smallsample.Rdata")
library(quanteda)
library(dplyr)
merged_corpus <- corpus(c(blogs, news, twitter))
# source("scripts/download.R")
# source("scripts/read.R")
source("scripts/model_aux_functions.R")
source("scripts/preproc.R")
source("scripts/model_class.R")
source("scripts/M_stupid_backoff.R")

#test model
freq_list <- purrr::map(generateDfms(merged_corpus), 
                        function(x) {textstat_frequency(x) %>%
                                    rename(count = frequency) %>%
                                    mutate(frequency = count / sum(count))}
)
prob_list <- purrr::map(freq_list[1:3], ~head(.,1000))
rm(blogs, news, twitter, merged_corpus, freq_list)

max_n = length(prob_list)
unk_prob = purrr::map_dbl(prob_list, ~min(.$frequency))
cond_probs <- condProbabilities(prob_list, unk_prob)

ngram_in = "This is a nice"

model1 <-
      new(
            "langmodel",
            prob_list = prob_list,
            max_n = max_n,
            unk_prob = unk_prob,
            cond_probs = cond_probs,
            evalProbability = stupidBackoff_eval,
            predictProbability = stupidBackoff_predict
      )


predict(model1, ngram_in)