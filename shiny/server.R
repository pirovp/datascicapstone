source("model/model.R", chdir = TRUE)
load("langmodels/model1.Rdata")
langmod <- model1

server <- function(input, output) {
      
      predictions <- reactive({
            predict(langmod, input$user_text)
            })
      
      output$prediction <- renderText(predictions()[1])
      output$more_predictions <- renderText(predictions()[-1])
}