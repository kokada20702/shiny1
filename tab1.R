library(tidyverse)
library(shiny)

parameter_tabs <- tabsetPanel(
  id = "params",
  type = "hidden",
  tabPanel("normal", 
           numericInput("mean", "Mean", value = 1), 
           numericInput("sd", "Std Dev", min = 0, value = 1)
           ),
  tabPanel("uniform", 
           numericInput("min", "Min", value = 0), 
           numericInput("max", "Max", value = 1)
  ), 
  tabPanel("exponential", 
           numericInput("rate", "Rate", value = 1, min = 0)
  )
)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("dist", "Distribution", choices = c("normal", "uniform", "exponential")),
      numericInput("n", "Number of Samples", value = 100),
      parameter_tabs,
    ),
    mainPanel(
      plotOutput("hist")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$dist, {
    
    updateTabsetPanel(inputId = "params", selected = input$dist)
  })
  sample <- reactive({
    switch(input$dist, 
           normal = rnorm(input$n, input$mean, input$sd), 
           uniform = runif(input$n, input$min, input$max), 
           exponential = rexp(input$n, input$rate)
    )
  })
  output$hist = renderPlot(hist(sample()), res = 96)
}
shinyApp(ui, server)
