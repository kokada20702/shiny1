source(file.path(getwd(), list.files(getwd(), pattern ="re3.R")))

selectDataVarUI <- function(id, dfFilter) {
  tagList(
    datasetInput(NS(id, "dataset"), dfFilter),
    varTypeInput(NS(id, "vartypes")),
    selectVarInput(NS(id, "vars"))
  )
}

selectDataVarServer <- function(id, .allowedVarType) {
  moduleServer(id, function(input, output, session) {
    data <- datasetServer("dataset")
    filter <- varTypeServer("vartypes", data, .allowedVarType)
    selectVarServer("vars", data, filter)
  })
}

selectDataVarApp <- function(dfFilter = NULL) {
  .allowedVarType <- c("integer", "numeric", "factor")
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(selectDataVarUI("datavar", dfFilter)), 
      mainPanel(verbatimTextOutput("out"))
    )
  )
  server <- function(input, output, session) {
    varOTP <- selectDataVarServer("datavar", .allowedVarType)
    output$out <- renderPrint(varOTP())
  }
  shinyApp(ui, server)
}

#selectDataVarApp(is.data.frame)
