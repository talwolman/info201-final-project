# Tal Wolman, Ben Weber, Ivan Trindev, Cooper Teixeira
# INFO 201 Final Project
# TA: Andrey Butenko 
# Section AE
# March 8, 2019 

library("shiny")
library("gridExtra")

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
               h4("A Comparison of the Countries w/ Top Economic Changes (left) and Top Changes in Happiness (right)"), 
               sliderInput("countries", 
                           "Choose the # of Countries to Include",
                           value = 5,
                           min = 1,
                           max = 10),
               p("choose how many countries to include by using the slider above. The number that you choose will indicate how many countries
                 will be highlighted on both maps."),
               plotOutput("mapcomparison"),
               p("As can be seen in the maps, there is quite a bit of consistency between countries that have drastic changes in their economic
                 status and changes in their happiness index. As the slider is used, the map on the left and the right are nearly identical.
                 Using this alone is not a valid means of declaring that the two are directly associated, but it gives us good reason to 
                 investigate a possible relationship. This pattern is one that many people would likely anticipate given that associating
                 doing well and happiness is common.")
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