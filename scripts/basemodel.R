load("data/smallsample.Rdata")
library(quanteda)
library(dplyr)
merged_corpus <- corpus(c(blogs, news, twitter))

# prepare frequency tables
generateDfms <- function(corpus, ngrams = 1:6) {
      dfm_list <- purrr::map(ngrams, ~dfm(
            corpus,
            ngrams = .x,
            tolower = TRUE,
            remove_numbers = TRUE,
            remove_punct = TRUE,
            remove_symbols = TRUE,
            remove_separators = TRUE,
            remove_twitter = FALSE,
            remove_hyphens = TRUE,
            remove_url = TRUE
            #remove = "stopwords"
      ) 
      # %>% dfm_weight("prop")
      # %>% dfm_smooth()
      )
}

# match (n+1)grams that start with pattern
matchTopnGrams <- function (freq_table, ngram, n, maxpredictions=5) {
      # cut ngram to n-1 length
      if (n==1) return(mutate(freq_list[[1]], pred_word=feature, n=n)[1:5,])
      
      ngram <- paste(tail(unlist(strsplit(ngram, "_")),(n-1)), collapse = "_")
      
      matches <- freq_list[[n]][grep(paste0("^", ngram, "_"), freq_list[[n]]$feature), ] %>%
            mutate(pred_word=sub(".*_", "", feature), n=n)
      
      if (nrow(matches)==0) return(data.frame())
      
      return(matches[1:min(c(maxpredictions, nrow(matches))),])
}



# base prediction algorithm
setClass(
      "langmodel",
      representation(
            freq_list = "list",
            max_n = "numeric",
            unk_prob = "numeric"
      )
)

#test model
freq_list <- purrr::map(generateDfms(merged_corpus), 
                        function(x) {textstat_frequency(x) %>%
                        rename(count = frequency) %>%
                        mutate(frequency = count / sum(count))}
                        )

model1 <-
      new(
            "langmodel",
            freq_list = flist2,
            max_n = length(freq_list),
            unk_prob = purrr::map_dbl(freq_list, ~min(.$frequency))
      )

predict(model1, ngram_in)
