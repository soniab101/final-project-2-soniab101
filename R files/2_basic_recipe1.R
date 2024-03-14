# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load("results/air_split.rda")

set.seed(1234)

# basic recipe:


air_recipe_basic1 <-  recipe(aqi_log10 ~ ., data = air_train) |>
  
  step_mutate(
              season = case_when(
                date_month == 12 | (date_month >= 1 & date_month <= 4) ~ "winter",
                date_month >= 5 & date_month <= 7 ~ "summer",
                date_month == 8 | date_month == 9 ~ "monsoon",
                date_month >= 10 & date_month <= 12 ~ "post-monsoon"), 
              season = factor(season)) |>
  step_rm(aqi, aqi_bucket, date,city,date_year, date_month) |> 
 # step_other(city, threshold = 1000) |> 
  step_impute_mode(all_nominal_predictors()) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) 
 


air_recipe_basic  |> 
  prep() |> 
  bake(new_data = NULL) |> 
  skimr::skim_without_charts()

save(air_recipe_basic1, file = "results/air_recipe_basic1.rda")


