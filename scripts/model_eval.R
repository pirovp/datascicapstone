# determine perplexity of a language model 
# inputs: a corpus of text (corpus object), and a model (langmodel object)
# output: perplexity (double)
corpusPerplexity <- function(corpus, lmodel) {
      # split corpus into sentences
      corpus <- unlist(cleanTokens(corpus, what="sentence"))
      # non normalised perplexity each sentence
      perplexities <- purrr::map_dfr(corpus, ~perplexity(lmodel, .))
      # normalise by taking nth root (n = total number of words)
      perplexity <- c(mean=mean(perplexities$perplexity),
                      sd=sd(perplexities$perplexity))
      # remove 
      return(list(perplexities, perplexity))
}

# evaluates probability of token inside sentence
setGeneric("perplexity", function(object, ...) {
      standardGeneric("perplexity")
})

setMethod(f="perplexity",
          signature="langmodel",
          definition=function(object, sentence="") {
                tokens <- cleanTokens(sentence)
                
                n <- length(tokens[[1]])
                if (n==0) return(NULL)
                
                token_probabilities = purrr::map_dbl(1:n, 
                                                     ~tokenProbability(object,
                                                                       tokens,
                                                                       position=.)
                                                     )
                perplexity=1/prod(token_probabilities^(1/n))
                return(tibble(perplexity=perplexity, n=n))
          }
)

# determine probability of a given token in a sentence according to a lang model
# inputs: a sentence (pre-tokenized or string) and a model (langmodel object)
# output: stringprob (double, 0<x<1)
setGeneric("tokenProbability", function(object, ...) {
      standardGeneric("tokenProbability")
})

setMethod(f="tokenProbability",
          signature="langmodel",
          definition=function(object, sentence="", position=1L) {
                
                cond_probs <- object@cond_probs
                ngramProbability <- object@ngramProbability
                
                # tokenise input sentence if nencessary
                if (class(sentence)!="tokens") sentence <- cleanTokens(sentence)
                sentence <- unlist(sentence)
                
                max_n <- object@max_n
                ngram_start <- max(1, position-max_n+1)
                ngram <- sentence[ngram_start:position]
                
                # probability of ngram
                match_ngrams <- purrr::map_dfr(length(ngram):1, function(i) {
                                filter(cond_probs, ngram_level==i)$cond_probs[[1]] %>%
                                filter(feature==paste(tail(ngram, i), collapse = "_"))
                                }
                )
                probability <- ngramProbability(ngram, match_ngrams)
                if (is.na(probability)) return(object@unk_prob[1]) 
                else return(probability)
          }
)
