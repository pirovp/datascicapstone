stupidBackoffProb <- function(ngram, matches) {
      n <- length(ngram)
      # this shouldn't be necessary if coming from eval method but oh well
      subgrams <- purrr::map_dfr(n:1,
                                 ~filter(matches,
                                         feature==paste(tail(ngram, .),
                                                        collapse = "_"))
                            )
      
      #this should give the stupid backoff result by itself
      return(subgrams$condprob[1])
}