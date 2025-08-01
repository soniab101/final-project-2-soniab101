# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load("results/air_split.rda")

set.seed(1234)

# basic recipe:
air_recipe_basic_lm <-  recipe(aqi_log10 ~ ., data = air_train) |> 
  step_mutate(date_month = month(date)) |> 
  step_rm(aqi, aqi_bucket, date) |> 
  step_impute_mode(all_nominal_predictors()) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) 


prep<- air_recipe_basic_lm  |> 
  prep() |> 
  bake(new_data = NULL)

save(air_recipe_basic_lm, file = "results/air_recipe_basic_lm.rda")