library(tidyverse)
library(shiny)


ui <- fluidPage(
  actionButton("plot", "Plot"), 
  selectInput("typ", "Distribution Type", choices = c("runif", "rnorm")),
  plotOutput("pltPanel")
)
server <- function(input, output, session) {
  dst <- reactive(do.call(isolate(input$typ), list(10000))) %>% 
    bindEvent(input$plot)
  output$pltPanel <- renderPlot(hist(dst()))
}

shinyApp(ui, server) 


