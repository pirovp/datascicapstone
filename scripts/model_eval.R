# determine perplexity of a language model 
# inputs: a corpus of text (corpus object), and a model (langmodel object)
# output: perplexity (double)
corpusPerplexity <- function(corpus, lmodel) {
      # split corpus into sentences
      corpus <- unlist(cleanTokens(corpus, what="sentence"))
      # non normalised perplexity each sentence
      perplexities <- purrr::map_dfr(corpus, ~perplexity(lmodel, .))
      # normalise by taking nth root (n = total number of words)
      perplexity <- mean(perplexities$perplexity)
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
                perplexity=1/prod(token_probabilities)^(1/n)
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
                
                prob_list <- object@prob_list
                unk_prob <- object@unk_prob
                
                # tokenise input sentence if nencessary
                if (class(sentence)!="tokens") sentence <- cleanTokens(sentence)
                
                max_n <- object@max_n
                ngram_start <- max(1, position-max_n+1)
                ngram <- sentence[[1]][ngram_start:position]
                
                # probability with stupid backoff
                # condition on n-1 ngram!
                match_ngrams <- stupidBackoff(ngram, prob_list, max_n, unk_prob)
                probability <- match_ngrams$frequency[1]/match_ngrams$frequency[2]
                return(probability)
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
