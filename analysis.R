# Tal Wolman, Ben Weber, Ivan Trindev, Cooper Teixeira
# INFO 201 Final Project
# TA: Andrey Butenko 
# Section AE
# March 8, 2019 

library(dplyr)
library(knitr)
library(jsonlite)
library(httr)

# read and process csv file for happiness data
world_happiness_data <- read.csv(file = "Data/2017.csv", stringsAsFactors = FALSE)
filtered_world_happiness_data <- select(world_happiness_data, Country, Happiness.Rank, Happiness.Score, Economy..GDP.per.Capita.) %>%
  filter(Happiness.Score > 7)
happiness_col_names <- c("Country Name", "Happiness Rank", "Happiness Score", "Economy")
colnames(filtered_world_happiness_data) <- happiness_col_names

# read and process data from World Bank by fetching from API
base_uri <- "http://api.worldbank.org/v2/"
response <- GET(paste0(base_uri, "country"), query = list("format" = "json", "per_page" = "350"))
response_information <- content(response, "text")
parsed_body_information <- fromJSON(response_information)
data_for_world <- flatten(parsed_body_information[[2]]) %>% filter(!grepl("Aggregates", region.value))
filtered_data_for_europe_central_asia <- select(data_for_world, id, name, region.value, incomeLevel.value) %>%
  filter(region.value == "Europe & Central Asia")
europe_asia_col_names <- c("ID", "Country Name", "Region Name", "Income Level")
colnames(filtered_data_for_europe_central_asia) <- europe_asia_col_names


# Change colnames in data set
world_happiness_crucial_col_names <- c("Country", "Score", "Economy", "Family", "Health", "Freedom", "Generosity", "Gov.Trust")
colnames(world_happiness_crucial_info) <- world_happiness_crucial_col_names

# Create summary for crucial world happiness information
world_happiness_summary <- summary(world_happiness_crucial_info %>% select(-Country))

# Create a numeric representation of the income levels of countries
data_for_world_ex <- data_for_world %>% mutate(income_as_numeric = ifelse(grepl("HIC", incomeLevel.id), "6",
  ifelse(grepl("UMC", incomeLevel.id), 5,
    ifelse(grepl("MIC", incomeLevel.id), 4,
      ifelse(grepl("LMC", incomeLevel.id), 3,
        ifelse(grepl("LMY", incomeLevel.id), 2,
          ifelse(grepl("LIC", incomeLevel.id), 1, NA)
        )
      )
    )
  )
))
data_for_world_ex$income_as_numeric <- as.numeric(data_for_world_ex$income_as_numeric)
world_income_summary <- summary(data_for_world_ex %>% select(income_as_numeric) %>% na.omit())

# Join the happiness data and income data by country name
joined_data <- left_join(data_for_world_ex, world_happiness_crucial_info, by = c("name" = "Country")) %>% na.omit()

# Find the saddest country that is in the high income level bracket
saddest_rich_country <- joined_data %>% filter(income_as_numeric == 6) %>% filter(Score == min(Score)) %>% select(name)

# Arrange the data by which countries have the largest difference in their income level and happiness score
arranged_data <- joined_data %>% mutate(income_happiness_diff = income_as_numeric - Score) %>% arrange(desc(income_happiness_diff))

# Group data by income level and find average happiness score
average_happiness_by_income_level <- joined_data %>%
  group_by(incomeLevel.value) %>%
  summarize(average_happiness = mean(Score)) %>%
  arrange(average_happiness)

# Find the average happiness level and income level for each region
average_happiness_income_by_region <- joined_data %>%
  group_by(region.value) %>%
  summarize(
    average_happiness = mean(Score),
    average_income = mean(income_as_numeric)
  ) %>%
  arrange(average_income)

# Join the 2015 and 2017 happiness data
world_happiness_data_2015 <- read.csv(file = "Data/2015.csv", stringsAsFactors = FALSE)
world_happiness_2015_2017 <- left_join(world_happiness_data_2015, world_happiness_data, by = "Country")

# Find the difference in economy and happiness in the two years
world_happiness_2015_2017 <- world_happiness_2015_2017 %>%
  select(Country, Happiness.Score.x, Economy..GDP.per.Capita..x, Happiness.Score.y, Economy..GDP.per.Capita..y) %>%
  mutate(
    Happiness_change = Happiness.Score.y - Happiness.Score.x,
    Economy_change = Economy..GDP.per.Capita..y - Economy..GDP.per.Capita..x
  )

# Find the top 5 countries with largest happiness change
largest_happiness_change <- world_happiness_2015_2017 %>%
  arrange(abs(Happiness_change)) %>%
  top_n(5) %>%
  select(Country) %>%
  as.vector()

# Find the top 5 countries with largest economic change
largest_economy_change <- world_happiness_2015_2017 %>%
  arrange(abs(Economy_change)) %>%
  top_n(5) %>%
  select(Country) %>%
  as.vector()
