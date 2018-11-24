load("data/smallsample.Rdata")

x <- kwic(twitter, "happy") %>%
      textplot_xray()
tibble::as.tibble(x)
x <- dfm(twitter, remove = stopwords())
xx <- head(x, n = 10, nf = 10)
dicky <- dictionary(list(uno = c("Monday", "Tuesday")))
y <- dfm_lookup(x, dicky)
head(y)
z <- dfm_select(x, dicky)
dfm_sample(x, size = 10, margin = "features")
dfm_weight(xx, "prop")
dfm_smooth(xx)

x <- tokens("Powerful tool for text analysis.",
remove_punct = TRUE, stem = TRUE)
myseqs <- phrase(c("powerful", "tool", "text analysis"))
tokens_compound(x, myseqs)
tokens_ngrams(x, n = 1:3)
tokens_skipgrams(x, n = 2, skip = 0:1)
tokens_wordstem(x)

x <- tokens(ctwitter, remove_punct = TRUE)
textstat_collocations(x, size = 3, min_count = 3)
textstat_readability(twitter, measure = "Flesch")

x <- dfm(twitter, remove = stopwords())
textstat_frequency(x, 10)
topfeatures(x)
textstat_lexdiv(x, measure = "TTR")
textstat_keyness(dfm(twitter, remove= stopwords())) %>% textplot_keyness()
textplot_wordcloud(x, max_words = 50, adjust = 1)

y <- textmodel_wordfish(x)
summary(y)
coef(y)
print(y)
predict(y)