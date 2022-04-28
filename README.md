# Requirements

## Packages
The following packages must be installed using the install.packages() command, and then loaded using the library() command;
 Markup : - dplyr
          - ggplot2
          - tidyverse
          - lubridate
          - haven
          - bibtex
          - readxl
          - httr
          
## R version

rlang_1.0.2  is required, along with rmarkdown_2.13.

## Obtaining the data

To obtain the historical gold prices from the World Gold Council, an account must be created. Once logged in, the following link will provide the dataset in an .xlsx file: https://www.gold.org/download/file/8369/Prices.xlsx

To obtain the dataset for Bitcoin prices, the following link will download the required .xlsx file: https://query1.finance.yahoo.com/v7/finance/download/BTC-USD?period1=1619578417&period2=1651114417&interval=1d&events=history&includeAdjustedClose=true

To obtain the dataset for consumer confidence among OECD member states, a .csv file can be obtained via the following link: https://data.oecd.org/leadind/consumer-confidence-index-cci.htm

## Reproducing

Run the init.R file to assign, process, analyze and graph all the data in the paper.