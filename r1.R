library(tidyverse)
library(shiny) 

reactiveConsole(TRUE)

temp_C <- reactiveVal(10)
temp_C()

temp_C(20)
temp_C()

temp_F <- reactive({
  message("Converting...")
  (temp_C() * 9 / 5) + 32
})

temp_C(30)
temp_F()
temp_F()

temp_C(50)
temp_F()
temp_C()

x <- reactiveVal(10)
y <- reactive(x + y())
y()

l1 <- reactiveValues(x = 10, y = 20)
l2 <- list(x = reactiveVal(10), y = reactiveVal(20))

l1$x <- 30
l1$x
l2$x(30)
l2$x
l2$y <- 40
l2$y 
l1$y <- 40
l1[["y"]] <- 50
l1
l2
l2[["y"]] <- 50

l3 <- l2 <- reactiveValues(x = 1, y = 2)
l3$x
l2$x
l3$x <- 10
l3$x
l2$x
l3$y
l2$y

