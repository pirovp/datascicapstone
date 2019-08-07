source("model/model.R", chdir = TRUE)
source("plotProbs.R")
langmod <- readRDS("langmodels/model.RDS")

server <- function(input, output, session) {
      
      predictions <- reactive({
            predict(langmod, input$user_text)
            })
      
      observe({
            req(input$user_text)
            purrr::walk(1:5,
                        ~updateActionButton(session,
                                            paste0("prediction", .),
                                            label = predictions()[.])
                        )

      })
      
      updateTxt <- function(i) {
            updateTextInput(session, 
                            "user_text",
                            value=paste(input$user_text, predictions()[i])
            )
      }
      
      observeEvent(input$prediction1, updateTxt(1))
      observeEvent(input$prediction2, updateTxt(2))
      observeEvent(input$prediction3, updateTxt(3))
      observeEvent(input$prediction4, updateTxt(4))
      observeEvent(input$prediction5, updateTxt(5))
      
      predictSentence <- function(sentence, len) {
            for (i in 1:len) {
                  newword <- predict(langmod, sentence)[1]
                  sentence <- paste(sentence, newword)
            }
            paste0(sentence, ".")
      }
      
      observeEvent(input$rs_button, 
                   {output$rs_text <- renderText({
                         predictSentence(input$user_text, len = input$nwords)
                   })
                  })
                  
      
      #output$probs_plot <- renderPlot(plotProbs(predictions))
}