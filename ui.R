# Tal Wolman, Ben Weber, Ivan Trindev, Cooper Teixeira
# INFO 201 Final Project
# TA: Andrey Butenko
# Section AE
# March 8, 2019

library(shiny)
library(gridExtra)
library(plotly)
ui <- fluidPage(
  style = "border: 1px dashed red; padding: 20px 200px; font-family: verdana, helvetica neue; text-align: center",
  div(
    style = "
      text-align: center;
      color: red;
      font-family: courier new; 
      background: #6cba4c;
      border-radius: 10px;
      color: white;
      height: 60px;
      padding: 1px 0px 70px 0px;
      //border: 10px solid #65af48
    ",

    titlePanel("BIT-C")
  ),

  hr(style = "border: 2px solid #ddd; margin: 30px 0px"),
  h1("Money can't buy Happiness... Can it?"),
  div(
    # class = "span7",
    style = "padding-top: 0px",

    tabsetPanel(
      type = "pills",
      tabPanel("Home",
        style = "margin: auto",
        br(),
        h1("An Overview"),
        p(em("Tal Wolman, Ben Weber, Ivan Trindev, Cooper Teixeira")),
        p("We are analyzing two seperate data sets: a World Happiness Index and a World Bank Data. The World Happiness Index is a 
                  list of different aspects that are viewed to lead to happiness. These include life expectancy, freedom, generosity,
                  trust in the government, and dystopia residual (a comparison to an imaginary country with the lowest of each national average).
                  The scores in each of these criteria are then used to determine an overall happiness score for each country. We are then 
                  going to compare this data to World Bank information about median income, economic wealth, and other such financial data 
                  in order to ascertain if money can indeed lead to happiness."),
        br(),
        h2("Sources"),
        div(
          style = "overflow: hidden; white-space: nowrap; text-align: center;",
          a(href = "http://worldbank.org", "WorldBank |"),
          a(href = "http://worldhappiness.report/ed/2018/", " World Happiness Report |"),
          a(href = "https://github.com/datasets/gdp/blob/master/data/gdp.csv", " GitHub datasets - GDP")
        )
      ),

      tabPanel(
        "Economic Changes vs. Happiness",
        br(),
        h1("A Comparison of Economic Changes and Dramatic Shifts in Happiness"),
        p("We were first interested to see if there is any consistent relationship between countries
                              that experienced large changes in economic levels and in their overall happiness index. Use the widgets
                              below to manipulate the visualizations."),
        br(),
        h4("A Comparison of the Countries w/ Top Economic Changes (left) and Top Changes in Happiness (right)"),
        br(),
        div(
          style = "text-align: center; display: inline-block",
          sliderInput("countries",
            "Choose the # of Countries to Include",
            value = 5,
            min = 1,
            max = 10
          )
        ),
        p("Choose how many countries to include by using the slider above. The number that you choose will indicate how many countries
                 will be highlighted on both maps."),
        plotOutput("mapcomparison"),
        p("As can be seen in both maps, there is quite a bit of consistency between countries that have drastic changes in their economic
                 status and changes in their happiness index. As the slider is used, the map on the left and the right are nearly identical.
                 Using this alone is not a valid means of declaring that the two are directly associated, but it gives us good reason to 
                 investigate a possible relationship. This pattern is one that many people would likely anticipate given the frequent association
                 of financial status and happiness.")
      ),

      tabPanel(
        "Wealth vs. Happiness",
        br(),
        div(
          style = "text-align: center",
          h1("Relationship Between Countries' GDP Per Capita and Self-Reported Happiness Level"),
          br(),
          p("It is a widely-held belief that money tends to lead to happiness. For this project, we were able to 
                     analyze data for the world's economy as well as happiness levels, which allowed us to investigate
                     a possible relationship between wealth and happiness. The measuement of
                     wealth is the country's GDP per capita and the happiness level is a number out of 10 that 
                     represents how a sample of a country rated their overall happiness.")
        ),

        br(),

        div(
          style = "display: inline-block; vertical-align: top",
          checkboxGroupInput(
            inputId = "correl_years",
            label = "Choose Which Years to Show",
            choices = c("2015", "2016", "2017"),
            selected = "2015",
            inline = T
          )
        ),

        plotOutput("wealth_happy_correl"),

        br(),
        br(),

        p(
          style = "text-align: left",
          "We chose to visualize the relationship between wealth and happiness with a scatterplot. The x-axis
                 represents each country's GDP per capita and the y-axis represents the self-reported happiness of
                 the country. The colors of the points represent the geographic region the observation belongs to and 
                 the size of the point represents the population of the country. You can choose which years to view by
                 checking any combination of years from 2015 to 2017."
        ),

        br(),

        p("This graph illustrates a positive relationship between a country's wealth and its
                 reported happiness. Countries with a higher GDP per capita tend to report a higher happiness level.
                 You may also notice that many of the countries in the same regions tend to be close together
                 in terms of wealth and happiness. By selecting all years via the above checkboxes, you can more clearly
                 recognize this grouping of countries by the more densely-packed color in the graph.")
      ),

      tabPanel(
        "Income/GDP per Capita vs. Happiness",
        br(),
        h1("A comparison of Average Income & GDP Per Capita to Happiness Levels"),
        br(),
        p("One of the things that we were most interested in investigating involved testing the old saying 'Money can't buy you happiness.'
                          We wanted to test this when it comes to both personal wealth (Income) and national wealth (GDP per Capita). 
                          Use the widget below to investigate a relationship between income bracket and happiness 
                          or GDP per capita and happiness."),
        br(),

        div(
          style = "display: inline-block",
          checkboxGroupInput(
            inputId = "wealth_type",
            label = "Choose wealth type:",
            choices = c(
              "Income Bracket" = "in",
              "GDP per Capita Bracket" = "GDP"
            ),
            selected = "in"
          )
        ),

        plotOutput("wealth_graph"),

        p("We chose to visualize the relationship between income level/GDP per captia and happiness as a line graph. We chose to do it this way 
                          because despite the fact that the data is broken up into discrete brackets, the data within the brackets is continuous; 
                          within each bracket there is a continuous average income and/or conintuous GDP per capita. In this graph, the x-axis represents 
                          the bracket that the income/GDP per capita falls into (Low, Lower Middle, Upper Middle, or High). The y-axis represents the average 
                          happiness of for each bracket."),
        br(),
        p("As can be seen by the graph above, happiness increases with both income level and with GDP per capita. However, one very interesting things 
                          can be seen when the two are compared. The happiness levels for GDP per capita is lower than for income on the low/lower middle side, 
                          and higher on the higher middle/high side. This could potentially demonstrate that national wealth is more important when it comes to 
                          average happiness than personal wealth.")
      ),

      tabPanel(
        "Primary Component Analysis",
        h1("PCA of World Happiness Index and GDP"),
        p("This analysis will determine the feature of the data that accounts for the highest variance, or the \"Primary Component\".
                 This will hopefully give us an insight into what feature most impacts how wealthy a country is.
                 One of these features compares countries to the hypothetical state of Dystopia, which represents the lowest national averages for all features. 
                 Is there a relationship between dystopia and the wealth of a country?"),
        selectInput("pca_region", choices = c("World", "Europe & Central Asia", "North America", "East Asia & Pacific", "Middle East & North Africa", "Latin America & Caribbean", "Sub-Saharan Africa", "South Asia"), selected = "World", label = "Region"),
        br(),
        verbatimTextOutput("selected_country", placeholder = TRUE),
        plotlyOutput("pca_plot"),
        br(),
        verbatimTextOutput("summary"),
        p("This is a lot to take in, but we can unpack it. First, we see that in the entire world, PC1 (Comp. 1) accounts for about 48% of variability in the data set.
                 From this, we can conclude that all these variables are positively correlated in PC1.
                 We can also see that Happiness Score, Economy, Family, and Health are heavily loaded on PC1, meaning that there is likely some factor that makes these variables similar.
                 In other words, the above four scores produce the maximum variance in the data set.
                 Similarly, in PC2, we see Economy, Family, and Health are related, but not related to the other 4 features. This means there is a small possibility of an unknown variable affecting the first 3 positively and the rest negatively.")
      )
    )
  )
)
