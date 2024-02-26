# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load(here("results/air_split.rda"))
load(here("results/air_recipe_basic.rda"))

set.seed(1234)