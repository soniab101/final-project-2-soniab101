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
load(here("results/null_fit.rda"))
load(here("results/lm_fit_basic.rda"))
load(here("results/lm_fit_adv.rda"))
load(here("results/tuned_en_basic.rda"))
load(here("results/tuned_en_adv.rda"))
load(here("results/tuned_rf_basic.rda"))
load(here("results/tuned_rf_adv.rda"))
load(here("results/tuned_bt_basic.rda"))
load(here("results/tuned_bt_adv.rda"))
load(here("results/tuned_knn_basic.rda"))
load(here("results/tuned_knn_adv.rda"))


# assessment metric results table for all models

#basic recipe model results
model_results_basic <- as_workflow_set(
  null = null_fit,
  lm_basic = lm_fit_basic,
  en_basic = tuned_en_basic,
  knn_basic = tuned_knn_basic,
  rf_basic = tuned_rf_basic,
  bt_basic = tuned_bt_basic
)

tbl_result_basic <- model_results_basic |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  distinct(wflow_id, .keep_all = TRUE) |> 
  select('Model Type' = wflow_id,
         'RMSE' = mean,
         'Num Computations' = n,
         'Standard Error' = std_err) |> gt() |> 
  tab_header(title = md("Assessment Metrics"),
             subtitle = md("All Models - Basic Recipe")) |> 
  tab_style(style = cell_fill(color = "grey"),
            locations = cells_column_labels(columns = everything())) 


save(tbl_result_basic, file = here("results/tbl_result_basic.rda"))

model_results_adv <- as_workflow_set(
  lm_main = lm_fit_adv,
  en_main = tuned_en_adv,
  knn_main = tuned_knn_adv,
  rf_main = tuned_rf_adv,
  bt_main = tuned_bt_adv
)

tbl_result_adv <- model_results_adv |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean)  |> 
  select('Model Type' = wflow_id,
         'RMSE' = mean,
         'Num Computations' = n,
         'Standard Error' = std_err) |> 
  gt() |> 
  tab_header(title = md("Assessment Metrics"),
             subtitle = md("All Models - Main Recipe")) |> 
  tab_style(style = cell_fill(color = "grey"),
            locations = cells_column_labels(columns = everything()))  


save(tbl_result_adv, file = here("results/tbl_result_adv.rda"))


# hyperparameters table for knn
best_knn_basic_param <- tuned_knn_basic |> select_best("rmse") |> 
  mutate(Recipe = "basic")

best_knn_adv_param<- tuned_knn_adv |> select_best("rmse") |> 
  mutate(Recipe = "main")

knn_param_table <- bind_rows(best_knn_basic_param, best_knn_adv_param) |> select(Recipe, neighbors) |> 
  gt() |>  
  tab_header(title = md("Best Hyperparameters - Nearest Neighbors")) |> 
  tab_style(style = cell_fill(color = "grey"),
            locations = cells_column_labels(columns = everything())) 


# hyperparameters table for en
best_en_basic_param <- tuned_en_basic |> select_best("rmse") |> 
  mutate(Recipe = "basic")

best_en_adv_param<- tuned_en_adv |> select_best("rmse") |> 
  mutate(Recipe = "main")

en_param_table <- bind_rows(best_en_basic_param, best_en_adv_param) |>
  select(Recipe, penalty, mixture) |> 
  gt() |>  
  tab_header(title = md("Best Hyperparameters - Elastic Net")) |> 
  tab_style(style = cell_fill(color = "grey"),
            locations = cells_column_labels(columns = everything())) 

# hyperparameters table for bt
best_bt_basic_param <- tuned_bt_basic |> select_best("rmse") |> 
  mutate(Recipe = "basic")

best_bt_adv_param<- tuned_bt_adv |> select_best("rmse") |> 
  mutate(Recipe = "main")

bt_param_table <- bind_rows(best_bt_basic_param, best_bt_adv_param) |> 
  select(Recipe, mtry, min_n, learn_rate) |> 
  gt() |>  
  tab_header(title = md("Best Hyperparameters - Boosted Tree")) |> 
  tab_style(style = cell_fill(color = "grey"),
            locations = cells_column_labels(columns = everything())) |> 
cols_label(
              mtry = "Number of Sample Predictors",
              min_n = "Minimal Node Size",
              learn_rate = "Learning Rate"
            ) 


# hyperparameters table for rf
best_rf_basic_param <- tuned_rf_basic |> select_best("rmse") |> 
  mutate(Recipe = "basic")

best_rf_adv_param<- tuned_rf_adv |> select_best("rmse") |> 
  mutate(Recipe = "main")

rf_param_table <- bind_rows(best_rf_basic_param, best_rf_adv_param) |> select(Recipe, mtry, min_n) |> 
  gt() |>  
  tab_header(title = md("Best Hyperparameters - Random Forest")) |> 
  tab_style(style = cell_fill(color = "grey"),
            locations = cells_column_labels(columns = everything())) |> 
  cols_label(
    mtry = "Number of Sample Predictors",
    min_n = "Minimal Node Size"
    ) 





# collect metrics ? do we need ?

null_fit_metrics <- null_fit |> 
  collect_metrics() |> 
  mutate(model = "null")


lm_fit_basic_metrics <- lm_fit_basic |> 
  collect_metrics() |> 
  mutate(model = "lm basic")

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


