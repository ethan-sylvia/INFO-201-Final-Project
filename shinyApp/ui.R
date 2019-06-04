library(shiny)
library(dplyr)
library(markdown)

file <- read.csv("../UW-Seattle_20110-20161-Course-Grade-Data_2016-04-06.csv")
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
  tabPanel("GPA"

            ),
  tabPanel("professor"
           
  )
))
