library(tidyverse)
library(shiny) 

datasetInput <- function(id, filter = NULL) {
  names <- ls("package:datasets")
  if (! is.null(filter)) {
    ds <- lapply(names, get, "package:datasets") %>% lapply(filter) %>% unlist() %>% which()
    names <- names[ds]
  }
  selectInput(NS(id, "dataset"), "Pick a data.frame...", choices = names)
}

getSet <- function(nmDataSet) {
  get(nmDataSet, "package:datasets") %>% 
    
}
datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}

varTypeInput <- function(id) {
  selectInput(NS(id, "varType"), "Select variable type to display", choices = NULL)
}
findVarTypes <- function(data) {
  
}
  # Only for is.character and is.numeric for now... 
selectVarInput <- function(id) {
  selectInput(NS(id, "var"), "Select a Variable to display", choices = NULL)
}
findVars <- function(data, filter = NULL) {
  cnames <- names(data)
  if (! is.null(filter)) {
    cnames <- vapply(data, filter, FALSE) %>% which() %>% unname() %>% `[`(cnames, .)
  }
  cnames 
}
selectVarServer <- function(id, data, filter = NULL) {
  stopifnot(is.reactive(data))
  stopifnot(! is.reactive(filter))
  moduleServer(id, function(input, output, session) {
    # observeEvent(data(), {
    #   updateSelectInput(session, "var", choices = findVars(data(), filter))
    # })
    observe({updateSelectInput(session, "var", choices = findVars(data(), filter))}) %>% bindEvent(data())
    reactive(data()[[input$var]])
  })
}

datasetApp <- function(dfFilter = NULL, varFilter = NULL) {
  ui <- fluidPage(
    datasetInput("dataset", dfFilter), 
    selectVarInput("varb"),
    #tableOutput('data')
    verbatimTextOutput("out")
  )
  server <- function(input, output, session) {
    data <- datasetServer('dataset')
    varContent <- selectVarServer("varb", data, varFilter)
    #output$data <- renderTable(data())
    output$out <- renderPrint(varContent())
  }
  shinyApp(ui, server)
}
datasetApp(is.data.frame, is.factor)
