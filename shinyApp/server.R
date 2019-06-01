library(shiny)
library(dplyr)
library(stringr)
library(DT)
file <- read.csv("../UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv")
shinyServer(function(input, output) {
  output$info<-renderText({
    "gneeral info"
  })
  output$quarter <- renderDataTable({
      if(input$text != ""){
         datatable(file %>% filter(str_detect(Course_Number, input$text)) %>% 
                   select(Term, Course_Number, Course_Title, Primary_Instructor, Average_GPA),
                   colnames = c("Term", "Course Number", "Course Title", "Instructor", "Average GPA"),
                   options = list(dom = 'ltipr'), rownames = FALSE)
      } else {
        datatable(file %>% select(Term, Course_Number, Course_Title, Primary_Instructor, Average_GPA),
                  colnames = c("Term", "Course Number", "Course Title", "Instructor", "Average GPA"),
                  options = list(dom = 'ltipr'), rownames = FALSE)
      }
  })
  output$offered <- renderPrint({
    class <- file %>% filter(str_detect(Course_Number, input$text)) %>%
      select(Term, Course_Number, Course_Title, Primary_Instructor, Average_GPA)
    if(input$text == "") {
      cat("Offered in:")
    } else {
      if (nrow(class) == 0) {
        cat("Course not found...")
      } else {
        time <- "Offered in:"
        spr <- class %>% filter(str_detect(Term,'Spring'))
        sum <- class %>% filter(str_detect(Term,'Summer'))
        aut <- class %>% filter(str_detect(Term,'Autumn'))
        win <- class %>% filter(str_detect(Term,'Winter'))
        if(nrow(spr)!= 0) {
         time<- paste(time,"Spring")
        }
        if(nrow(sum) != 0){
          time <- paste(time, "Summer", sep = ", ")
        }
        if(nrow(aut) != 0){
          time <- paste(time, "Autumn", sep = ", ")
        }
        if(nrow(win) != 0){
          time <- paste(time, "Winter", sep = ", ")
        }
        cat(time)
      }
    }
  })
})
