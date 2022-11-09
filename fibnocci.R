library(tidyverse)
library(shiny)


fib2 <- function(n) ifelse(n<3, 1, fib(n-1)+fib(n-2))