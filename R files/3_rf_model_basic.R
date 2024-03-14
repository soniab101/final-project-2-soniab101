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
rf_mod_basic <- rand_forest(min_n = tune(), trees = 100, mtry = tune()) |> 
  set_engine("ranger")  |> 
  set_mode("regression") 

# fit workflows/models ----

rf_wkflw_basic <- workflow() |> 
  add_model(rf_mod_basic) |> 
  add_recipe(air_recipe_basic)



# hyperparameter tuning values ----
rf_params_basic <- extract_parameter_set_dials(rf_mod_basic) |> 
  update(mtry = mtry(range = c(1,15)))


rf_grid_basic <- grid_regular(rf_params_basic, levels = 5)


tuned_rf_basic <- tune_grid(rf_wkflw_basic,
                      air_folds,
                      grid = rf_grid_basic,
                      control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_rf_basic, file = here("results/tuned_rf_basic.rda"))

