# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(gt)

# handle common conflicts
tidymodels_prefer()

set.seed(1234)

load(here("results/air_folds.rda"))
load(here("results/air_recipe_basic.rda"))
load(here("results/air_split.rda"))
load(here("results/keep_pred.rda"))
load(here("results/null_fit.rda"))
load(here("results/lm_fit_basic.rda"))


null_fit_metrics <- null_fit |> 
  collect_metrics() |> 
  mutate(model = "null")


lm_fit_basic_metrics <- lm_fit_basic |> 
  collect_metrics() |> 
  mutate(model = "lm")


air_metrics <- bind_rows(null_fit_metrics, lm_fit_basic_metrics)

air_metrics_tbl <- air_metrics |>  
  select(.metric, model, mean, std_err) |>  
  group_by(.metric) |> 
  gt() |> 
  row_group_order(groups = c("rmse", "rsq")) |> 
  tab_header(title = md("Model Assessments")) |> 
  tab_options(row_group.background.color = "gray60")

save(air_metrics_tbl, file = here("results/air_metrics_tbl"))

