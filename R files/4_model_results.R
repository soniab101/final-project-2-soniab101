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
  mutate(model = "lm basic")

# need to do
lm_fit_adv_metrics <- lm_fit_adv |> 
  collect_metrics() |> 
  mutate(model = "lm advanced")


tuned_en_basic_metrics <- tuned_en_basic |> 
  collect_metrics() |> 
  mutate(model = "en basic")


tuned_en_adv_metrics <- tuned_en_adv |> 
  collect_metrics() |> 
  mutate(model = "en advanced")

tuned_knn_basic_metrics <- tuned_knn_basic |> 
  collect_metrics() |> 
  mutate(model = "knn basic")

tuned_knn_adv_metrics <- tuned_knn_adv |> 
  collect_metrics() |> 
  mutate(model = "knn advanced")

tuned_rf_basic_metrics <- tuned_rf_basic |> 
  collect_metrics() |> 
  mutate(model = "rf basic")

tuned_rf_adv_metrics <- tuned_en_basic |> 
  collect_metrics() |> 
  mutate(model = "rf advanced")

tuned_bt_basic_metrics <- tuned_bt_basic |> 
  collect_metrics() |> 
  mutate(model = "bt basic")

tuned_bt_adv_metrics <- tuned_bt_adv |> 
  collect_metrics() |> 
  mutate(model = "bt adv")


air_metrics <- bind_rows(null_fit_metrics, lm_fit_basic_metrics, lm_fit_adv_metrics,
                         en_fit_basic_metrics, en_fit_adv_metrics,
                         rf_fit_basic_metrics, rf_fit_adv_metrics,
                         bt_fit_basic_metrics, bt_fit_adv_metrics,
                         knn_fit_basic_metrics, knn_fit_adv_metrics)


write.csv(air_metrics, file = here("results/air_metrics.csv"))


air_metrics_tbl <- air_metrics |>  
  select(.metric, model, mean, std_err) |>  
  group_by(.metric) |> 
  gt() |> 
  row_group_order(groups = c("rmse", "rsq")) |> 
  tab_header(title = md("Model Assessments")) |> 
  tab_options(row_group.background.color = "gray60")

model_results <- as_workflow_set(
  knn_basic = tuned_knn_basic,
  knn_adv = tuned_knn_basic,
  knn = tuned_knn
)
