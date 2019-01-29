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
                if (class(sentence)!="tokens") sentence <- cleanTokens(sentence)
                sentence <- unlist(sentence)
                
                # cut input sentence to (n-1)gram
                max_n <- min(object@max_n, length(sentence)+1)
                n_1gram <- tail(sentence, max_n-1)

                # find all matching n-grams given (n-1)gram, for n=1 to max_n
                possible_ngrams <- purrr::map_dfr(max_n:1, function(i) {
                        if (i>1) cond_gram <- tail(n_1gram, i-1) else cond_gram <- "1"
                        filter(cond_probs, ngram_level==i)$cond_probs[[1]] %>%
                        filter(conditioned_on==paste(cond_gram, collapse = "_"))
                        }
                )
                
                # choose the best -depends on model
                vNgramProbability <- Vectorize(ngramProbability, "ngram")
                #stupid b-o should be treated specially
                best_ngrams <- mutate(possible_ngrams,
                                      probability=vNgramProbability(strsplit(feature, "_"),
                                                                   possible_ngrams)) %>%
                               arrange(desc(probability))
                return(best_ngrams[1:10,])
          }
)
