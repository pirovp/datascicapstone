server <- function(input, output) {
      
      nextWords <- function(txt) {
            sample(c("cat", "giraffe", "liger"))
      }
      
      predictions <- reactive({
            nextWords(input$user_text)
            })
      
      output$prediction <- renderText(predictions()[1])
      output$more_predictions <- renderText(predictions()[-1])
}