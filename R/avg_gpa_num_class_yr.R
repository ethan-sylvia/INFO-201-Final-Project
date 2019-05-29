course_data <- read.csv("UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv")
library(stringr)
library(dplyr)
#function returns the average gpa for a certain professor, per class and per year

avg_grade <- function(class_num, professor, year){
  course_data <- course_data %>% filter(Academic_Year == year) %>% filter(grepl(class_num, Course_Number)) %>% 
    filter(grepl(professor, Primary_Instructor))
  mean <- mean(course_data$Average_GPA)
  mean
}

test <- avg_grade("CSE 142", "REGES, STUART", "2013-14")