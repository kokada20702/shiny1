library(tidyverse)
library(shiny)

# map(list.files(getwd(), pattern = "dyn3.R"), source)
# dfs1 <- keep(ls("package:datasets"), ~ is.data.frame(get(.x, "package:datasets"))) 

# d1 <- get("crimtab", "package:datasets")
# d1
# d1 %>% is.matrix()
# d1 %>% is.data.frame()

# as_tibble(d1) 
# as.data.frame(d1)
# d1[, colnames(d1)] %>% as.data.frame()

# d2 <- d1 %>% as.data.frame()
# d2 %>% pivot_wider(names_from = "Var2", values_from = "Freq") %>% as_tibble()


dfs <- keep(ls("package:datasets"), ~ is.data.frame(get(.x, "package:datasets"))) 
#dfs <- map(dfs1, ~ !is_null(as_tibble(get(.x, "package:datasets"))))
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", label = "Dataset", choices = dfs),
      uiOutput("filter")
    ),
    mainPanel(
      tableOutput("data")
    )
  )
)

server <- function(input, output, session) {
  data <- reactive({
    get(input$dataset, "package:datasets") %>% as_tibble()
  })
  
  vars <- reactive(names(data()))
  
  output$filter <- renderUI({
    map(vars(), ~ make_ui(data()[[.x]], .x))
  })
  
  selected <- reactive({
    each_var <- map(vars(), ~ filter_var(data()[[.x]], input[[.x]]))
    reduce(each_var, `&`)
  })
  
  output$data <- renderTable(head(data()[selected(), ], 20))
}

shinyApp(ui, server)