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



pred_rf <- air_test |> 
  select(aqi_log10) |> 
  bind_cols(predict(final_fit_rf, air_test)) |> 
  rename(rf_pred = .pred)




# model fitted to train data
pred_log_rf |> 
  rmse(price_log10, rf_pred)


rsq<- pred_rf |> 
  rsq(age, rf_pred)

mae <- pred_rf |> 
  mae(age, rf_pred)

mape <- pred_rf |> 
  mape(age, rf_pred)

metric_tbl <- bind_rows(rmse, rsq, mae, mape) |>
  select(.metric, .estimate) |> 
  knitr::kable()

save(metric_tbl, file = here("exercise_1/results/metric_tbl.rda"))


#Visualize your results by plotting the predicted observations by the observed observations --- 
#see Figure 9.2 in Tidy Modeling with R. 


predict_acc_age_plot<- pred_rf |>  ggplot(aes(x = age, y = rf_pred))+
  geom_jitter(alpha = 0.5)+
  geom_abline(color = "red")+
  theme_minimal()+
  labs(x = "True Age", y = "Predicted Age") 



save(predict_acc_age_plot, file = here("exercise_1/results/predict_acc_age_plot.rda"))


pred_rf <- abalone_test |> 
  select(sales) |> 
  bind_cols(predict(final_fit, car_test)) |> 
  rename(bt_pred = .pred)


# model fitted to train data
pred_bt |> 
  rmse(sales, bt_pred)


pred_bt  |> 
  rsq(sales, bt_pred)

pred_bt  |> 
  mae(sales, bt_pred)
