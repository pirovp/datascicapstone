corp <- cblogs+cnews+ctwitter

# stemming not useful; how to treat punctuation and case?
cleanTokens <- function(corpus) {
      n1grams <- tokens(corpus, 
                     remove_numbers = TRUE, 
                     remove_punct = TRUE,
                     remove_symbols = TRUE,
                     remove_separators = TRUE,
                     remove_twitter = FALSE,
                     remove_hyphens = TRUE,
                     remove_url = TRUE) %>%
            tokens_tolower(keep_acronyms = TRUE) #%>%
            #Dr. Martin Porter's stemming algorithm
            #tokens_wordstem()
}

# ngrams and skipgrams
n2grams <- tokens_ngrams(toks, n = 2L, skip = 0L)
length(attributes(n1grams)$types)
length(attributes(n2grams)$types)