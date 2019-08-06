# no need to do anything in eval mode
stupidBackoff_eval <- function(ngram, matches) {
      return(matches$condprob[1])
}

#
stupidBackoff_predict <- function(matches) {
      require(dplyr)
      return(mutate(matches,
                    predicted_word=sub(".*_", "", feature)
                    )
      )
}