library(shiny)
library(dplyr)
<<<<<<< HEAD
library(stringr)
library(DT)
library(ggplot2)

file <- read.delim("../UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv", sep = ",", stringsAsFactors = F)
=======
library(markdown)
>>>>>>> 2d55e4898ecb1222544869e099d8766c347356b9

shinyUI(navbarPage("UW class search",
  theme = "style.css", 
  tabPanel("Overview",
    sidebarLayout(
      sidebarPanel(
        uiOutput("about")
      ),
    mainPanel(
      uiOutput("md")
    )
  )
  ),
  tabPanel("find quarter",
    img(src="logo.jpg", alt="logo",align = "right"),
    div(class = "label",
      textInput("text", label = "Please Type In The Course Number", value = "")
    ),
    textOutput("offered"),
    br(),
    dataTableOutput("quarter")
  ),
  
  tabPanel("GPA Overview", 
    sidebarPanel(
        selectInput("course_lvl", label = "Select the course level",
                    choice = c("100", "200", "300", "400", "500")
                         
        ),
        
        selectInput("quarter_lvl", label = "Select the quarter", 
                    choice = c("Autumn", "Winter", "Spring", "Summer")
                    ),
             
        textInput("course_name", label = h5("Enter the major abbreviation"), value = "A A"),
             
        hr(),
        fluidRow(column(3, verbatimTextOutput("value")))
  ),
  mainPanel(plotOutput("GPA_plot"))
  ),
  
  tabPanel("professor"
           
  )
))
