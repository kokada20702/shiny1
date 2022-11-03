library(tidyverse)
library(shiny) 

ui <- fluidPage(
  selectInput("grp", "Vars to Group By", choices = names(mtcars), multiple = TRUE), 
  selectInput("sums", "Vars to Summarise", choices = names(mtcars), multiple = TRUE),
  tableOutput("data")
)

server <- function(input, output, session) {
  ds <- renderTable({
    mtcars %>% group_by(across(any_of(.env$input$grp))) %>% 
      summarise(across(any_of(.env$input$sums), mean), n = n(), .groups = "drop")
  })
  output$data <- ds
}

shinyApp(ui, server)
