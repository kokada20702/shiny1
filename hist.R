library(tidyverse)
library(shiny)

files <- list.files(getwd(), pattern = "dsCompose1.R")
source(file.path(getwd(), files))

histOutput <- function(id) {
  tagList(
    numericInput(NS(id, "bins"), "bins", 10, min = 1, step = 1),
    plotOutput(NS(id, "hist"))
  )
}

#histServer <- function(id, x, title = reactive("Histogram"))
histServer <- function(id, x) 
{
  stopifnot(is.reactive(x))
  #stopifnot(is.reactive(title))
  moduleServer(id, function(input, output, session) {
    observe({
      #message(paste0("x is ", class(x)))
      output$hist <- renderPlot({
        req(is.numeric(x() %>% unlist()))
        hist(x() %>% unlist(), breaks=input$bins, main = paste0(names(x())[1], ' [', input$bins, ']'))    
      }, res = 96)
    }) %>% bindEvent(x)
  })
}

sidebarLayout(
  sidebarPanel(),
  mainPanel(verbatimTextOutput("out"))
)

histApp <- function(dfFilter = NULL) {
  .allowedVarTypes <- c("integer", "numeric", "factor")
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        selectDataVarUI("datavar", dfFilter),
      ), 
      mainPanel(
        histOutput("hist")
        #verbatimTextOutput("hist")
      )
    )
  )
  
  server <- function(input, output, session) {
    x <- selectDataVarServer("datavar", .allowedVarTypes)
    #output$hist <- renderPrint(x())
    histServer("hist", x)
  }
  shinyApp(ui, server)
}
histApp(is.data.frame)