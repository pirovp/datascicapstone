ui <- fluidPage(
      titlePanel("Text prediction with R"),
      tabsetPanel(
            tabPanel(
                  "App",
                  br(),
                  fluidRow(
                        column(4,
                               textInput("user_text", label = NULL, value = "What a nice")
                        ),
                        column(2,
                               verbatimTextOutput("prediction")
                        ),
                        column(4,
                               verbatimTextOutput("more_predictions")
                        )
                  )
            ),
            
            tabPanel(
                  "Documentation",
                  includeHTML("documentation.html")
            )
      )
)