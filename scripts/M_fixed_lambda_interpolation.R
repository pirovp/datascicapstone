stupidBackoff_eval <- function(ngram, matches, lambdas, unk_prob) {
      return(matches$condprob[1])
}

stupidBackoff_predict <- function(ngram, matches, lambdas, unk_prob) {
      return(mutate(matches,
                    predicted_word=sub(".*_", "", feature)
      )
      )
}