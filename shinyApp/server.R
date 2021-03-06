library(shiny)
library(dplyr)
library(stringr)
library(DT)
library(ggplot2)
library(plyr)

file <- read.delim("UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv",
                   sep = ",", stringsAsFactors = F)
file$classes <- substr(file$Course_Number, 1, nchar(as.character(file$Course_Number))-1) 
condensded_frame <- file
condensded_frame$Course_Number <- NULL
condensded_frame$quarter <- substring(condensded_frame$Term, 6)
shinyServer(function(input, output) {
  issue <- reactiveValues(x="Instruction: Choose the course level (100,200,300,400,500),
and the major name and the quarter, and it will show a line plot of the trend of average
                          gpa changes over the years for each course.")
  
  output$md <- renderUI({
    includeMarkdown("intro.md")
  })
  output$about <- renderUI({
    includeMarkdown("about_us.md")
  })
  
# returns a table of all courses fit with the couse number that the user
#  asks for with information of the term, course number, course title,
#  instructors and the average GPA. 
  output$quarter <- renderDataTable({
      if(input$course_number != ""){
         datatable(file %>% filter(str_detect(Course_Number, input$course_number)) %>% 
                   select(Term, Course_Number, Course_Title, Primary_Instructor,
                          Average_GPA),
                   colnames = c("Term", "Course Number", "Course Title",
                                "Instructor", "Average GPA"),
                   options = list(dom = 'ltipr'), rownames = FALSE)
      } else {
        datatable(file %>% select(Term, Course_Number, Course_Title,
                                  Primary_Instructor, Average_GPA),
                  colnames = c("Term", "Course Number", "Course Title",
                               "Instructor", "Average GPA"),
                  options = list(dom = 'ltipr'), rownames = FALSE)
      }
  })
# returns a sentence summary telling the user which quarter that the course
#  they asked is offered
  output$offered <- renderPrint({
    class <- file %>% filter(str_detect(Course_Number, input$course_number)) %>%
      select(Term, Course_Number, Course_Title, Primary_Instructor, Average_GPA)
    if(input$course_number == "") {
      cat(paste(input$course_number, "is offered in:"))
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
  
  # Based on the course level you chose(100,200,300,400,500), and the major
  # name and the quarter, this will return the line plot of the trend of average
  # gpa changes over the years for each course that satisfy your requirements.
  output$GPA_plot <- renderPlot({
    take_course_level <- function(Course_Number) {
      x <- substr(Course_Number, nchar(Course_Number)-4, nchar(Course_Number)-2)
      return(as.numeric(x))
    }
    
    test_file <- file %>% filter(Course_Number %>% take_course_level() >=
                                   as.numeric(input$course_lvl) &
                                   Course_Number %>% take_course_level() <
                                   (as.numeric(input$course_lvl)+100))
    if(nrow(test_file) == 0) {
      issue$x <- "There is no course statisfies your requirement."
    } else {
      issue$x <- ""
      test2 <- test_file %>% filter(str_detect(Course_Number,
                                               toupper(input$course_name))) %>%
        mutate(Term = substr(Term, 8, nchar(Term)-1)) %>% 
        mutate(Quarter = substr(Term, nchar(Term)-3, nchar(Term))) %>% 
        mutate(Course = substr(Course_Number, 0, nchar(Course_Number) - 2)) %>% 
        filter(grepl(input$quarter_lvl, Term)) 
      if(nrow(test2) == 0) {
        issue$x <- "There is no course statisfies your requirement."
      } else {
        issue$x <- ""
        check <- ""
        times <- 1
        test3 <- data.frame()
        for(i in 1: nrow(test2)) {
          if(test2[i, ]$Course != check) {
            times <- 1
            test3 <- rbind(test3, test2[i, ])
            check <- test2[i, ]$Course
          } else {
            test3[nrow(test3), ]$Average_GPA <- round((test3[nrow(test3),
                                                             ]$Average_GPA * times +
                                                         test2[i, ]$Average_GPA) /
                                                        (times + 1), 3)
            times <- times+1
          }
        }
        if(nrow(test3) != 0) {
          issue$x <- ""
          test3 <- test3 %>% select(Average_GPA, Quarter, Course)
          ggplot(test3, aes(x = test3$Quarter, y = test3$Average_GPA,
                            colour = test3$Course, 
                            group = test3$Course, fill = test3$Course)) +
            geom_line(size = 0.8) + 
            geom_text(aes(label = Average_GPA, vjust = 1.1, hjust = 0.5, angle = 0),
                      show.legend = F) +
            labs(title = paste0("Line Plot of ", input$course_lvl,
                                " Level Courses in ", toupper(input$course_name), " of ", 
                                input$quarter_lvl, " Quarter")) +
            xlab(label = "Years") +
            ylab(label = "Average GPA") +
            labs(colour = "Course Name")
        } else {
          issue$x <- "There is no course statisfies your requirement."
        }
      }
      
    }
  })
  
  output$Issue <- renderText({
    return(issue$x)
  })
  
  # returns a table of all courses fit with the couse number that the user
  #  asks for with information of the term, course number, course title,
  #  instructors and the average GPA. 
  output$quarter <- renderDataTable({
    if(input$course_number != ""){
      datatable(file %>% filter(str_detect(Course_Number, input$course_number)) %>% 
                  select(Term, Course_Number, Course_Title, Primary_Instructor,
                         Average_GPA),
                colnames = c("Term", "Course Number", "Course Title",
                             "Instructor", "Average GPA"),
                options = list(dom = 'ltipr'), rownames = FALSE)
    } else {
      datatable(file %>% select(Term, Course_Number, Course_Title,
                                Primary_Instructor, Average_GPA),
                colnames = c("Term", "Course Number", "Course Title",
                             "Instructor", "Average GPA"),
                options = list(dom = 'ltipr'), rownames = FALSE)
    }
  })
  # returns a sentence summary telling the user which quarter that the course
  #  they asked is offered
  output$offered <- renderPrint({
    class <- file %>% filter(str_detect(Course_Number, input$course_number)) %>%
      select(Term, Course_Number, Course_Title, Primary_Instructor, Average_GPA)
    if(input$course_number == "") {
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
  
  output$value <- renderPrint({
    input$prof_name
  })
  output$value <- renderPrint({
    input$classes
  })
  output$value <- renderPrint({
    input$students
  })
  # Shows a dataframe of all the classes a teacher has taught from the given
  # data set
  output$text <- renderDataTable({
    filter_frame <- condensded_frame[tolower(condensded_frame$Primary_Instructor)
                                     == tolower(input$prof_name), ]
    final_frame <- select(filter_frame, classes, quarter, Course_Title)
    datatable(final_frame, rownames = FALSE, options = list(dom = 'ltipr'))
  })
  # Shows a scatterplot showing the average GPA of a class inputted by the 
  # User each quarter.
  output$scatter <- renderPlot({
    filter_frame_classes <- filter(condensded_frame,
                                   classes == paste0(input$classes, " "))
    filter_frame_classes <- select(filter_frame_classes, Average_GPA, quarter)
    quarter_data <- ddply(filter_frame_classes, .(quarter), summarise,
                          Average_GPA=mean(Average_GPA))
    ggplot(data = as.data.frame(quarter_data), 
           aes(x = quarter, y = Average_GPA)) +
      geom_point() +
      ggtitle(input$classes) +
      labs(y = "Average GPA", x = "Quarter") +
      scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = .1))
    
  })
  # Returns a bar chart showing the number of students that take a 
  # class inputed by the user each quarter. 
  output$bar <- renderPlot({
    filter_frame_students <- filter(condensded_frame, classes ==
                                      paste0(input$students, " "))
    filter_frame_students <- select(filter_frame_students, Student_Count, quarter)
    students_data <- ddply(filter_frame_students, .(quarter), summarise,
                           Student_Count=sum(Student_Count))
    ggplot(data = students_data, 
           aes(x = students_data$quarter, y = students_data$Student_Count)) +
      geom_bar(stat = "Identity") +
      ggtitle(input$students) +
      labs(y = "Student Number", x = "Quarter") +
      scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = .1))      
  })
})
