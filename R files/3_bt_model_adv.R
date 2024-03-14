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
bt_mod_adv <- boost_tree(mtry = tune(), min_n = tune(), learn_rate = tune()) |> 
  set_engine("xgboost") |> 
  set_mode("regression")

# fit workflows/models ----
bt_wkflw_adv <- workflow() |> 
  add_model(bt_mod_adv) |> 
  add_recipe(air_recipe_adv)

# hyperparameter tuning values ----
bt_params_adv <- extract_parameter_set_dials(bt_mod_adv) |> 
  update(mtry = mtry(range = c(1,15)),
         learn_rate = learn_rate(range = c(-5, -0.2)))

bt_grid_adv <- grid_regular(bt_params_adv, levels = 5)

tuned_bt_adv <- tune_grid(bt_wkflw_adv,
                            air_folds,
                            grid = bt_grid_adv,
                            control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_bt_adv, file = here("results/tuned_bt_adv.rda"))