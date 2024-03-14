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

# model specs
knn_mod_adv <- nearest_neighbor(mode = "regression", neighbors = tune()) |> 
  set_engine("kknn")


# define workflows ----
knn_wkflw_adv <- workflow() |> 
  add_model(knn_mod_adv) |> 
  add_recipe(air_recipe_adv)

# hyperparameter tuning values ----
knn_params_adv <- extract_parameter_set_dials(knn_mod_adv) 

knn_grid_adv <- grid_regular(knn_params_adv, levels = 5)

tuned_knn_adv <- tune_grid(knn_wkflw_adv,
                             air_folds,
                             grid = knn_grid_adv,
                             control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_knn_adv, file = here("results/tuned_knn_adv.rda"))

