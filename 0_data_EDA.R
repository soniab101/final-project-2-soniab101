# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

set.seed(1234)

load("results/air_split.rda")

training_sample <- air_train |> slice_sample(prop = 0.8)

# looking at which variables have interaction