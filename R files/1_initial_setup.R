# Initial data checks, data splitting, & data folding

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

#load in data
air_data<- read_csv("data/city_day.csv")


set.seed(1234)

air_data_trans <- air_data |> janitor::clean_names() 

air_data_trans <- air_data_trans[!is.na(air_data_trans[,"aqi"]),] 

air_data_trans <- air_data_trans |> mutate(aqi_log10 = log10(aqi),
         city = factor(city),
         date = as_date(date), 
         date_month = month(date),
         date_year = year(date))


air_split <- air_data_trans |> 
  initial_split(prop = 0.7, strata = aqi_log10, breaks = 4)

air_train <- training(air_split)
air_test <- testing(air_split)

save(air_train, air_test, file = "results/air_split.rda")



# folding data

air_folds <- vfold_cv(air_train, v = 5, repeats = 3,
                     strata = aqi_log10)

keep_pred<- control_resamples(save_pred = TRUE, save_workflow = TRUE)

save(air_folds, file = here("results/air_folds.rda"))

save(keep_pred, file = here("results/keep_pred.rda"))



