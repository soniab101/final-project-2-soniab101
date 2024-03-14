# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(naniar)

# handle common conflicts
tidymodels_prefer()

set.seed(1234)

air_data <- read_csv(here("data/city_day.csv"))

# ccomplexity/targ var analysis
miss_var_summary(air_data)

miss_var_plot <- gg_miss_var(air_data)

save(miss_var_plot, file = here("results/miss_var_plot.rda"))
