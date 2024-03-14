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
load(here("results/air_recipe_basic_lm.rda"))
load(here("results/air_recipe_adv.rda"))
load(here("results/air_recipe_base_tree.rda"))
load(here("results/air_recipe_adv_tree.rda"))
load(here("results/air_folds.rda"))



lm_spec_base <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow_base <- workflow() |> 
  add_model(lm_spec_base) |> 
  add_recipe(air_recipe_basic_lm)

# fit workflows/models ----
lm_fit_basic <- lm_wflow_base |> fit_resamples(
  resamples = air_folds, 
  control = control_resamples(save_workflow = TRUE))


  
# write out results (fitted/trained workflows) ----
save(lm_fit_basic, file = here("results/lm_fit_basic.rda"))


