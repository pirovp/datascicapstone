source("model/model.R", chdir = TRUE)
source("plotProbs.R")
load("langmodels/model1.Rdata")
langmod <- model1

server <- function(input, output) {
      
      predictions <- reactive({
            predict(langmod, input$user_text)
            })
      
      output$prediction <- renderText(predictions()[1])
      output$more_predictions <- renderText(predictions()[2:4])
      output$probs_plot <- renderPlot(plotProbs(predictions))
}