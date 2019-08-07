library(quanteda)
library(dplyr)

source("exploratory/fsample.R")
source("scripts/model/model_aux_functions.R")
source("scripts/cleanTokens.R")
source("scripts/model/model.R")
source("scripts/model/model_predict.R")
source("scripts/stupid_backoff/stupid_backoff.R")

encorp <- c(
      blogs = "data/final/en_US/en_US.blogs.txt",
      news = "data/final/en_US/en_US.news.txt",
      twitter = "data/final/en_US/en_US.twitter.txt"
)
blogs <- fsample(encorp[1], n = 10000L, seed = 3000)
news <- fsample(encorp[2], n = 10000L, seed = 3000)
twitter <- fsample(encorp[3], n = 10000L, seed = 3000)
merged_corpus <- corpus(c(blogs, news, twitter))
rm(blogs, news, twitter, encorp)

freq_list <- purrr::map(generateDfms(merged_corpus, ngrams=1:4), 
                        function(x) {textstat_frequency(x) %>%
                                    select(-docfreq, -group) %>%
                                    rename(count = frequency) %>%
                                    mutate(frequency = count / sum(count))}
)
rm(merged_corpus)

prob_list <- purrr::map(freq_list[1:4], ~head(.,10000))
max_n = length(prob_list)
unk_prob = purrr::map_dbl(prob_list, ~min(.$frequency))
cond_probs <- condProbabilities(prob_list, unk_prob)

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

save(model1, file = "dirty_scripts/testmodel.Rdata")
