library(tidyverse)
library(shiny)

ymdDateUI <- function(id, label) {
  label <- paste0(label, " (yyyy-mm-dd)")
  fluidRow(
    textInput(NS(id, "date"), label), 
    textOutput(NS(id, "error"))
  )
}

ymdDateServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$error <- reactive(strptime(input$date, "%Y-%m-%d") %>% as.character())
  })
}

ymdDateApp <- function() {
  ui <- fluidPage(
    ymdDateUI("date", "")
  )
  
  server <- function(input, output, session) {
    ymdDateServer("date")
  }
  shinyApp(ui, server)
}
ymdDateApp()
