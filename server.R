# Tal Wolman, Ben Weber, Ivan Trindev, Cooper Teixeira
# INFO 201 Final Project
# TA: Andrey Butenko 
# Section AE
# March 8, 2019 

library("knitr")
library("jsonlite")
library("httr")
library("shiny")
library("ggplot2")
library("dplyr")
library("tidyr")
library("maps")

source("analysis.R")

server <- function(input, output) {
  # please comment on your code so we know what code corresponds to what problem!! 
  # thank you! 
  
  get_world_data_with_highlights <- function(regions_highlight) {
    map_data('world') %>% 
      fortify() %>% 
      mutate(highlight = ifelse(region %in% regions_highlight, 1, 0))
  }
  
  # Tal - add description of code 
  output$mapcomparison <- renderPlot({
    # economy map filtering
    largest_economy_change <- world_happiness_2015_2017 %>%
      arrange(abs(Economy_change)) %>%
      top_n(input$countries) %>%
      select(Country)
    
    largest_economy_change <- unlist(largest_economy_change)
    
    mapping_data <- get_world_data_with_highlights(largest_economy_change)
    
    # economy map generation 
    economy_map <- ggplot() +
      geom_map(data = mapping_data,
               map = mapping_data,
               aes(x = long, y = lat, group = group, map_id = region, fill = highlight, color = "green")) +
      theme(legend.position = "none") 
    
    # happiness map filtering 
    largest_happiness_change <- world_happiness_2015_2017 %>%
      arrange(abs(Happiness_change)) %>%
      top_n(input$countries) %>%
      select(Country) 
    
    largest_happiness_change <- unlist(largest_happiness_change)
    
    mapping_data <- get_world_data_with_highlights(largest_happiness_change)
    
    # happiness map generation
    happiness_map <- ggplot() +
      geom_map(data = mapping_data,
               map = mapping_data,
               aes(x = long, y = lat, group = group, map_id = region, fill = highlight, color = "green")) +
      theme(legend.position = "none") 
    
    # arranging the maps side by side 
    grid.arrange(economy_map, happiness_map, nrow = 1)
  })
  
  # Ben - add description of code 
  # add code here and delete this comment
  
  # Ivan - add description of code 
  # add code here and delete this comment
  
  # Cooper - add description of code 
  # add code here and delete this comment
}