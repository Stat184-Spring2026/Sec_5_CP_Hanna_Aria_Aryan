library(tidyverse)
library(readr)
library(stringr)

data <- read_tsv("ap.data.txt", show_col_types = FALSE)
series <- read_tsv("ap.series.txt", show_col_types = FALSE)
item <- read_tsv("ap.item.txt", show_col_types = FALSE)

ap_full <- data |>
  mutate(value = as.numeric(value)) |>
  left_join(series, by = "series_id") |>
  left_join(item, by = "item_code") |>
  mutate(
    month = as.numeric(str_remove(period, "M")),
    date = as.Date(paste(year, month, "01", sep = "-"))
  )

food_clean <- ap_full |>
  filter(!is.na(value), !is.na(date)) |>
  mutate(
    item_clean = case_when(
      str_detect(series_title, regex("^Eggs", ignore_case = TRUE)) ~ "Eggs",
      str_detect(series_title, regex("^Milk", ignore_case = TRUE)) ~ "Milk",
      str_detect(series_title, regex("^Bread", ignore_case = TRUE)) ~ "Bread",
      str_detect(series_title, regex("^Ground beef", ignore_case = TRUE)) ~ "Ground Beef",
      str_detect(series_title, regex("^Bananas", ignore_case = TRUE)) ~ "Bananas",
      TRUE ~ NA_character_
    )
  ) |>
  filter(!is.na(item_clean)) |>
  select(date, year, month, item_clean, value, series_id, series_title, item_name)

write_csv(food_clean, "clean_food_prices.csv")

nrow(food_clean)

food_clean |>
  count(item_clean)

ggplot(food_clean, aes(x = date, y = value, color = item_clean)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Average Prices of Selected Food Items Over Time",
    x = "Year",
    y = "Average Price (USD)",
    color = "Food Item"
  ) +
  theme_minimal()