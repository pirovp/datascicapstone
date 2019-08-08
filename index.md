---
title       : "Coursera Datascience Capstone:          Text prediction"
author      : "Paolo Pirovano"
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax, bootstrap] # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---



## Text prediction with R

* This Shiny app was developed as the final project in Coursera Data Science specialization capstone. 

* Functionality is similar to that of smartphone keyboards: predicts the next word in a sentence based on the previous input. It works exclusively in the English language. 

* Based on a language model, returns the words with highest probabilities given the user input.

---

## Language models

* *Natural language models*: n-gram models (2 < n < 7) with Katz's back-off algorithm. Trained on an *English language corpus* of tweets, blog entries and news articles. Previously unobserved n-grams are handled by *smoothing* - assigning "unknown n-gram frequency".

* Models were valuated by calculating perplexity on test data. Diminishing returns on complexity and computational cost also taken into consideration.

* The model used in the app is a simple 4-gram model implementing the Katz's back-off algorithm, trained on 300000 lines of text data: size ~ 800 kb.

### Limitations: 
* Fairly biased towards the most common words (the, and, that...)
* Predicting ahead multiple words tends to stick on some phrases
* Not unreasonable for an n-gram model - perhaps introduce a long-distance element (i.e. cache models)

---

## Implementation

* S4 class `langmodel` has been defined
* implemented methods `predict`, `perplexity` and `tokenProbability`
* Can potentially extend by plugging in new language models.


```r
setClass("langmodel",
         representation(
            ...
      ))

predict(object, sentence="")

tokenProbability(object, sentence="", position=1L)

perplexity(object, sentence="")
```


There are dependencies to the packages `quanteda`, `dplyr` and `purrr`.

---

## The app

* Write into the text box at the top of the page

* 5 **words suggestions** are proposed reactively — they are *clickable*, like a smartphone keyboard

* Generate a full sentence of 1-30 words: funny and nonsensical!

<center>
<img src=assets/img/app.png>
</center>

---

## Links

* _The app_: https://pyrop.shinyapps.io/text_prediction/

* _GitHub repo_: https://github.com/pirovp/datascicapstone

* _Exploratory data analysis report_: http://rpubs.com/pyrop/dsc_eda
