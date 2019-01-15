# determine perplexity of a language model 
# inputs: a corpus of text (corpus object), and a model (langmodel object)
# output: perplexity (double)
corpusPerplexity <- function(corpus, lmodel) {
      # split corpus into sentences
      corpus <- unlist(cleanTokens(corpus, what="sentence"))
      # non normalised perplexity each sentence
      perplexities <- purrr::map_dfr(corpus, ~perplexity(lmodel, .))
      # normalise by taking nth root (n = total number of words)
      perplexity <- prod(perplexities$perplexity)^(1/sum(perplexities$n))
      return(perplexities)
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
                                                                       position=.x)
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
                
                max_n <- object@max_n
                ngram_start <- max(1, position-max_n+1)
                ngram <- sentence[[1]][ngram_start:position]
                # probability with stupid backoff
                prob_list <- object@freq_list
                unk_prob <- object@unk_prob
                probability = stupidBackoff(ngram, prob_list, max_n, unk_prob)$frequency
                return(probability)
          }
)

stupidBackoff <- function(ngram, prob_list, max_n=3, unk_prob=0) {
      n <- min(max_n, length(ngram))
      for (i in n:1) {
            ngram <- tail(ngram, i)
            match <- filter(prob_list[[i]], feature==paste(ngram, collapse="_"))
            if (nrow(match)>0) return(match)
      }
      # if no match, returning 0 probability will give 0 perplexity
      # unk_freq needs to be defined by the model
      return(tibble(feature="<UNK>", frequency=unk_prob))
}
