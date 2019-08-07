source("model_aux_functions.R")

setMethod(f="predict",
      signature="langmodel",
      definition=function(object, sentence="") {
                
            predictProbability <- object@predictProbability
            cond_probs <- object@cond_probs
                
            # tokenise input sentence if nencessary
            if (class(sentence)!="tokens") sentence <- cleanTokens(sentence)
            sentence <- unlist(sentence)
          
            # cut input sentence to (n-1)gram
            max_n <- min(object@max_n, length(sentence)+1)
            n_1gram <- tail(sentence, max_n-1)
          
            # find all matching n-grams given (n-1)gram, for n=1 to max_n
            possibleNgrams <- function(i) {
                  require(dplyr)
                  if (i>1) cond_gram <- tail(n_1gram, i-1) else cond_gram <- "1"
                  filter(cond_probs, ngram_level==i)$cond_probs[[1]] %>%
                        filter(conditioned_on==paste(cond_gram, collapse = "_"))
            }
            possible_ngrams <- purrr::map_dfr(max_n:1, possibleNgrams)
          
            # choose the best -depends on model
            best_ngrams <- predictProbability(possible_ngrams)
            return(unique(best_ngrams$predicted_word)[1:10])
      }
)
