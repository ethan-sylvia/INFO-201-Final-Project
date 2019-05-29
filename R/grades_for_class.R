grades <- read.csv("UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv")
my_function <- function (course_id) {
  class_grades <- grades[grep(course_id, grades$Course_Number),]
  print(dim(class_grades))
  if (length(class_grades) == 0) {
    return("Course not found")
  } else {
    return_phrase <- paste0("The mean grade is ",mean(class_grades$Average_GPA)," The median grade is "
                            ,median(class_grades$Average_GPA)," the minimum grade is ",
                            min(class_grades$Average_GPA)," and the highest grade is ",max(class_grades$Average_GPA))
    return(return_phrase)
  }
}

  
