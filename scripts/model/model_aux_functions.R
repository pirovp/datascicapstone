# stemming not useful; how to treat punctuation and case?
cleanTokens <- function(corpus, what="word") {
      n1grams <- quanteda::tokens(corpus,
                        what = what,
                        remove_numbers = TRUE, 
                        remove_punct = TRUE,
                        remove_symbols = TRUE,
                        remove_separators = TRUE,
                        remove_twitter = FALSE,
                        remove_hyphens = TRUE,
                        remove_url = TRUE) %>%
            quanteda::tokens_tolower(keep_acronyms = TRUE)
      #tokens_wordstem()
      #tokens_remove(stopwords())
}
