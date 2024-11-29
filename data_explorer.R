library(tidyverse)

java_island_mounts <- read_delim(
  "java_island_mounts.csv", 
  delim = ";", escape_double = FALSE, trim_ws = TRUE
)
java_island_mounts <- java_island_mounts |> 
  mutate(
    elevation = ifelse(
      height_m <= 1000, "Low",
      ifelse(
        height_m > 1000 & height_m <= 2000, "Moderately Low",
        ifelse(
          height_m > 2000 & height_m <= 3000, "Moderately High",
          "High"
        )
      )
    )
  ) |> 
  arrange(height_m, .by_group = TRUE)

java_island_mounts |> 
  group_by(province) |> 
  summarise(
    n = n(),
    min = min(height_m, na.rm = TRUE),
    max = max(height_m, na.rm = TRUE)
  )

