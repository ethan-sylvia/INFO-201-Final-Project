library(shiny)
library(dplyr)
library(stringr)
file <- read.csv("../UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv")
shinyServer(function(input, output) {
  output$info<-renderText({
    "gneeral info"
  })
  output$quarter <- renderDataTable({
    file %>% select(Term, Course_Number, Course_Title, Primary_Instructor, Average_GPA)
  })
})
