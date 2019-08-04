load("data/corpusQ2.Rdata")
load("data/tokensQ2.Rdata")

# Question 3

maxline <- function (file, n = 10000) {
      maxlen <- 0
      iter = 0
      con <- file(file, open = "r")
      repeat {
            temp <- readLines(con, n)
            if ((length(temp)) == 0L) break
            tempmax <- max(nchar(temp))
            if (tempmax > maxlen) {
                  maxlen <- tempmax
                  print(maxlen)
            }
            iter = iter + 1
      }
      close(con)
      maxlen
}

maxline(encorp[1])
maxline(encorp[2])

# Question 4

dtwitter <- dfm(ttwitter)

my_dict <- dictionary(list(love = "love", hate = "hate"))

dfml <- dfm_lookup(dtwitter, my_dict, case_insensitive = FALSE)
sum((dfml[,1]))/sum((dfml[,2]))

# Question 5

bios <- dfm_keep(dtwitter, "biostats")
bios <- dfm_sort(bios, margin = "documents") # text556872
ctwitter[556872,]

# Question 6

match = "A computer once beat me at chess, but it was no match for me at kickboxing"
load("data/fullcorpora.Rdata")
sum(twitter == match)
