library(quanteda)
library(dplyr)
library(purrr)

source("exploratory/fsample.R", chdir = TRUE)
source("scripts/training_aux_functions.R", chdir = TRUE)
source("scripts/model/model.R", chdir = TRUE)
source("scripts/stupid_backoff/stupid_backoff.R", chdir = TRUE)

makeBackoffModel <-
      function(nlines = 1000,
               max_n = 4,
               max_features  = 1000,
               modelname = NULL,
               seed = 1000) {
            
      start_time <- Sys.time()
            
      corpus_files <- c(
            blogs = "data/final/en_US/en_US.blogs.txt",
            news = "data/final/en_US/en_US.news.txt",
            twitter = "data/final/en_US/en_US.twitter.txt"
      )
      
      corpus_sample <- map(corpus_files, ~fsample(., n = nlines, seed = seed))
      corpus <- corpus(do.call(c, corpus_sample))
      
      prob_list <- map(generateDfms(corpus, ngrams = 1:max_n),
                       trimDfm,
                       max_features)

      unk_prob = map_dbl(prob_list, ~min(.$ 
frequency))
      cond_probs <- condProbabilities(prob_list, unk_prob)
      
      langmodel <- new(
            "langmodel",
            prob_list = prob_list,
            max_n = max_n,
            unk_prob = unk_prob,
            cond_probs = cond_probs,
            evalProbability = stupidBackoff_eval,
            predictProbability = stupidBackoff_predict
      )
      
      if (is.null(modelname)) {
            modelname <-
                  paste0("backoff", "_",
                         max_n, "gram_",
                         "1e", signif(log10(nlines), 2), "lines_",
                         "1e", signif(log10(max_features), 2), "trim")
      }
      
      saveRDS(langmodel, file = paste0("langmodels/", modelname, ".rds"))
      
      print(Sys.time()-start_time)
      
      langmodel
}