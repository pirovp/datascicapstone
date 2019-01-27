load("data/smallsample.Rdata")
library(quanteda)
library(dplyr)
merged_corpus <- corpus(c(blogs, news, twitter))

#test model
freq_list <- purrr::map(generateDfms(merged_corpus), 
                        function(x) {textstat_frequency(x) %>%
                                    rename(count = frequency) %>%
                                    mutate(frequency = count / sum(count))}
)

model1 <-
      new(
            "langmodel",
            prob_list = purrr::map(freq_list[1:3], ~head(.,1000)),
            max_n = length(freq_list),
            unk_prob = purrr::map_dbl(freq_list, ~min(.$frequency)),
            cond_probs <- condProbabilities(prob_list, unk_prob),
            ngramPredicter = stupidPredict
      )

predict(model1, ngram_in)