library(dplyr)
library(stringr)
file <- read.csv("../UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv")
offered_quarter <- function(name){
  class <- file %>% filter(str_detect(Course_Number, name))
  if (nrow(class) == 0) {
    return("Course not found")
  } else {
    class <- class %>% select(Term, Course_Number, Course_Title, Primary_Instructor, Average_GPA)
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
    print(time)
    return(class)
  }
}
