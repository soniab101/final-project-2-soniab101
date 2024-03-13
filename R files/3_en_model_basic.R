# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# parallel processing
num_cores <- parallel::detectCores((logical = TRUE))
registerDoMC(cores = num_cores)


set.seed(1234)

load(here("results/air_split.rda"))
load(here("results/air_recipe_basic.rda"))
load(here("results/air_recipe_adv.rda"))
load(here("results/air_recipe_base_tree.rda"))
load(here("results/air_recipe_adv_tree.rda"))
load(here("results/air_folds.rda"))

# en model lasso ?? prob need to change to be tuning param

en_model_basic <- linear_reg() |> 
  set_engine("glmnet") |>   set_mode("regression") |> 
  set_args(mixture = 1, penalty = 0.01)

en_workflow_basic <- workflow() |> 
  add_model(en_model_basic) |> 
  add_recipe(air_recipe_basic)

en_fit_basic <- en_workflow_basic |> fit_resamples(
  resamples = air_folds, 
  control = control_resamples(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(en_fit_basic, file = here("results/en_fit_basic.rda"))


