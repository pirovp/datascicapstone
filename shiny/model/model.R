setClass(
      "langmodel",
      representation(
            prob_list = "list",
            max_n = "numeric",
            unk_prob = "numeric",
            # IMPROVEMENTS POSSIBLE HERE
            # can be subset calcd at the moment
            cond_probs = "data.frame",
            evalProbability = "function",
            predictProbability = "function",
            parameters = "list"
      )
)

source("model_eval.R")
source("model_predict.R")