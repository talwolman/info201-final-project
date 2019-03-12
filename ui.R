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
               h1("An Overview:"),
               p("Tal Wolman, Ben Weber, Ivan Trindev, Cooper Teixeira"),
               p("We are analyzing two seperate data sets: a World Happiness Index and a World Bank Data. The World Happiness Index is a 
                  list of different aspects that are viewed to lead to happiness. These include life expectancy, freedom, generosity,
                  trust in the government, and dystopia residual (a comparison to an imaginary country of the world’s least happy people).
                  The scores in each of these criteria are then used to determine an overall happiness score for each country. We are then 
                  going to compare this data to World Bank information about median income, economic wealth, and other such financial data 
                  in order to ascertain if money can indeed lead to happiness."),
               br(),
               p("will come back here")
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
                
      tabPanel("Wealth vs. Happiness", 
               h1("Relationship Between Countries' GDP Per Capita and Self-Reported Happiness Level"),
               p("an introduction to the question you are asking"),
               
               
               # insert your plot call here
               # insert the widgets you will need 
       
               checkboxGroupInput(
                   inputId = "correl_years",
                   label = "Choose Which Years to Show",
                   choices = c("2015", "2016", "2017"),
                   selected = "2015",
                   inline = T
               ),
               
               sliderInput(
                   inputId = "correl_point_size",
                   label = "Data Point Size",
                   min = 1,
                   max = 10,
                   value = 2
               ),
               
               plotOutput("wealth_happy_correl"),
               
               p("a GOOD and GRAMMATICALLY CORRECT description of your plot"),
               p("make sure you format and explain what can be done w the widgets")
      ),
                
      tabPanel("Income/GDP per Capita vs. Happiness", 
               h1("A comparison of Average Income & GDP Per Capita to Happiness Levels"),
               p("One of the things that we were most interested in investigating involved testing the old saying 'Money can't buy you happiness.'
                          We wanted to test this when it comes to both personal wealth (Income) and national wealth (GDP per Capita). 
                          Use the widget below to chose whether you want to see a comparison between income bracket and happiness 
                          or GDP per capita and happiness."),
               br(),
               checkboxGroupInput(inputId = "wealth_type",
                                  label = "Choose wealth type:",
                                  choices = c("Income Bracket" = "in",
                                              "GDP per Capita Bracket" = "GDP")),
               plotOutput("wealth_graph"),
               # insert the widgets you will need 
               p("The above graph is set up as a line graph because despite the fact that the data is broken up into discrete brackets, 
                          the data within the brackets is continuous; within each bracket there is a continuous average income and/or conintuous 
                          GDP per capita. As can be seen by the graph above, happiness increases with both income level and with GDP per capita. However, 
                          one very interesting things can be seen when the two are compared. The happiness levels for GDP per capita is lower than for 
                          income on the low/lower middle side, and higher on the higher middle/high side. This could potentially demonstrate that national 
                          wealth is more important when it comes to average happiness than personal wealth.")
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