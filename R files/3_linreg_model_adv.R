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



lm_spec_adv <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow_adv <- workflow() |> 
  add_model(lm_spec_adv) |> 
  add_recipe(air_recipe_adv)

# fit workflows/models ----
lm_fit_adv <- lm_wflow_adv |> fit_resamples(
  resamples = air_folds, 
  control = control_resamples(save_workflow = TRUE)) |> show_notes(.Last.tune.result)



# write out results (fitted/trained workflows) ----
save(lm_fit_adv, file = here("results/lm_fit_adv.rda"))


