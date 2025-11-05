## Download daily index values for S&P 500 from Yahoo finance

library(dplyr)
library(lubridate)
library(zoo)
library(quantmod)  # download API

here::i_am("R/pull_sp500.R")
library(here)

spx <- getSymbols("^GSPC", auto.assign = FALSE, from = "1990-01-01", to = "2019-08-01") %>%
    fortify.zoo %>% as_tibble(.name_repair = "minimal") %>%
    rename(date = Index, spx = GSPC.Close) %>%
    mutate(month = month(date),
           day = day(date),
           year = year(date)) %>%
    select(month, day, year, spx)

## save as tab-delimited text file, to be read in by MATLAB/loadfinancedata.m
write.table(spx, here("data", "confidential", "sp500.txt"), sep = "\t", dec = ".", row.names = FALSE, col.names = FALSE)


