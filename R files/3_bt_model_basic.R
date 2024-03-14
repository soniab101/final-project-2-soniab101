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
bt_mod_basic <- boost_tree(mtry = tune(), min_n = tune(), learn_rate = tune()) |> 
  set_engine("xgboost") |> 
  set_mode("regression")

# fit workflows/models ----
bt_wkflw <- workflow() |> 
  add_model(bt_mod_basic) |> 
  add_recipe(air_recipe_basic)

# hyperparameter tuning values ----
bt_params <- extract_parameter_set_dials(bt_mod_basic) |> 
  update(mtry = mtry(range = c(1,19)),
         learn_rate = learn_rate(range = c(-5, -0.2)))

bt_grid <- grid_regular(bt_params, levels = 5)

tuned_bt_basic <- tune_grid(bt_wkflw,
                      air_folds,
                      grid = bt_grid,
                      control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_bt_basic, file = here("results/tuned_bt_basic.rda"))