# prepare frequency tables
generateDfms <- function(corpus, ngrams = 1:6) {
      toks <- cleanTokens(corpus) 
      dfm_list <- purrr::map(ngrams, ~dfm(toks, ngrams = .))
      # %>% dfm_weight("prop")
      # %>% dfm_smooth()
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

#calculate probabilities of n-grams conditioned on n - 1 grams
condProbabilities <- function(prob_list, unk_prob) {
      # 1 gram is conditioned on nothing
      cond_probs1 <- tibble(ngram_level=1,
                            cond_probs=list(mutate(prob_list[[1]],
                                                   conditioned_on="1",
                                                   condprob=frequency))
                            )
      # 2 to n grams
      cond_probs <- purrr::map_dfr(2:length(prob_list),
                     ~ tibble(ngram_level = .,
                              cond_probs = list(mutate(prob_list[[.]], 
                                                       conditioned_on = sub("_[^_]*$", "", feature),
                                                       condprob = frequency / subProbabilities(
                                                             feature, prob_list[[.-1]], unk_prob[. - 1]))
                              )))
      
      rbind(cond_probs1, cond_probs)
}

# find probabilities of n-1 grams (vectorised)
subProbabilities <- function(ngram, subfreq, unk_prob) {
      # cuts last token out of ngrams
      subgram <- sub("_[^_]*$", "", ngram)
      # finds probabiltiy of subgram; if not found (NULL result), uses unk_prob instead
      purrr::map_dbl(subgram,
                     ~max(filter(subfreq, feature == .)$frequency,
                          unk_prob))
}
