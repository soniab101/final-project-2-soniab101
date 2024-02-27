# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load(here("results/air_split.rda"))
load(here("results/air_recipe_basic.rda"))
load(here("results/air_folds.rda"))

set.seed(1234)

lm_spec <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow <- workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(air_recipe_basic)

# fit workflows/models ----
lm_fit_basic <- lm_wflow |> fit_resamples(
  resamples = air_folds, 
  control = control_resamples(save_workflow = TRUE))


  
# write out results (fitted/trained workflows) ----
save(lm_fit_basic, file = here("results/lm_fit_basic.rda"))


