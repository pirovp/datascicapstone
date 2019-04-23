# Optimise model

optimiseModel <- function(lambdas, corpus, lmodel) {
      lmodel@lambdas <- lambdas
      corpusPerplexity(corpus, lmodel)
}

optim(par = c(0.1, 0.2, 0.7), # start parameters
      fn = optimiseModel,
      lower = rep(0, 3),
      upper = rep(0, 1),
      method = "Nelder-Mead")