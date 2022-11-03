library(tidyverse)
library(shiny)

ui <- fluidPage(
  selectInput("x", "X Variable", choices = names(iris)),
  selectInput("y", "Y Variable", choices = names(iris)),
  selectInput("plotType", "Type of Plot", choices = c("point", "smooth", "jitter")),
  plotOutput("plot")
)
server <- function(input, output, session) {
  plot_geom <- reactive({
    switch(input$plotType, 
           point = geom_point(), 
           smooth = geom_smooth(se = FALSE),
           jitter = geom_jitter()
    )
  })
  output$plot <- renderPlot({
    ggplot(iris, aes(.data[[input$x]], .data[[input$y]])) + plot_geom()
  }, res = 96)
}
shinyApp(ui, server)