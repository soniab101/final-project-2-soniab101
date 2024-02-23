# Initial data checks, data splitting, & data folding

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

#load in data
air_data<- read_csv("data/city_day.csv")

#### Task 1

#We have previous experience working with this data and we can use that to get us started.

#Start by reading in the  data (`kc_house_data.csv`):

#  1. We previously determined that we should log-transform (base 10) `price`. This has not changed, so apply the log-transformation to `price` when reading in the data.

#2. Leave all other variables be when reading in the data. Meaning, do not re-type anything to factor. `waterfront` is already dummy coded and the others that should be ordered factors can be treated as numerical measures (reported on a numerical scale already). We could do more feature engineering, but for now we will opt to keep it relatively simple. 

#Typically we would also perform a quick data assurance check using `skimr::skim_without_charts()` and/or the `naniar` package  to see if there are any major issues. We're mostly checking for missing data problems, but we also look for any obvious read-in issues. We've done this in past labs and we haven't noted any issues so we should be able to proceed.

#Split the data into training and testing sets using stratified sampling --- choice of proportion is left to you. 

#No display code is required for this task --- we have done this a few times now on previous labs. Only need a confirmation that it has been completed and it what proportion was used for the split.

set.seed(1234)

air_data_trans <- air_data |> janitor::clean_names() |> 
  mutate(aqi_log10 = log10(aqi))


air_split <- air_data_trans |> 
  initial_split(prop = 0.7, strata = aqi_log10, breaks = 4)

air_train <- training(air_split)
air_test <- testing(air_split)

save(air_train, air_test, file = "results/air_split.rda")


#### Task 2

#Fold the training data using repeated V-fold cross-validation (5 folds & 3 repeats). 
#Use stratified sampling when folding the data. 

air_folds <- vfold_cv(kc_train, v = 5, repeats = 3,
                     strata = price_log10)

keep_pred<- control_resamples(save_pred = TRUE, save_workflow = TRUE)

save(kc_folds, file = here("results/kc_folds.rda"))

save(keep_pred, file = here("results/keep_pred.rda"))



