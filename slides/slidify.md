---
title       : "Coursera Datascience Capstone - Text prediction"
author      : "Paolo Pirovano"
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<style>
.small-code pre code {
  font-size: 1em;
}
</style>



# Text prediction with R

This app constitutes the final project in Coursera Data Science specialization capstone. Its functionality is similar to that of smartphone keyboards, i.e. predicting the next word in a sentence based on the previous input. It works exclusively in the English language. 

---

# Language models

* The model used in the app is a simple 4-gram model implementing the Katz's back-off algorithm, trained on 300000 lines of text data.

* Evaluated by calculating perplexity (900) on test data.

* More comp power - efficient code

---

# Implementation

The models are implemented as `langmodel` S4 objects, with implemented methods `predict`, `perplexity` and `tokenProbability`. The framework is in principle extendible to new language models. There are dependencies to the packages `quanteda`, `dplyr` and `purrr`.

--- .small-code

```r
setClass(
      "langmodel",
      representation(
            prob_list = "list",
            max_n = "numeric",
            unk_prob = "numeric",
            cond_probs = "data.frame",
            evalProbability = "function",
            predictProbability = "function",
            parameters = "list"
      )
)
```
---


# The app

* Prediction of next word
* Auto responsive and interactive (similar to smartphone keyboard)
* Funny sentence generations

