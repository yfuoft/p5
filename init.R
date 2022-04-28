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
# Plotting the value of Bitcoin in USD over the relevant time frame
ggplot(data=cd, mapping = aes(x = cd$Date, y = cd$Close, color = cd$Close))+
  geom_line()+
  geom_point()+

  coord_flip() +
  theme_minimal() +
  labs(
    y="Bitcoin value in USD",
    x=("Date") ,
    caption = "Bitcoin value in USD"
  )
# Plotting the value of gold per Oz in USD over the relevant time frame
ggplot(data=cg, mapping = aes(x = cg$Date, y = cg$value, color = cg$value))+
  geom_point()+

  coord_flip() +
  theme_minimal() +
  labs(
    y="value of Gold in USD per Oz",
    x=("Date") ,
    caption = "Value of Gold in USD"
  )
# Combining the datasets for gold and bitcoin prices and then plotting them
cdg <- cd3


cdg <- cbind(cdg, gold = cg$value)
cdg |>
  ggplot(mapping = aes(x= cdg$Date)) +
  geom_point(aes(y = cdg$gold, color = "Gold"))+
  geom_point(aes( y = cdg$Bitcoin, color = "Bitcoin")) +
  
  theme_classic()+
  labs(
    x = "Year",
    y = "Prices in USD",
    color = "Legend",
    caption = "Prices of Gold and Bitcoin in USD by month "
  ) +
  coord_flip()
# Plotting the levels of consumer confidence by month
ggplot(data=cc, mapping = aes(x= cc$Date,y =cc$value,color=cc$value)) +
  #geom_line()+
  geom_point()+
  #scale_x_date(date_breaks = "1 Year")+
  
  coord_flip() +
  theme_minimal() +
  labs(
    y="Consumer Confidence Level (Average = 100)",
    x=("Date") ,
    caption = "Consumer Confidence among OECD member states"
  )
# Plotting the levels of consumer confidence by month relative to the price of gold
cdgc <- cdg

cc <- tail(cc,-8)
cdgc <- cbind(cdgc, cc = cc$value)
cdgc |>
  ggplot(mapping = aes(x= cdgc$Date)) +
  geom_point(aes(y = cdgc$cc, color = "Consumer Confidence"))+
  geom_point(aes( y = cdgc$gold, color = "Gold")) +
  
  theme_classic()+
  labs(
    x = "Year",
    y = "Values for the price of Gold in USD and consumer confidence among OECD member states",
    color = "Legend",
    caption = "Prices of Gold in USD per Oz and consumer confidence in the OECD "
  ) +
  coord_flip()
# Plotting the levels of consumer confidence by month relative to the price of Bitcoin
cdgc |>
  ggplot(mapping = aes(x= cdgc$Date)) +
  geom_point(aes(y = cdgc$cc, color = "Consumer Confidence"))+
  geom_point(aes( y = cdgc$value, color = "Bitcoin")) +
  
  theme_classic()+
  labs(
    x = "Year",
    y = "Values for the price of Bitcoin in USD and consumer confidence among OECD member states",
    color = "Legend",
    caption = "Prices of Bitcoin in USD and consumer confidence in the OECD "
  ) +
  coord_flip()
# Plotting the levels of consumer confidence, price of Bitcoin and price of Gold
cdgc |>
  ggplot(mapping = aes(x= cdgc$Date)) +
  geom_point(aes(y = cdgc$cc, color = "Consumer Confidence"))+
  geom_point(aes( y = cdgc$value, color = "Bitcoin")) +
  geom_point(aes( y = cdgc$gold, color = "Gold")) +
  theme_classic()+
  labs(
    x = "Year",
    y = "Values for the price of Bitcoin and gold per Oz in USD and consumer confidence among OECD member states",
    color = "Legend",
    caption = "Prices of Bitcoin in USD, gold and the level of consumer confidence in the OECD "
  ) +
  coord_flip()


# Attempting to plot linear modesl between the three variables individually

ggplot(cdgc,aes(cdgc$cc, cdgc$gold)) +
  stat_summary(fun.data=mean_cl_normal) + 
  geom_smooth(method='lm', formula= y~x) +
  labs(
    x = "Gold",
    y = "Consumer confidence ",
    caption = "The price of gold in USD per Oz and level of consume confidence for OECD member states"
  )
ggplot(cdgc,aes(cdgc$cc, cdgc$value)) +
  stat_summary(fun.data=mean_cl_normal) + 
  geom_smooth(method='lm', formula= y~x) +
  labs(
    x = "Bitcoin",
    y = "Consumer confidence ",
    caption = "The price of Bitcoin in USD and level of consume confidence for OECD member states"
  )
ggplot(cdgc,aes(cdgc$gold, cdgc$value)) +
  stat_summary(fun.data=mean_cl_normal) + 
  geom_smooth(method='lm', formula= y~x) +
  labs(
    x = "Gold",
    y = "Bitcoin ",
    caption = "The price of Bitcoin and gold per Oz in USD"
  )
# Attempting to create and plot a multi-linear regression model

cumFit1 <- lm(cdgc$cc ~ cdgc$value + cdgc$gold)

plot(cumFit1)
