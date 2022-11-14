source(file.path(getwd(),list.files(getwd(), pattern = "dsCompose1.R")))

summaryOutput <- function(id) {
  tags$ul(
    tags$li("Min: ", textOutput(NS(id, "min"), inline = TRUE)),
    tags$li("max: ", textOutput(NS(id, "max"), inline = TRUE)), 
    tags$li("Missing: ", textOutput(NS(id, "n_na"), inline = TRUE))
  )
}

summaryServer <- function(id, x) {
  moduleServer(id, function(input, output, session) {
    rng <- reactive({
      req(x() %>% unlist() %>% is.numeric)
      range(x(), na.rm = TRUE)
    })
    output$min <- renderText(rng()[[1]])
    output$max <- renderText(rng()[[2]])
    output$n_na <- renderText(sum(is.na(x())))
  })
}


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

summariseApp <- function(dfFilter = NULL) {
  .allowedVarTypes <- c("integer", "numeric", "factor")
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        selectDataVarUI("datavar", dfFilter),
      ), 
      mainPanel(
        summaryOutput("summary")
      )
    )
  )
  
  server <- function(input, output, session) {
    x <- selectDataVarServer("datavar", .allowedVarTypes)
    #output$hist <- renderPrint(x())
    summaryServer("summary", x)
  }
  shinyApp(ui, server)
}
summariseApp(is.data.frame)