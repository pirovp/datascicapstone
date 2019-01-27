setClass(
      "langmodel",
      representation(
            prob_list = "list",
            max_n = "numeric",
            unk_prob = "numeric",
            # IMPROVEMENTS POSSIBLE HERE
            # can be subset calcd at the moment
            cond_probs = "list",
            ngramProbability = "function"
      )
)

setMethod(f="predict",
          signature="langmodel",
          definition=function(object, sentence="") {
                
                ngramProbability <- object@ngramProbability
                cond_probs <- object@cond_probs
                
                # tokenise input sentence if nencessary
                if (class(sentence)!=tokens) sentence <- cleanTokens(sentence)
                
                # cut input sentence to (n-1)gram
                max_n <- min(object@max_n, length(sentence)+1)
                ngram <- tail(sentence, max_n-1)

                # find all matching n-grams given (n-1)gram, for n=1 to max_n
                possible_ngrams <- purrr::map_dfr(max_n:1, function(i) {
                        filter(cond_probs, ngram_level==i)$cond_probs[[1]] %>%
                        filter(conditioned_on==paste(max(tail(ngram, i-1),1), collapse = "_"))
                        }
                )
                
                # choose the best -depends on model
                best_ngrams <- mutate(possible_ngrams,
                                      probability=ngramProbability(ngram, possible_ngrams)) %>%
                               arrange(possible_ngrams, desc(probability))
          }
)