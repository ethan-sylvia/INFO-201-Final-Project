library(shiny)


my.ui <- fluidPage(
  
  titlePanel("Final Scripts"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      textInput(
        "prof_name", 
        label = h4("Enter Teacher Name Format: Last Name, First Name, Middle Name Initials (If Applicable)"), 

      ),
      textInput(
        "classes", 
        label = h3("Enter Class (Average GPA)"),
        
      ),
      textInput(
        "students", 
        label = h3("Enter Class (Student Count)")
      )

      
    ),
    mainPanel(
      plotOutput("scatter"),
      plotOutput("bar"),
      textOutput("text")
    )
  )
  

    
    
)
    
  
