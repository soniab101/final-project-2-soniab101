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
  rmse(aqi_log10, rf_pred_log)


# 
pred_log_rf |> 
  mutate(rf_pred_reg = 10^rf_pred_log) |>  
  ggplot(aes(aqi, rf_pred_reg)) +
  geom_point() +
  geom_abline(aes(slope=1, intercept = 0))



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

pred_log <- kc_test |> 
  select(price, price_log10) |> 
  bind_cols(predict(lm_fit, kc_test)) |> 
  bind_cols(predict(lm_fit, kc_test, type = "pred_int")) |> 
  rename(lm_pred = .pred, lm_pred_lower = .pred_lower, lm_pred_upper = .pred_upper)


# compute rmse
# can do this on log or reuglar scale but be consistent

pred_log |> 
  rmse(price_log10, lm_pred) 


# put in one data frame or predict htem in separate ones
# lm_log = exp(lm_pred)
# #
pred_log |> 
  mutate(lm_pred = 10^lm_pred) |>  
  ggplot(aes(price, lm_pred)) +
  geom_point() +
  geom_abline(aes(slope=1, intercept = 0))



#prediction for lasso

pred_log_lasso <- kc_test |> 
  select(price, price_log10) |> 
  bind_cols(predict(lasso_fit, kc_test)) |> 
  rename(lasso_pred = .pred)
pred_log_lasso

# compute rmse
# can do this on log or reuglar scale but be consistent

pred_log_lasso |> 
  rmse(price_log10, lasso_pred) 


# put in one data frame or predict htem in separate ones
# lm_log = exp(lm_pred)
# #lm_pred = 10^lm_pred)
pred_log_lasso |> 
  mutate(price_log10 = 10^price_log10) |>  
  ggplot(aes(price, lasso_pred)) +
  geom_point(alpha = 0.5) +
  geom_abline(aes(slope=1, intercept = 0, col = "red"))
