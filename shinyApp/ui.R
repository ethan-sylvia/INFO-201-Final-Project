#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#library(markdown)
library(shiny)
library(dplyr)
library(stringr)
library(DT)
library(ggplot2)

file <- read.delim("../UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv", sep = ",", stringsAsFactors = F)

shinyUI(navbarPage("UW class search",
  tabPanel("Overview",
    sidebarLayout(
      sidebarPanel(
        
      ),
      mainPanel(
        textOutput("info")
      )
    )
  ),
  tabPanel("find quarter",
    textInput("text", label = "Please Type In The Course Number", value = ""),
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
