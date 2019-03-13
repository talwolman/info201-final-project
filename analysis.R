# Tal Wolman, Ben Weber, Ivan Trindev, Cooper Teixeira
# INFO 201 Final Project
# TA: Andrey Butenko
# Section AE
# March 8, 2019

library(dplyr)
library(maps)
library(tidyr)
library(knitr)
library(jsonlite)
library(httr)
library(tibble)

###############
## Section 2 ##
###############

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

###############
## Section 3 ##
###############

# Get crucial information from the world happiness data set
world_happiness_crucial_info <- world_happiness_data %>%
  select(
    Country, Happiness.Score, Economy..GDP.per.Capita., Family, Health..Life.Expectancy.,
    Freedom, Generosity, Trust..Government.Corruption.
  )

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

# select and rename necessary columns for 2015 happiness data
happiness_2015 <- read.csv("data/2015.csv", stringsAsFactors = F) %>%
  select(Country, Region, Happiness.Score, Economy..GDP.per.Capita.)
cols_2015 <- c("country", "region", "happiness_2015", "economy_2015")
colnames(happiness_2015) <- cols_2015

# select and rename necessary columns for 2016 happiness data
happiness_2016 <- read.csv("data/2016.csv", stringsAsFactors = F) %>%
  select(Country, Happiness.Score, Economy..GDP.per.Capita.)
cols_2016 <- c("country", "happiness_2016", "economy_2016")
colnames(happiness_2016) <- cols_2016

# select and rename necessary columns for 2017 happiness data
happiness_2017 <- read.csv("data/2017.csv", stringsAsFactors = F) %>%
  select(Country, Happiness.Score, Economy..GDP.per.Capita.)
cols_2017 <- c("country", "happiness_2017", "economy_2017")
colnames(happiness_2017) <- cols_2017

# join data for 2015, 2016, and 2017
wealth_vs_happiness <- left_join(happiness_2015, happiness_2016, by = "country")
wealth_vs_happiness <- left_join(wealth_vs_happiness, happiness_2017, by = "country")

# load and rename world population data
pop_data <- read.csv("data/world_pop.csv", stringsAsFactors = F, fileEncoding = "UTF-8-BOM") %>%
  select(Country.Name, X2015, X2016, X2017)
new_pop_cols <- c("country", "pop_2015", "pop_2016", "pop_2017")
colnames(pop_data) <- new_pop_cols

# join population data to wealth and happiness data
wealth_vs_happiness <- left_join(wealth_vs_happiness, pop_data, by = "country")


# read gdp data table and condense
gdp_data <- read.csv(file = "data/gdp.csv", stringsAsFactors = FALSE) %>%
  spread(key = Year, value = Value) %>%
  select(CountryName, CountryCode, "2016") %>%
  na.omit()

# add iso3 codes
with_iso3 <- world_happiness_crucial_info %>% mutate(iso3 = if_else(Country == "United States", "USA", # irregular naming
  if_else(Country == "United Kingdom", "GBR", # irregular naming
    iso.alpha(n = 3, x = world_happiness_crucial_info$Country)
  )
))


joined_with_gdp <- left_join(with_iso3[-1], gdp_data, by = c("iso3" = "CountryCode")) %>%
  na.omit() %>%
  rename(gdp2016 = "2016") %>%
  left_join(joined_data %>% select(id, region.value), by = c("iso3" = "id"))

# calculate pca for given region. use 'World' for all
pca_for_region <- function(region) {
  res <- ""
  df <- column_to_rownames(joined_with_gdp %>% filter(iso3 != "NER"), var = "CountryName") # nigeria has a duplicate. no idea why
  if (region == "World") {
    res <- princomp(df %>% select(-iso3, -region.value), cor = TRUE)
  } else {
    res <- princomp(df %>% filter(iso3 != "NER") %>% filter(region.value == region) %>% select(-iso3, -gdp2016, -region.value), cor = TRUE)
  }
  res
}
df_for_region <- function(region) {
  res <- ""
  if (region == "World") {
    res <- joined_with_gdp %>% filter(iso3 != "NER") %>% select(-iso3, -region.value)
  } else {
    res <- joined_with_gdp %>% filter(iso3 != "NER") %>% filter(region.value == region) %>% select(-iso3, -region.value)
  }
  res
}
