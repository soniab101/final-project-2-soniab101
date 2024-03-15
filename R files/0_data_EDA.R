# load packages ----
library(tidyverse)
library(tidymodels)
library(here)


# handle common conflicts
tidymodels_prefer()

set.seed(1234)

load("results/air_split.rda")

training_sample <- air_train |> slice_sample(prop = 0.8)
training_sample <- training_sample |> mutate(date = as_date(date)) |> 
  mutate(date_month = month(date),
         date_year = year(date),
         date_year = factor(date_year),
         season = case_when(
           date_month == 12 | (date_month >= 1 & date_month <= 4) ~ "winter",
           date_month >= 5 & date_month <= 7 ~ "summer",
           date_month == 8 | date_month == 9 ~ "monsoon",
           date_month >= 10 & date_month <= 12 ~ "post-monsoon"),
         season = factor(season))




# looking at which variables have interaction


# interaction between month of year and nitrogen dioxide 
season_no2 <- training_sample |> ggplot(aes(x = season, y = no2, fill = season)) + 
  geom_col() +
  labs(title = "Nitrogen dioxide levels by season",
       y = "nitrogen dioxide")

save(season_no2, file = "results/season_no2.rda")

# interaction between month of year and nitrogen dioxide 
season_o3 <- training_sample |> ggplot(aes(x = season, y = o3, fill = season)) + geom_col() 

save(season_o3, file = "results/season_o3.rda")

# interaction between no and o3: no
no_o3 <- training_sample |> ggplot(aes(x = no, y = o3)) + geom_point() + geom_smooth()


# interaction of benzene and pm2_5: no
benzene_pm2_5 <- training_sample |> ggplot(aes(x = benzene, y = pm2_5)) + geom_point() + geom_smooth() + 
  coord_cartesian(xlim = c(0,3))


# interaction between pm2_5 and pm10: yes
pm2_5_pm10 <- training_sample |> ggplot(aes(x = pm2_5, y = pm10)) + geom_point() + geom_smooth() 

save(pm2_5_pm10, file = "results/pm2_5_pm10.rda")

# interaction between avg co and city bc of high traffic volume

mean_CO <- training_sample %>%
  group_by(city) %>%
  summarise(mean_CO = mean(co, na.rm = TRUE))

# Plot the average CO value for each city using geom_col

# there does seem to be a interaction
co_city <- ggplot(mean_CO, aes(x = city, y = mean_CO)) +
  geom_col() +
  labs(x = "City", y = "Mean CO Value", title = "Average CO Value for Each City") + 
  coord_cartesian(ylim = c(0,5)) + theme(axis.text.x = element_text(face = "bold", angle = 45))

save(co_city, file = here("figures/co_city.png"))
# nitrous oxide and year relationship: has it increased over the years?



nox_year_density <- ggplot(training_sample, aes(x = n_ox, fill = date_year)) +
  geom_density(alpha = 0.5) +
  coord_cartesian(xlim = c(0,100)) +
  labs(x = "Nitrous Oxide", y = "Density", title = "Density Plot of Nitrous Oxide by Year")

nox_year_boxplot <- ggplot(training_sample, aes(x = n_ox, fill = date_year)) +
  geom_boxplot(alpha = 0.5)  +
  labs(x = "Nitrous Oxide", title = "Boxplot Plot of Nitrous Oxide by Year")


# distribution of predictors:

# skewed right
pm2_5_dist<- training_sample |> ggplot(aes(x = pm2_5)) + geom_density()

# skewed right
no_dis <- training_sample |> ggplot(aes(x = no)) + geom_density()


co_dis <- training_sample |> ggplot(aes(x = co)) + geom_density() 

