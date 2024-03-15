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

load(here("results/final_fit_rf.rda"))



pred_log_rf <- air_test |> 
  select(aqi,aqi_log10) |> 
  bind_cols(predict(final_fit_rf, air_test)) |> 
  rename(rf_pred_log = .pred)



# model fitted to train data
rmse_pred_log_rf <-pred_log_rf |> 
  rmse(aqi_log10, rf_pred_log) |> select(.metric, .estimate) |> 
  gt() |>  
  tab_header(title = md("RMSE for Random Forest")) |> 
  tab_style(style = cell_fill(color = "grey"),
            locations = cells_column_labels(columns = everything())) |> 
  cols_label(
    .metric = "Metric",
    .estimate = "Estimate"
  ) 


save(rmse_pred_log_rf, file = here("results/rmse_pred_log_rf.rda"))

# 
final_plot<-pred_log_rf |> 
  mutate(rf_pred_reg = 10^rf_pred_log) |>  
  ggplot(aes(aqi, rf_pred_reg)) +
  geom_point() +
  geom_abline(aes(slope=1, intercept = 0))


save(final_plot, file = here("results/final_plot.rda"))


