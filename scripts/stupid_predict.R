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