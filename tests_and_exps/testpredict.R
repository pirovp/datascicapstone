if (class(sentence)!="tokens") sentence <- cleanTokens(sentence)
sentence <- unlist(sentence)

# cut input sentence to (n-1)gram
max_n <- min(max_n, length(sentence)+1)
n_1gram <- tail(sentence, max_n-1)

i=3
cond_gram <- tail(n_1gram, i-1)
filter(cond_probs, ngram_level==i)$cond_probs[[1]] %>%
      filter(conditioned_on==paste(cond_gram, collapse = "_"))
             

x <- cleanTokens(blogs) %>% dfm(ngrams = 3)
