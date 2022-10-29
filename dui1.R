library(tidyverse)
library(shiny)


sales <- vroom::vroom("sales-dashboard/sales_data_sample.csv", col_types = list(), na = "")

# sales %>% select(TERRITORY, CUSTOMERNAME, ORDERNUMBER, everything()) %>% arrange(ORDERNUMBER)
# sales %>% group_by(TERRITORY, CUSTOMERNAME, ORDERNUMBER) %>% summarize(n= n())

ui <- fluidPage(
  titlePanel("Sales Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("territory", "Territory", choices = unique(sales$TERRITORY)),
      selectInput("customername", "Customer Name", choices = NULL), 
      selectInput("ordernumber", "Order Number", choices = NULL),
    ), 
    mainPanel(
      uiOutput("customer"),
      tableOutput("data")
    )
  )
)

server <- function(input, output, session) {
  territory <- reactive({
    req(input$territory)
    filter(sales, TERRITORY == input$territory)
  })
  observeEvent(territory(), {
    updateSelectInput(session, "customername", choices = unique(territory()$CUSTOMERNAME))
  })
  
  customer <- reactive({
    req(input$customername)
    filter(territory(), CUSTOMERNAME == input$customername)
  })
  observeEvent(customer(), {
    updateSelectInput(session, "ordernumber", choices = unique(customer()$ORDERNUMBER))
  })
  
  order <- reactive({
    req(input$ordernumber)
    customer() %>%
      filter(ORDERNUMBER == input$ordernumber) %>%
      arrange(ORDERLINENUMBER) %>%
      select(PRODUCTLINE, QUANTITYORDERED, PRICEEACH, SALES, STATUS)
  })
  
  output$data <- renderTable(order())  
  # output$data <- renderTable({
  #   req(input$ordernumber)
  #   customer() %>% 
  #     filter(ORDERNUMBER == input$ordernumber) %>% 
  #     select(QUANTITYORDERID, PRICEEACH, PRODUCTCODE)
  # })
}
shinyApp(ui, server)