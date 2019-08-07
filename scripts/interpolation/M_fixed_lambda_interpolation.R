interpolatedProbability <- function(ngram, matches, lambdas, unk_prob) {
      n <- length(lambdas)
      map_dbl(1:n,
              function(i) {
                  prob = matches %>%
                        filter(feature == paste(tail(ngram, i), collapse = "_")) %>%
                        .$condprob
                  if (length(prob) == 0)
                        prob <- unk_prob[i]
              return(prob)
      }) %*% lambdas %>% as.numeric()
}

interpolated_eval <- function(ngram, matches, lambdas, unk_prob) {
      return(interpolatedProbability(ngram, matches, lambdas, unk_prob))
}

interpolated_predict <- function(ngram_in, matches, lambdas, unk_prob) {
      
      matches <- mutate(matches, 
                        n_1gram = stringr::word(feature, sep = "_", end = -2),
                        ngram_out = stringr::word(feature, sep = "_", start = -1)
      )
      
      candidates <- filter(matches, n_1gram == ngram_in) %>%
            mutate(prob = interpolatedProbability(strsplit(feature, "_")[[1]],
                                                            matches,
                                                            lambdas,
                                                            unk_prob)
                  ) %>%
            arrange(prob)
      
      return(candidates)
}
