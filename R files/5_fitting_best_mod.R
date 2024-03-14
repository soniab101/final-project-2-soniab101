# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(gt)

# handle common conflicts
tidymodels_prefer()

set.seed(1234)

load(here("results/air_folds.rda"))
load(here("results/air_recipe_basic_lm.rda"))
load(here("results/air_recipe_adv.rda"))
load(here("results/air_recipe_base_tree.rda"))
load(here("results/air_recipe_adv_tree.rda"))
load(here("results/air_split.rda"))
load(here("results/keep_pred.rda"))

# load in model results

load(here("results/tuned_rf_adv.rda"))



# finalize workflow ----
final_wflow <- tuned_rf_adv |> 
  extract_workflow(tuned_rf_adv) |>  
  finalize_workflow(select_best(tuned_rf_adv, metric = "rmse"))

# train final model ----
# set seed
set.seed(1234)

final_fit_rf <- fit(final_wflow, air_train)

save(final_fit_rf, file = here("results/final_fit_rf.rda"))

