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

file <- read.csv("../UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv")
shinyUI(navbarPage("UW class search",
  theme = "style.css", 
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
    img(src="logo.jpg", alt="logo",align = "right"),
    textInput("text", label = "Please Type In The Course Number", value = ""),
    textOutput("offered"),
    br(),
    dataTableOutput("quarter")
  ),
  tabPanel("GPA"

            ),
  tabPanel("professor"
           
  )
))
