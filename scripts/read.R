encorp <- c(
  blogs = "data/final/en_US/en_US.blogs.txt",
  news = "data/final/en_US/en_US.news.txt",
  twitter = "data/final/en_US/en_US.twitter.txt"
)

# Sample a small set of 1000 lines from each file

source("scripts/fsample.R")

blogs <- fsample(encorp[1], n = 1000L, seed = 2000)
news <- fsample(encorp[2], n = 1000L, seed = 2000)
twitter <- fsample(encorp[3], n = 1000L, seed = 2000)

save(blogs, news, twitter, file = "data/smallsample.Rdata")
rm(blogs, news, twitter)


# read full files

qread <- function(fname) {
      con <- file(fname, open = "r")
      x <- readLines(con, skipNul = TRUE)
      close(con)
      x
}

blogs <- qread(encorp[1])
news <- qread(encorp[2])
twitter <- qread(encorp[3])

save(blogs, news, twitter, file = "data/fullcorpora.Rdata")
rm(list = ls())