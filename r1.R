library(tidyverse)
library(shiny)

reactiveConsole(TRUE)

x <- reactiveVal(1)
y <- reactiveVal()
#reactive({x; y})

# 
observe({
  x()
  y(y() + 1)
})

x(2)
y()
