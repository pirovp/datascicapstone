default_str <- "We have to have a serious discussion about the"

ui <- fluidPage(theme = shinythemes::shinytheme("journal"),
      #shinythemes::themeSelector(),
      titlePanel("Text prediction with R"),
      tabsetPanel(
            tabPanel(
                  "App",
                  br(),
                  fluidRow(column(4,
                        textInput("user_text",
                                  label = NULL, 
                                  value = default_str,
                                  width = "100%")
                        ),
                        column(1,
                               textOutput("prediction")
                        )),
                  fluidRow(column(8,
                        textOutput("more_predictions")
                        )),
                  fluidRow(column(8,
                        plotOutput("probs_plot")
                        ))
                  ),
            
            tabPanel(
                  "Documentation",
                  column(8, includeMarkdown("documentation.md"))
            )
            
            
      )
)
