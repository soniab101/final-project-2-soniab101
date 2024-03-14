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
load(here("results/air_recipe_basic_en.rda"))
load(here("results/air_recipe_adv.rda"))
load(here("results/air_recipe_base_tree.rda"))
load(here("results/air_recipe_adv_tree.rda"))
load(here("results/air_folds.rda"))

# en model lasso ?? prob need to change to be tuning param

en_model_adv <- linear_reg(penalty = tune(), mixture = tune()) |> 
  set_engine("glmnet") |> set_mode("regression") 

en_workflow_adv <- workflow() |> 
  add_model(en_model_adv) |> 
  add_recipe(air_recipe_basic_en) # FIXXXXXX

en_params_adv <- extract_parameter_set_dials(en_model_adv) |> 
  update(penalty = penalty(range = c(-2,0)),
         mixture = mixture(range = c(0,1)))

en_grid_adv <- grid_regular(en_params_adv, levels = 10)

tuned_en_adv <- tune_grid(en_workflow_adv,
                            air_folds,
                            grid = en_grid_adv,
                            control = control_grid(save_workflow = TRUE),
                            metrics = metric_set(rmse))


#en_fit_basic <- en_workflow_basic |> fit_resamples(
# resamples = air_folds, 
# control = control_resamples(save_workflow = TRUE))



# write out results (fitted/trained workflows) ----
save(tuned_en_adv, file = here("results/tuned_en_adv.rda"))


