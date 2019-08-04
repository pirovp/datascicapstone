# Read corpus into memory but with quanteda/readtext pkgs
library(quanteda)

# readtext function from quanteda doesn't split at /n
#texts <- readtext("data/final/en_US/")
#encorp <- corpus(texts)
#save(encorp, file = "data/corpusQ.Rdata")

# With data from read.R instead:
#load("data/fullcorpora.Rdata")
load("../data/smallsample.Rdata") # small sample corpus to try a few things quickly
cblogs <- corpus(blogs, metacorpus = list(source = "blogs"))
cnews <-  corpus(news, metacorpus = list(source = "news"))
ctwitter <- corpus(twitter, metacorpus = list(source = "twitter"))
rm(blogs, news, twitter)
save(cblogs, cnews, ctwitter, file = "../data/corpusQ.Rdata")