setClass(
      "langmodel",
      representation(
            prob_list = "list",
            max_n = "numeric",
            unk_prob = "numeric",
            # IMPROVEMENTS POSSIBLE HERE
            # can be subset calcd at the moment
            cond_probs = "list",
            ngramPredicter = "function"
      )
)

setMethod(f="predict",
          signature="langmodel",
          definition=function(object, sentence="") {
                
                predictNgram <- object@ngramPredicter
                cond_probs <- object@cond_probs
                
                # tokenise input sentence if nencessary
                if (class(sentence)!=tokens) sentence <- cleanTokens(sentence)
                
                # cut input sentence to (n-1)gram
                max_n <- min(object@max_n, length(sentence)+1)
                ngram <- tail(sentence, max_n-1)

                # find all matching n-grams given (n-1)gram, for n 1 to max_n
                possible_ngrams <- purrr::map_dfr(max_n:1,
                      ~ filter(cond_probs, ngram_level=.)$cond_probs %>%
                        filter(conditioned_on==paste(tail(ngram, .), collapse = "_"))
                )
                
                # choose the best -depends on model
                predictNgram(ngram, possible_ngrams)
          }
)