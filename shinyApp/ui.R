library(shiny)
library(dplyr)
library(markdown)
library(stringr)
library(DT)
library(ggplot2)

file <- read.delim("UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv", sep = ",", stringsAsFactors = F)
shinyUI(navbarPage("UW Class Navigation",
                   theme = "style.css",
  # gneral infomation of data and the team 
  tabPanel("Overview",
           img(src="logo.jpg", alt="logo",align = "right"),
           sidebarLayout(
             sidebarPanel(
               uiOutput("about")
           ),
           mainPanel(
             uiOutput("md")
           )
  )),
  # tabs that return a table of the given course and tells which quarter the course is offered 
  tabPanel("Find Quarter",
           img(src="logo.jpg", alt="logo",align = "right"),
           div(class = "label",
               textInput("course_number", label = "Please Type In the Course Number in Capital Letter (ie:MATH 126)",
                         value = "")
           ),
           textOutput("offered"),
           br(),
           dataTableOutput("quarter")
  ),
  # tabs that return a table of courses that the given professor taught in past years 
  tabPanel("Professor Teaching History",
           img(src="logo.jpg", alt="logo",align = "right"),
           sidebarLayout(
             div(class = "label",
                 textInput(
                 "prof_name",
                     label = "Enter Teacher Name Format: 
                              Last Name, First Name,
                              Middle Name Initials (If Applicable)"
                 )
             ),
             mainPanel(
               dataTableOutput("text")
             )
           )
  ),
  # tabs return the scatter plot of GPA of the given course
  tabPanel("Average GPA ScatterPlot",
           img(src="logo.jpg", alt="logo",align = "right"),
           sidebarLayout(
             div(class = "label",
                 textInput(
                 "classes", 
                 label = "Enter Class in Capital Letters (ie:MATH 126)"
                 )
             ),
             mainPanel(
               plotOutput("scatter")
             )
           )
  ),
  # tabs that return the number of students enrolled in the given course in different quarters
  tabPanel("Course Student Count",
           img(src="logo.jpg", alt="logo",align = "right"),
           sidebarLayout(
             div(class = "label",
               textInput(
                 "students", 
                 label = "Student Count: Enter Class in Capital Letter (ie:MATH 126)"
             )),
             mainPanel(
               plotOutput("bar")
             )
           )
  ),  
  # tabs that return a line plot of average GPA of all courses based on the user's selection 
  tabPanel("GPA Overview", 
           img(src="logo.jpg", alt="logo",align = "right"),
           sidebarPanel(
             selectInput("course_lvl", label = "Select the course level",
                         choice = c("100", "200", "300", "400", "500")
                         
             ),
             selectInput("quarter_lvl", label = "Select the quarter", 
                         choice = c("Autumn", "Winter", "Spring", "Summer")
             ),
             textInput("course_name", label = h5("Enter the major abbreviation"), value = "A A"),
             hr()
           ),
           mainPanel(textOutput('Issue'), plotOutput("GPA_plot"))
  )
))

