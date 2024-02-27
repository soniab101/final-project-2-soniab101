# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

set.seed(1234)

load("results/air_recipe_basic.rda")


null_model <- null_model() %>% 
  set_engine("parsnip") %>% 
  set_mode("regression")


# define workflows ----
null_wflw <- workflow() %>% 
  add_model(null_model) %>% 
  add_recipe(air_recipe_basic)


null_fit <- null_wflw|> 
  fit_resamples(
    resamples = air_folds, 
    control = control_resamples(save_workflow = TRUE))

save(null_fit, file = "results/null_fit.rda")
