# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load("results/air_split.rda")

set.seed(1234)

# mutate for dates , mode for nominal med for numeric


# more advanced recipe
air_recipe_adv <- recipe(aqi_log10 ~ ., data = air_train) |> 
  step_mutate(date_month = month(date),
              date_year = year(date),
              date_year = factor(date_year),
              date_month = month(date),
              season = case_when(
                date_month == 12 | (date_month >= 1 & date_month <= 4) ~ "winter",
                date_month >= 5 & date_month <= 7 ~ "summer",
                date_month == 8 | date_month == 9 ~ "monsoon",
                date_month >= 10 & date_month <= 12 ~ "post-monsoon"),
              season = factor(season)) |> 
  step_rm(aqi, aqi_bucket, date) |> 
  step_impute_mode(all_nominal_predictors()) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_interact(terms = ~ c(season_post.monsoon, season_summer, season_winter):no2) |> 
  step_interact(terms = ~pm2_5:pm10) |> 
  step_interact(terms = ~ c(season_post.monsoon, season_summer, season_winter):o3) |> 
 # step_interact(terms = ~ co:city) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) 



#prep<- air_recipe_adv  |> 
#  prep() |> 
 # bake(new_data = NULL)

save(air_recipe_adv, file = "results/air_recipe_adv.rda")

# vars that need to be imputed: pm10, nh3, toluene, benzene, aqi, aqi_bucket, aqi_log10, 
#pm2_5, n_ox, o3, so2, no2, no, co