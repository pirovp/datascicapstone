default_str <- "We have to have a serious discussion about the"

ui <- fluidPage(theme = shinythemes::shinytheme("darkly"),
      shinythemes::themeSelector(),
      titlePanel("Text prediction with R"),
      tabsetPanel(
            tabPanel(
                  "App",
                  br(),
                  fluidRow(
                        column(8,
                               textInput("user_text",
                                         label = NULL, 
                                         value = default_str)
                        ),
                        column(2,
                               textOutput("prediction")
                        )
                        ),
                  fluidRow(
                        column(8,
                               textOutput("more_predictions")
                        )
                  )
            ),
            
            tabPanel(
                  "Documentation",
                  includeHTML("documentation.html")
            )
            
            
      )
)