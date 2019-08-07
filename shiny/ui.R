default_str <- "I woke up and"
library(markdown)

ui <- fluidPage(theme = shinythemes::shinytheme("journal"),
                
      #shinythemes::themeSelector(),
      titlePanel("Text prediction with R"),
      tabsetPanel(
            tabPanel(
                  "App",
                  br(),
                  fluidRow(column(8,
                        textInput("user_text",
                                  label = NULL, 
                                  value = default_str,
                                  width = "100%")
                        )),
                  br(),
                  fluidRow(
                        column(1
                        ),
                        column(1,
                               actionButton("prediction1", label = "")
                        ),
                        column(1,
                               actionButton("prediction2", label = "")
                        ),
                        column(1,
                               actionButton("prediction3", label = "")
                        ),
                        column(1,
                               actionButton("prediction4", label = "")
                        ),
                        column(1,
                               actionButton("prediction5", label = "")
                        )),
                  br(),
                  fluidRow(column(8,
                                  "Click on a predicted word above, or generate a whole sentence.")),
                  br(),
                  fluidRow(
                        column(1),
                        column(6,
                        actionButton("rs_button", label = "Predict Sentence"),
                        selectInput("nwords", "Number of new words:", 1:30, 8)
                        )),
                  br(),
                  fluidRow(column(8,
                        textOutput("rs_text")
                  ))
                  ),
            
            tabPanel(
                  "Documentation",
                  column(8, includeMarkdown("documentation.md"))
            )
            
            
      )
)
