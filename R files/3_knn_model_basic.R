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
knn_mod_basic <- nearest_neighbor(mode = "regression", neighbors = tune()) |> 
  set_engine("kknn")


# define workflows ----
knn_wkflw_basic <- workflow() |> 
  add_model(knn_mod_basic) |> 
  add_recipe(air_recipe_basic)

# hyperparameter tuning values ----
knn_params_basic <- extract_parameter_set_dials(knn_mod_basic) 

knn_grid_basic <- grid_regular(knn_params_basic, levels = 5)

tuned_knn_basic <- tune_grid(knn_wkflw_basic,
                       air_folds,
                       grid = knn_grid_basic,
                       control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_knn_basic, file = here("results/tuned_knn_basic.rda"))

