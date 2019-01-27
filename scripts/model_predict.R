#calculate probabilities of n-grams conditioned on n - 1 grams
condProbabilities <- function(prob_list, unk_prob) {
      purrr::map_dfr(2:length(prob_list),
           ~ tibble(ngram_level = .,
                  cond_probs = list(mutate(prob_list[[.]], 
                  conditioned_on = sub("_[^_]*$", "", feature),
                  condprob = frequency / subProbabilities(
                        feature, prob_list[[.-1]], unk_prob[. - 1]))
           )))
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


setMethod(f="predict",
          signature="langmodel",
          definition=function(object, sentence="") {
                
                prob_list <- object@prob_list
                unk_prob <- objet@unk_prob
                predictNgram <- object@ngramPredicter
                
                # tokenise input sentence if nencessary
                if (class(sentence)!=tokens) sentence <- cleanTokens(sentence)
                
                # cut input sentence to (n-1)gram
                max_n <- min(object@max_n, length(sentence)+1)
                ngram <- tail(sentence, max_n-1)

                
                # IMPROVEMENTS POSSIBLE HERE
                # can be shifted to the model - or a subset calcd at the moment
                cond_probs <- condProbabilities(prob_list, unk_prob)
                
                # find all matching n-grams given (n-1)gram, for n 1 to max_n
                possible_ngrams <- purrr::map_dfr(max_n:1,
                      ~ filter(cond_probs, ngram_level=.)$cond_probs %>%
                        filter(conditioned_on==paste(tail(ngram, .), collapse = "_"))
                )
                
                # choose the best -depends on model
                predictNgram(ngram, possible_ngrams)
          }
)
