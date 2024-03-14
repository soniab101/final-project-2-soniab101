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
# load(here("results/air_recipe_basic.rda"))
load(here("results/air_recipe_basic_lm.rda"))
load(here("results/air_recipe_adv.rda"))
load(here("results/air_recipe_base_tree.rda"))
load(here("results/air_recipe_adv_tree.rda"))
load(here("results/air_folds.rda"))


null_model <- null_model() %>% 
  set_engine("parsnip") %>% 
  set_mode("regression")


# define workflows ----
null_wflw <- workflow() %>% 
  add_model(null_model) %>% 
  add_recipe(air_recipe_basic_lm)


null_fit <- null_wflw |> 
  fit_resamples(
    resamples = air_folds, 
    control = control_resamples(save_workflow = TRUE),
    metrics = metric_set(rmse)
    )

save(null_fit, file = here("results/null_fit.rda"))
