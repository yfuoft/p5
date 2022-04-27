install.packages("classInt")
install.packages("sf")
install.packages("opendatatoronto")
library("httr")
library("readxl")
# This code block imports the needed R packages.
library("httr")
library("readxl")
library("tidyverse")
library(dplyr)
library(haven)
library(ggplot2)
library(bibtex)
library(lubridate)
#Assigns datasets to memorable variables
cd <- read_excel("data/allcurrenciesfinal12.18.17.xlsx")
cc <- read_csv("data/DP_LIVE_27042022071642777.csv")
# Filters and gets cumulative metrics by year by taking the per annum average
cc %>%
  dplyr::group_by(TIME) %>% 
  summarise(mean(cc$LOCATION))
cc %>%
  filter(LOCATION=='OECD')
