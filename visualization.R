ggplot(food_clean, aes(x = date, y = value, color = item_clean)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Average Prices of Selected Food Items Over Time",
    x = "Year",
    y = "Average Price (USD)",
    color = "Food Item"
  ) +
  theme_minimal()