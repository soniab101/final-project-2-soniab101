# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

set.seed(1234)

load(here("results/null_fit.rda"))

null_fit_metrics <- null_fit |> 
  collect_metrics() |> 
  mutate(model = "null")