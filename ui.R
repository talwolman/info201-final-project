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
                
                 tabPanel("Economic Changes vs. Happiness",
                          h1("A Comparison of Economic Changes and Dramatic Shifts in Happiness"),
                          p("We were first interested to see if there is any consistent relationship between countries
                            that experienced large changes in economic levels and in their overall happiness index. Use the widgets
                            below to manipulate the visualizations."),
                          br(), 
                          sliderInput("countries", 
                                      "Choose the # of Countries to Include",
                                      value = 5,
                                      min = 1,
                                      max = 10),
                          plotOutput("map1"),
                          plotOutput("map2"),
                          p("a GOOD and GRAMMATICALLY CORRECT description of your plot"),
                          p("make sure you format and explain what can be done w the widgets")
                          ),
                
                 tabPanel("Ben", 
                          h1("Title of Page"),
                          p("an introduction to the question you are asking"),
                          # insert your plot call here
                          # insert the widgets you will need 
                          p("a GOOD and GRAMMATICALLY CORRECT description of your plot"),
                          p("make sure you format and explain what can be done w the widgets")
                          ),
                
                 tabPanel("Ivan", 
                          h1("Title of Page"),
                          p("an introduction to the question you are asking"),
                          # insert your plot call here
                          # insert the widgets you will need 
                          p("a GOOD and GRAMMATICALLY CORRECT description of your plot"),
                          p("make sure you format and explain what can be done w the widgets")
                          ),
                
                 tabPanel("Cooper", 
                          h1("Title of Page"),
                          p("an introduction to the question you are asking"),
                          # insert your plot call here
                          # insert the widgets you will need 
                          p("a GOOD and GRAMMATICALLY CORRECT description of your plot"),
                          p("make sure you format and explain what can be done w the widgets")
                          )
                 )
  )
)