library(tidyverse)
library(shiny) 

dfs <- lapply(ls("package:datasets"), get, "package:datasets")
uniquevarfunctions <- dfs %>% map(., ~ map(., class)) %>% unlist() %>% unique() %>% 
  map(., ~ switch(., "integer" = "is.integer", "numeric" = "is.numeric", "factor" = "is.factor")) %>% unlist() 

datasetInput <- function(id, filter = NULL) {
  names <- ls("package:datasets")
  if (! is.null(filter)) {
    ds <- lapply(names, get, "package:datasets") 
    ds <- ds %>% lapply(filter) %>% unlist() %>% which()
    names <- names[ds]
  }
  selectInput(NS(id, "dataset"), "Pick a data.frame...", choices = names)
}
datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}

varTypeInput <- function(id) {
  selectInput(NS(id, "varType"), "Select variable type to display", choices = NULL)
}
findVarType <- function(.var, .selectedTypesList) {
  vecClasses <- class(.var)
  vecClasses %in% .selectedTypesList %>% which %>% `[`(vecClasses, .) %>% first()
}
# Numeric/Factor/Character
findVarTypes <- function(data, .selectedTypesList) {
  #print(.selectedTypesList)
  data %>% map_chr(findVarType, .selectedTypesList) %>%  
    .[!is.na(.)] %>%
    map_chr(., ~ switch(., "integer" = "is.integer", "numeric" = "is.numeric", "factor" = "is.factor")) %>% 
    unlist() %>% unname() %>% unique()
}
varTypeServer <- function(id, data, .allowedVarTypes) {
  #stopifnot(is.reactive(data))
  moduleServer(id, function(input, output, session) {
    observe({ 
      updateSelectInput(session, "varType", choices = findVarTypes(data(), .allowedVarTypes))}) %>%
      #updateSelectInput(session, "varType", choices = findVarTypes(data, .allowedVarTypes))}) %>% 
      bindEvent(data())
    reactive(input$varType)
  })
}
  # Only for is.character and is.numeric for now... 
selectVarInput <- function(id) {
  selectInput(NS(id, "var"), "Select a Variable to display", choices = NULL)
}
findVars <- function(data, filter = NULL) {
  cnames <- names(data)
  if (! (is.null(filter) | filter == "")) {
    cols <- vapply(data, match.fun(filter), logical(1)) %>% which() %>% unname() 
    cnames <- cnames[cols]
  }
  cnames
}

selectVarServer <- function(id, data, filter = NULL) {
  stopifnot(is.reactive(data))
  stopifnot(is.reactive(filter))
  
  moduleServer(id, function(input, output, session) {
    observe({
      #message(paste0("filter = ", filter()))
      updateSelectInput(session, "var", choices = findVars(data(), filter()))
    }) %>% bindEvent(c(data(), filter()))
    reactive(select(data(), input$var))
  })
}


datasetApp <- function(dfFilter = NULL) {
    .allowedVarType <- c("integer", "numeric", "factor")
  
    ui <- fluidPage(
    datasetInput("dataset", dfFilter), 
    varTypeInput("vari"),
    selectVarInput("varb"),
    #tableOutput('data')
    verbatimTextOutput("out")
  )
  server <- function(input, output, session) {
    data <- datasetServer('dataset')
    varFilter <- varTypeServer("vari", data, .allowedVarType)
    varList <- selectVarServer("varb", data, varFilter)
    #output$data <- renderTable(data())
    output$out <- renderPrint(varList())
  }
  shinyApp(ui, server)
}

#datasetApp(is.data.frame)
