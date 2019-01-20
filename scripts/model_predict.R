#calculate probabilities of n-grams conditioned on n-1 grams
condProbabilities <- function(prob_list, unk_prob) {
      purrr::map(
            2:length(prob_list),
            ~ mutate(
                  prob_list[[.]],
                  condprob = frequency/subProbabilities(feature, prob_list[[.-1]], unk_prob[.-1])
            )
      )
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
                # tokenise input sentence if nencessary
                if (class(sentence)!=tokens) sentence <- cleanTokens(sentence)
                
                # cut input sentence to (n-1)gram
                max_n <- object@max_n
                ngram <- tail(sentence, max_n-1)
                # find highest probability n-gram given (n-1)gram
                prob_list <- object@prob_list
                unk_prob <- objet@unk_prob
                cond_probs <- condProbabilities(prob_list, unk_prob)

          }
)
