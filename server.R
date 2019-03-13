# Tal Wolman, Ben Weber, Ivan Trindev, Cooper Teixeira
# INFO 201 Final Project
# TA: Andrey Butenko
# Section AE
# March 8, 2019

library(knitr)
library(jsonlite)
library(httr)
library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)
library(maps)
library(ggfortify)

source("analysis.R")

server <- function(input, output) {
  get_world_data_with_highlights <- function(regions_highlight) {
    map_data("world") %>%
      fortify() %>%
      mutate(highlight = ifelse(region %in% regions_highlight, 1, 0))
  }

  # Question 1
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
      geom_map(
        data = mapping_data,
        map = mapping_data,
        aes(x = long, y = lat, group = group, map_id = region, fill = highlight, color = "green")
      ) +
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
      geom_map(
        data = mapping_data,
        map = mapping_data,
        aes(x = long, y = lat, group = group, map_id = region, fill = highlight, color = "green")
      ) +
      theme(legend.position = "none")

    # arranging the maps side by side
    grid.arrange(economy_map, happiness_map, nrow = 1)
  })

  # Question 2

  output$wealth_happy_correl <- renderPlot({
    years <- input$correl_years
    point_size <- input$correl_point_size * .1
    plot <- ggplot(wealth_vs_happiness)

    if ("2015" %in% years) {
      plot <- plot + geom_point(aes(x = economy_2015, y = happiness_2015, color = region, size = pop_2015))
    }

    if ("2016" %in% years) {
      plot <- plot + geom_point(aes(x = economy_2016, y = happiness_2016, color = region, size = pop_2016))
    }

    if ("2017" %in% years) {
      plot <- plot + geom_point(aes(x = economy_2017, y = happiness_2017, color = region, size = pop_2017))
    }

    plot + ggtitle(paste0("Wealth vs. Happiness")) +
      labs(x = "Economy (GDP Per Capita)", y = "Happiness Score") +
      scale_color_discrete(name = "Regions") +
      scale_size_continuous(guide = F)
  })

  # Question 3
  output$wealth_graph <- renderPlot({

    # Get happiness data in baskets based on GDP per capita
    world_happiness_econ <- world_happiness_crucial_info %>%
      select(Score, Economy) %>%
      mutate(incomeLevel.value = cut(as.vector(world_happiness_crucial_info$Economy), 4)) %>%
      group_by(incomeLevel.value) %>%
      summarize(average_happiness = mean(Score)) %>%
      mutate(incomeLevel.value = c("Low", "Lower Middle", "Upper Middle", "High")) %>%
      mutate(group = "GDP per Capita")
    world_happiness_econ$incomeLevel.value <- factor(world_happiness_econ$incomeLevel.value, levels = c("Low", "Lower Middle", "Upper Middle", "High"))

    # Get average happiness by income level
    average_happiness_by_income_level <- average_happiness_by_income_level %>%
      mutate(group = "Income") %>%
      mutate(incomeLevel.value = c("Low", "Lower Middle", "Upper Middle", "High"))
    average_happiness_by_income_level$incomeLevel.value <- factor(average_happiness_by_income_level$incomeLevel.value, levels = c("Low", "Lower Middle", "Upper Middle", "High"))

    # Stack the two data frames
    income_and_econ <- rbind(average_happiness_by_income_level, world_happiness_econ)

    # base plot if nothing selected
    plot <- plot <- ggplot(income_and_econ) + ggtitle("") +
      labs(
        title = "GDP per Capita vs. Happiness",
        x = "GDP per Capita Bracket",
        y = "Average Happiness"
      )

    wealth <- input$wealth_type

    if (length(wealth) == 1 & "in" %in% wealth) {
      plot <- ggplot(data = average_happiness_by_income_level, aes(x = incomeLevel.value, y = average_happiness, group = group)) +
        geom_point() + geom_line() +
        labs(
          title = "Income Bracket vs. Happiness",
          x = "Income Bracket",
          y = "Average Happiness"
        )
    } else if (length(wealth) == 1 & "GDP" %in% wealth) {
      plot <- ggplot(data = world_happiness_econ, aes(x = incomeLevel.value, y = average_happiness, group = group)) +
        geom_point() + geom_line() +
        labs(
          title = "GDP per Capita vs. Happiness",
          x = "GDP per Capita Bracket",
          y = "Average Happiness"
        )
    } else if (length(wealth) == 2) {
      plot <- ggplot(data = income_and_econ, aes(x = incomeLevel.value, y = average_happiness, color = group, group = group)) +
        geom_point() + geom_line() +
        labs(
          title = "Income Bracket & GDP per Capita vs. Happiness",
          color = "Wealth Type",
          x = "Income/GDP per Capita Bracket",
          y = "Average Happiness"
        )
    }

    # return plot
    plot
  })

  # Question 4
  # PCA
  output$pca_plot <- renderPlotly({
    df <- df_for_region(input$pca_region)
    p <- autoplot(pca_for_region(input$pca_region),
      data = df, colour = "Score", loadings.label = TRUE, loadings = TRUE,
      loadings.label.size = 2, loadings.colour = "blue",
      label.size = 1
    ) + ggtitle("Principal Component Analysis")
    ggplotly(p)
  })

  output$summary <- renderPrint({
    pca <- pca_for_region(input$pca_region)
    print(pca$loadings)
    summary(pca)
  })

  output$selected_country <- renderPrint({
    e <- event_data("plotly_hover")
    req(e) # dont do anything if nothing has been clicked
    df <- df_for_region(input$pca_region)
    cat(paste("Currently hovering:", df[e$pointNumber, ] %>% select(CountryName)))
  })
}
