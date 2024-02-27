# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load("results/air_split.rda")

set.seed(1234)

# basic recipe:
air_recipe_basic <-  recipe(aqi_log10 ~ ., data = air_train) |> 
  step_mutate(data = as_date(date)) |> 
  step_date(date, features = "month") |> 
  step_rm(aqi, aqi_bucket, date, data) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) 
  


prep<- air_recipe_basic  |> 
  prep() |> 
  bake(new_data = NULL)

save(air_recipe_basic, file = "results/air_recipe_basic.rda")




#### Task 4

#Looking ahead, we plan on fitting 5 model types: **standard linear**, **ridge**, **lasso**, **random forest**, and **nearest neighbor**. Pre-processing can be the same for the first 3 models and the nearest neighbor model, but the random forest model should have a slightly different pre-processing. This means we will need to create 2 recipes/pre-processors.   

#Remember, there should be no factor variables. We left them all as numerical when we read in the data 
## Recipe for standard linear, ridge, lasso, and nearest neighbor

#- Predict the target variable with all other variables
#- Do not use `id`, `date`, or `zipcode` as predictors (might have to exclude `price` too, depends on how log-transformation was handled)
#- Log-transform `sqft_living, sqft_lot, sqft_above,  sqft_living15, sqft_lot15`
#- Turn `sqft_basement` into an indicator variable (if greater than 0 house has basement, otherwise it does not have basement),
#- Transform `lat` using a natural spline with 5 degrees of freedom
#- Center all predictors
#- Scale all predictors
#- Filter out variables have have zero variance

kc_recipe <- recipe(price_log10 ~ ., data = kc_train) |> 
  step_rm(id, zipcode, date, price) |> 
  step_log(sqft_living, sqft_lot, sqft_above, sqft_living15, sqft_lot15, base = 10) |> 
  step_mutate(sqft_basement = if_else(sqft_basement >0, 1, 0)) |> 
  step_ns(lat, deg_free = 5) |> 
  # natural spline
  # always step_zv before normalizing
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())
# center scale


kc_recipe |> 
  prep() |> 
  bake(new_data = NULL)

save(kc_recipe, file = "results/kc_recipe.rda")


## Recipe for random forest

#Trees automatically detect non-linear relationships so we don't need the natural spline step (it has been removed).
#Some of the other steps are not needed (such as Log-transforms, centering, scaling), 
#but can be done since they will not meaningfully change anything. The natural spline step performs a basis expansion, 
#which turns one column into 5 --- which is what causes the issue for the random forest algorithm.

#- Predict the target variable with all other variables
#- Do not use `id`, `date`, or `zipcode` as predictors (might have to exclude `price` too, depends on how log-transformation was handled)
#- Log-transform `sqft_living, sqft_lot, sqft_above, sqft_living15, sqft_lot15`
#- Turn `sqft_basement` into an indicator variable (if greater than 0 house has basement, otherwise it does not have basement),
#- Center all predictors
#- Scale all predictors
#- Filter out variables have have zero variance

kc_recipe2 <- recipe(price_log10 ~ ., data = kc_train) |> 
  step_rm(id, zipcode, date, price) |> 
  step_log(sqft_living, sqft_lot, sqft_above, sqft_living15, sqft_lot15, base = 10) |> 
  step_mutate(sqft_basement = if_else(sqft_basement >0, 1, 0)) |> 
  # natural spline
  # always step_zv before normalizing
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

kc_recipe2 |> 
  prep() |> 
  bake(new_data = NULL)

save(kc_recipe2, file = "results/kc_recipe2.rda")
