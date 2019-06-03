library(shiny)
library(ggplot2)
library(dplyr)
library(plyr)

class_info <- read.csv("UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv")
class_info$classes <- substr(class_info$Course_Number, 1, nchar(as.character(class_info$Course_Number))-1) 
condensded_frame <- class_info
condensded_frame$Course_Number <- NULL
condensded_frame$quarter <- substring(condensded_frame$Term, 6)


my_server <- function(input, output) {

  output$value <- renderPrint({
    input$prof_name
  })
  output$value <- renderPrint({
    input$classes
  })
  output$value <- renderPrint({
    input$students
  })
  
  output$text <- renderText({
    filter_frame <- condensded_frame[tolower(condensded_frame$Primary_Instructor) == tolower(input$prof_name), ]
    filter_frame$taught <- paste(filter_frame$class, filter_frame$quarter)
    message_str <- paste0(filter_frame$taught)
  })
  
  output$scatter <- renderPlot({
    filter_frame_classes <- filter(condensded_frame, classes == paste0(input$classes, " "))
    filter_frame_classes <- select(filter_frame_classes, Average_GPA, quarter)
    quarter_data <- ddply(filter_frame_classes, .(quarter), summarise, Average_GPA=mean(Average_GPA))
    ggplot(data = as.data.frame(quarter_data), 
           aes(x = quarter, y = Average_GPA)) +
      geom_point() +
      ggtitle(input$classes) +
      labs(y = "Average GPA", x = "Quarter") +
      scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = .1))
    
  })
  output$bar <- renderPlot({
    filter_frame_students <- filter(condensded_frame, classes == paste0(input$students, " "))
    filter_frame_students <- select(filter_frame_students, Student_Count, quarter)
    students_data <- ddply(filter_frame_students, .(quarter), summarise, Student_Count=sum(Student_Count))
    ggplot(data = students_data, 
           aes(x = students_data$quarter, y = students_data$Student_Count)) +
      geom_bar(stat = "Identity") +
      ggtitle(input$students) +
      labs(y = "Student Number", x = "Quarter")
    
  })
}