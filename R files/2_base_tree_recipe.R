# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load("results/air_split.rda")

set.seed(1234)

# basic recipe:
air_recipe_base_tree <-  recipe(aqi_log10 ~ ., data = air_train) |> 
  step_mutate(
              date_year = factor(date_year)) |> 
  step_rm(aqi, aqi_bucket, date) |> 
  step_impute_mode(all_nominal_predictors()) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) 


 #air_recipe_base_tree  |> 
 # prep() |> 
 # bake(new_data = NULL)

save(air_recipe_base_tree, file = "results/air_recipe_base_tree.rda")


