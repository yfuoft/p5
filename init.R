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
cd <- read_csv("data/BTC-USD.csv")
cg <- read_excel("data/Prices.xlsx", sheet = "Monthly_Average")
cc <- read_csv("data/DP_LIVE_27042022071642777.csv")
# Filters the relevant variables and gets cumulative metrics by date by taking the per monthly average
cc %>%
  filter(LOCATION=='OECD')
cc <-aggregate(cc$Value, list(cc$TIME), FUN=mean)
cg <- select(cg, c('Name','US dollar...2'))
# Selects the relevant time period in all three datasets after standardizing date formats and column names
cd %>%
  mutate(cd$Date, ymd(cd$Date))
cg %>%
  mutate(cg$Name, ymd(cg$Name)) 
cg %>% 
  data.table::setnames(
    old = "Name",
    new = "Date")
cg <- subset(cg, cg$Date >= "2014-09-17")
cd <- subset(cd, cd$Date <= "2022-03-31")
cd2 <- cd
cd2$Date <- floor_date(cd2$Date, "month")
cd3 <- cd2 %>%                         # Aggregate data
  group_by(Date) %>% 
  dplyr::summarize(value = mean(Close)) %>% 
  as.data.frame()
cc %>%
  mutate(cc$Group.1, ym(cc$Group.1))

