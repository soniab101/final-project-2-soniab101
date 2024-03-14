# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load("results/air_split.rda")

set.seed(1234)

# basic recipe:
air_recipe_basic_en <-  recipe(aqi_log10 ~ ., data = air_train) |> 
  step_rm(aqi, aqi_bucket, date, date_month, date_year, city) |> 
 # step_impute_mode(all_nominal_predictors()) |> 
  step_impute_median(all_numeric_predictors()) |> 
 # step_dummy(all_nominal_predictors()) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) |> 
  step_corr(all_numeric_predictors(), 
            threshold = .5)



air_recipe_basic_en  |> 
  prep() |> 
  bake(new_data = NULL)

save(air_recipe_basic_en, file = "results/air_recipe_basic_en.rda")
