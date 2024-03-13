# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load("results/air_split.rda")

set.seed(1234)

# basic recipe:
air_tree_recipe_basic <-  recipe(aqi_log10 ~ ., data = air_train) |> 
  step_mutate(data = as_date(date)) |> 
  step_date(date, features = "month") |> 
  step_rm(aqi, aqi_bucket) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) 

#step_impute but don't use linear, maybe median or mean, step mode for categorical variables

#prep<- air_recipe_basic  |> 
#  prep() |> 
#  bake(new_data = NULL)

save(air_recipe_basic, file = "results/air_recipe_basic.rda")


