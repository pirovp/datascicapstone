# Stupid predict - only works with frequencies and no parametrised model, but much faster
# predicts next word given input sentence
setMethod(f="predict",
          signature="langmodel",
          definition=function(object, ngram = "")
          {
                predictions <- data.frame()
                max_predictions <- 5
                freq_table <- object@freq_list
                # determine length of n-gram
                n <- length(unlist(strsplit(ngram, "_")))
                # look for it in n+1-gram table
                predictions <- purrr::map_dfr((n+1):1, 
                                              ~matchTopnGrams(freq_table, ngram, .x)
                )
                # if found, return highest probability future words
                # else, back off to n-1-gram
                return(predictions)
          }
)

stupidBackoff <- function(ngram, prob_list, max_n=3, unk_prob=0) {
      n <- min(max_n, length(ngram))
      
      # match and return n-gram probability and n-1 gram to condition on
      for (i in n:1) {
            ngram <- tail(ngram, i)
            match <- filter(prob_list[[i]], feature==paste(ngram, collapse="_"))
            if (nrow(match)>0) {
                  #no n-1 gram if i==1
                  if (i==1) {
                        match[2,]$feature <- "1"
                        match[2,]$frequency <- 1
                        break
                  }
                  #n-1 gram
                  subgram <- head(ngram, (i-1))
                  match[2,] <- filter(prob_list[[i-1]],
                                      feature==paste(subgram, collapse="_"))
                  break
            }
      }
      
      # if no match, returning 0 probability will give 0 perplexity
      # unk_freq needs to be defined by the model
      
      if (nrow(match)>0) return(match)
      else return(tibble(feature=c("<UNK>", "1"), frequency=c(unk_prob[1], 1)))
}