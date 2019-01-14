# determine perplexity of a language model 
# inputs: a corpus of text (corpus object), and a model (langmodel object)
# output: perplexity (double)
corpusPerplexity <- function(corpus, lmodel) {
      # split corpus into sentences
      corpus <- unlist(tokens(corpus, what="sentence"))
      # non normalised perplexity each sentence
      perplexities <- purrr::map_dfr(corpus, ~perplexity(lmodel, .))
      # normalise by taking nth root (n = total number of words)
      perplexity <- prod(perplexities$perplexity)^(1/sum(perplexities$n))
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
                token_probabilities = purrr::map_dbl(1:n, 
                                                     ~tokenProbability(object,
                                                                       tokens,
                                                                       position=~.x)
                                                     )
                perplexity=prod(token_probabilities)
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
                # tokenise input sentence if nencessary
                if (class(sentence)!=tokens) sentence <- cleanTokens(sentence)
                # dummy probability
                probability = 1/2
                return(probability)
          }
)
