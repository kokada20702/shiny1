library(tidyverse)
library(shiny) 

make_ui <- function(x, var) {
  if ( is.numeric(x) ) {
    rng <- range(x, na.rm = TRUE) 
    sliderInput(var, var, min = rng[1], max = rng[2], value = rng)
  }
  else if ( is.factor(x) ) {
    levs <- levels(x)
    selectInput(var, var, choices = levs, selected = levs, multiple = TRUE)
  }
  else if ( lubridate::is.Date(x) ) {
    rng <- range(x, na.rm = TRUE)
    dateInput(var, var, min = rng[1], max = rng[2], value = rng)
  }
  else { NULL }
}

filter_var <- function(x, val) {
  if (is.numeric(x)) {
    !is.na(x) & x >= val[1] & x <= val[2] 
  } else if (is.factor(x)) {
    x %in% val 
  } else if (lubridat::is.Date(x)) {
    x %in% val
  } else {
    TRUE
  }
}

# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       map(names(iris), ~ make_ui(iris[[.x]], .x))
#     ), 
#     mainPanel(
#       tableOutput("data")
#     )
#   )
# )
# server <- function(input, output, session) {
#   selected <- reactive({
#     each_var <- map(names(iris), ~ filter_var(iris[[.x]], input[[.x]]))
#     reduce(each_var, ~ `&`(.x, .y) )
#   })
#   output$data <- renderTable(head(iris[selected(), ], 20))
# }

#shinyApp(ui, server) 

