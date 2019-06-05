library(shiny)
library(dplyr)
library(markdown)
library(stringr)
library(DT)
library(ggplot2)

file <- read.delim("UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv", sep = ",", stringsAsFactors = F)
shinyUI(navbarPage("UW Class Navigation",
                   theme = "style.css",
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
  tabPanel("Professor Teaching History",
           img(src="logo.jpg", alt="logo",align = "right"),
           sidebarLayout(
             sidebarPanel(
               textInput(
                 "prof_name", 
                 label = h4("Enter Teacher Name Format: Last Name, First Name,
                            Middle Name Initials (If Applicable)") 
               )
             ),
             mainPanel(
               dataTableOutput("text")
             )
           )
  ),
  tabPanel("Average GPA ScatterPlot",
           img(src="logo.jpg", alt="logo",align = "right"),
           sidebarLayout(
             sidebarPanel(
               textInput(
                 "classes", 
                 label = h3("Enter Class")
               )
             ),
             mainPanel(
               plotOutput("scatter")
             )
           )
  ),
  tabPanel("Course Student Count",
           img(src="logo.jpg", alt="logo",align = "right"),
           sidebarLayout(
             sidebarPanel(
               textInput(
                 "students", 
                 label = h3("Enter Class (Student Count)")
               )
             ),
             mainPanel(
               plotOutput("bar")
             )
           )
  ),  
  tabPanel("Find Quarter",
    img(src="logo.jpg", alt="logo",align = "right"),
    div(class = "label",
      textInput("course_number", label = "Please Type In The Course Number (ie:MATH 126)",
                value = "")
    ),
    textOutput("offered"),
    br(),
    dataTableOutput("quarter")
  ),
  
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

