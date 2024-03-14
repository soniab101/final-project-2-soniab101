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



# model specifications ----
rf_mod_adv <- rand_forest(min_n = tune(), trees = 100, mtry = tune()) |> 
  set_engine("ranger")  |> 
  set_mode("regression") 

# fit workflows/models ----

rf_wkflw_adv <- workflow() |> 
  add_model(rf_mod_adv) |> 
  add_recipe(air_recipe_adv)



# hyperparameter tuning values ----
rf_params_adv <- extract_parameter_set_dials(rf_mod_adv) |> 
  update(mtry = mtry(range = c(1,15)))

rf_grid_adv <- grid_regular(rf_params_adv, levels = 5)


tuned_rf_adv <- tune_grid(rf_wkflw_adv,
                          air_folds,
                          grid = rf_grid_adv,
                          control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_rf_adv, file = here("results/tuned_rf_adv.rda"))

