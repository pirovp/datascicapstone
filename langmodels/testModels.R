library(purrr)

source("scripts/model/model.R", chdir = TRUE)
source("exploratory/fsample.R", chdir = TRUE)

model_files <- list.files("langmodels/", pattern = ".rds$")

parse_name <- function(filename) {
      fields <- strsplit(filename, "_")[[1]]
      tibble(model = filename,
             max_n = as.numeric(substr(fields[2], 1, 1)),
             nlines = as.numeric(substr(fields[3], 1, 3)),
             nfeats = as.numeric(substr(fields[4],1, 3))
      )
}  

model_list <- map_dfr(model_files, parse_name)

testSample <- function(nlines, seed) {      
      require(quanteda)
      
      corpus_files <- c(
            blogs = "data/final/en_US/en_US.blogs.txt",
            news = "data/final/en_US/en_US.news.txt",
            twitter = "data/final/en_US/en_US.twitter.txt"
      )
      
      corpus_sample <- map(corpus_files, ~fsample(., n = nlines, seed = seed))
      corpus <- corpus(do.call(c, corpus_sample))
}

test_sample <- testSample(10, 777)
saveRDS(test_sample, "langmodels/testsample.Rds")

testModel <- function(modelfile) {
      model <- readRDS(paste0("langmodels/", modelfile))
      print(paste("calculating", modelfile))
      start_time <- Sys.time()
      x <- corpusPerplexity(test_sample, model)
      print(Sys.time()-start_time)
      print(x[[2]])
      x[[2]][1]
}

perp <- map_chr(model_list$model, testModel)
