# Tal Wolman, Ben Weber, Ivan Trindev, Cooper Teixeira
# INFO 201 Final Project
# TA: Andrey Butenko 
# Section AE
# March 8, 2019 

library("shiny")

ui <- fluidPage(
  titlePanel("Title of Project"),
  
  mainPanel(
    tabsetPanel(type = "tabs",
                 # CHANGE THE NAME OF YOUR TAB TO BE ABOUT YOUR TOPIC!!!!! 
                 tabPanel("Home",
                          h1("Title of Page"),
                          p("Tal Wolman, Ben Weber, Ivan Trindev, Cooper Teixeira"),
                          p("a GOOD and GRAMMATICALLY CORRECT description of our project")
                          ),
                
                 tabPanel("Tal",
                          h1("Title of Page"),
                          p("an introduction to the question you are asking"),
                          # insert your plot call here
                          # insert and widgets you will need 
                          p("a GOOD and GRAMMATICALLY CORRECT description of your plot"),
                          p("make sure you format and explain what can be done w the widgets")
                          ),
                
                 tabPanel("Ben", 
                          h1("Title of Page"),
                          p("an introduction to the question you are asking"),
                          # insert your plot call here
                          # insert and widgets you will need 
                          p("a GOOD and GRAMMATICALLY CORRECT description of your plot"),
                          p("make sure you format and explain what can be done w the widgets")
                          ),
                
                 tabPanel("Ivan", 
                          h1("Title of Page"),
                          p("an introduction to the question you are asking"),
                          # insert your plot call here
                          # insert and widgets you will need 
                          p("a GOOD and GRAMMATICALLY CORRECT description of your plot"),
                          p("make sure you format and explain what can be done w the widgets")
                          ),
                
                 tabPanel("Cooper", 
                          h1("Title of Page"),
                          p("an introduction to the question you are asking"),
                          # insert your plot call here
                          # insert and widgets you will need 
                          p("a GOOD and GRAMMATICALLY CORRECT description of your plot"),
                          p("make sure you format and explain what can be done w the widgets")
                          )
                 
                 )
  
    
  )
)