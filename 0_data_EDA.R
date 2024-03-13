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
         date_month = factor(date_month),
         date_year = year(date),
         date_year = factor(date_year),
         )




# looking at which variables have interaction


# interaction between month of year and nitrogen dioxide 
month_no2 <- training_sample |> ggplot(aes(x = date_month, y = no2)) + geom_col()

# interaction between no and o3
no_o3 <- training_sample |> ggplot(aes(x = no, y = o3)) + geom_point() + geom_smooth()

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

