interpolatedProbability <- function(ngram, matches, lambdas, unk_prob) {
      n <- length(lambdas)
      purrr::map_dbl(1:n,
                     function(i) {
                           prob = matches %>%
                                 filter(feature == paste(tail(ngram, i), collapse = "_")) %>%
                                 .$condprob
                           if (length(prob) == 0)
                                 prob <- unk_prob[i]
                           return(prob)
                     }) * lambdas
}

stupidBackoff_eval <- function(ngram, matches, lambdas, unk_prob) {
      return(interpolatedProbability(ngram, matches, lambdas, unk_prob))
}

stupidBackoff_predict <- function(matches, lambdas, unk_prob) {
      possible_ngrams <- mutate(possible_ngrams, ngram=(strsplit(feature, "_")))
      candidates <- filter(possible_ngrams,)
      purrr:map_dbl(
            matches$feature,
            function(x) {
                  ngram = 
                  interpolatedProbability(ngram, matches, lambda, unk_prob)
            }
      )
}