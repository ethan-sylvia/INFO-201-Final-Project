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

file <- read.csv("../UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv")
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
    dataTableOutput("quarter")
  ),
  tabPanel("GPA"

            ),
  tabPanel("professor"
           
  )
))