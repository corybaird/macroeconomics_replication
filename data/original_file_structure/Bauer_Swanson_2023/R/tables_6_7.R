## Financial market response to monetary policy surprises
## Tables 6-7

library(dplyr)
library(lubridate)
library(sandwich)

here::i_am("R/tables_6_7.R")
library(here)

## Nakamura-Steinsson sample -- as in Table 1(B)
dropintermeeting = 1 ;
dropcrisistrough = 1 ;
dropfirstsevendays = 1 ;
startdate <- 199501
enddate <- 201403

unsched <- c(19940418, 19981015, 20010103, 20010418, 20070810, 20070817, 20080122, 20080311, 20081008, 20081201) %>%
    as.character %>% as.Date(format = "%Y%m%d")

data <- read.table(here("data", "confidential", "tightalldata.txt")) %>%
    as_tibble %>%
    select(1:9, 16, 17) %>%
    magrittr::set_colnames(c("month", "day", "year", "mp1", "mp2", "ed1", "ed2", "ed3", "ed4", "sp500", "eurusd")) %>%
    mutate(date = make_date(year, month, day),
           ym = year*100 + month) %>%
    filter(year >= 1994,
           date != as.Date("2001-09-17"), # % drop 9/17/2001 from the analysis (also intermeeting):
           date != as.Date("2008-11-25"), # % drop 11/25/2008 from the analysis (not an FOMC announcement):
           date != as.Date("2008-12-01")) %>%  # % drop 12/1/2008 from the analysis (not an FOMC announcement):
    mutate(mp1 = ifelse(date == as.Date("2008-01-22"), -0.26, mp1),
           mp2 = ifelse(date == as.Date("2008-01-22"), -0.124, mp2),
           sp500 = ifelse(date == as.Date("2008-01-22"), 1.6, sp500),
           mp2 = ifelse(date == as.Date("2008-03-11"), 0.11, mp2))

## sample
data <- filter(data, ym >= startdate, ym <= enddate)
if (dropintermeeting == 1)
    data <- filter(data, !(date %in% unsched))
if (dropcrisistrough == 1)
    data <- filter(data, (ym < 200807) | (ym > 200906))

## NS susprise
X <- select(data, mp1, mp2, ed2, ed3, ed4) %>% as.matrix
X <- scale(X)
res <- svd(X)
mps <- res$u[,1] * sqrt(nrow(X))
mps <- mps * sign(cor(mps, X[,1]))
## scale so that has unit effect on GSW y1
gsw <- read.csv(here("data", "feds200628.csv"), skip=9) %>%
    as_tibble %>%
    select(Date, SVENY01) %>% rename(date = Date, y1 = SVENY01) %>% mutate(date = as.Date(date)) %>%
    filter(year(date) >= 1994) %>%
    mutate(y1 = zoo::na.locf(y1),
           dy1 = y1 - lag(y1))
data <- left_join(data, gsw)
mod <- lm(dy1 ~ mps, data)
data <- mutate(data, mps = mps * mod$coef[2])

## NS regressions
bc <- read.table(here("data", "confidential", "BCEI_rgdp.txt")) %>% as_tibble %>%
    select(1,2,4:8) %>%
    magrittr::set_colnames(c("year", "month", paste0("GDP", 0:4))) %>%
    mutate(ym = year*100 + month,
           DGDP1 = GDP1 - lag(GDP1),
           DGDP2 = GDP2 - lag(GDP2),
           DGDP3 = GDP3 - lag(GDP3))
## deal with roll-over months -- like Nakamura-Steinsson did
ind <- seq(4, nrow(bc), 3)
bc$DGDP1[ind] <- bc$GDP1[ind] - bc$GDP2[ind-1]
bc$DGDP2[ind] <- bc$GDP2[ind] - bc$GDP3[ind-1]
bc$DGDP3[ind] <- bc$GDP3[ind] - bc$GDP4[ind-1]
bc$DGDP1yr <- rowMeans(bc %>% select(DGDP1, DGDP2, DGDP3))
bc <- mutate(bc, DGDP1yr = lead(DGDP1yr))

## create monthly financial data
datam <- data
## policy surprises: set NA if meeting in first week of the month
if (dropfirstsevendays == 1)
    datam <- mutate(datam,
                    mps = ifelse(day < 8, NA, mps),
                    sp500 = ifelse(day < 8, NA, sp500),
                    eurusd = ifelse(day < 8, NA, eurusd))
## create monthly sums of policy surprise and stock return
datam <- datam %>%
    group_by(ym) %>%
    summarise(mps = sum(mps),
              sp500 = sum(sp500),
              eurusd = sum(eurusd),
              n = n()) %>%
    inner_join(bc %>% select(ym, DGDP1yr))
stopifnot(all(datam$n == 1)) # if multiple meetings per month, need to remove NAs when summing

## add BBK data to monthly dataset
bbk <- read.table(here("data", "bravebutterskelley.txt")) %>%
    as_tibble %>%
    rename(month = V1, year = V2, bbk = V3) %>%
    mutate(ym = year*100 + month,
           bbk = lag(bbk))
datam <- left_join(datam, bbk)

## Blue Chip regression
mod <- lm(DGDP1yr ~ mps, datam)
SEs <- sqrt(diag(vcovHC(mod, type="HC0")))
cat("# Blue Chip regression -- replicates Table 1B, real GDP growth:\n")
beta0 <- mod$coef[2]
se0 <- SEs[2]
tstat0 <- beta0/se0
cat(sprintf("%5.3f (%5.3f)  t = %4.2f   R^2 = %4.3f   nobs = %d\n",
            beta0, se0, tstat0, summary(mod)$r.squared, length(mod$residuals)))

## influential analysis
N <- nrow(datam)
datam$Dtstat <- NA
for (j in 1:N) {
    rdat <- datam[-j,]
    mod <- lm(DGDP1yr ~ mps, rdat)
    SEs <- sqrt(diag(vcovHC(mod, type="HC0")))
    datam$Dtstat[j] <- tstat0 - mod$coef[2]/SEs[2]
}
cat("# top 10 influential observations for NS regression, NS original sample:\n")
datam$rank <- rank(-datam$Dtstat)
top10 <- datam %>% filter(rank <= 10) %>% arrange(rank)
other <- datam %>% filter(rank > 10)

## Table 6
cat("# Table 6:\n")
top10 %>% select(ym, Dtstat, mps, DGDP1yr, sp500, eurusd, bbk, rank) %>% as.data.frame %>% round(3) %>% print

## Table 7 (first two columns) -- Bernanke-Kuttner regressions
cat("# Table 7:\n")

## cat("# Bernanke-Kuttner regression:\n")
## mod <- lm(sp500 ~ mps, data)
## SEs <- sqrt(diag(vcovHC(mod, type="HC0")))
## cat(sprintf("%5.2f (%5.2f)  t = %4.2f   R^2 = %4.3f   nobs = %d\n",
##             mod$coef[2], SEs[2], mod$coef[2]/SEs[2], summary(mod)$r.squared, length(mod$residuals)))

## cat("# Bernanke-Kuttner regression in NS sample:\n")
## mod <- lm(sp500 ~ mps, datam)
## SEs <- sqrt(diag(vcovHC(mod, type="HC0")))
## cat(sprintf("%5.2f (%5.2f)  t = %4.2f   R^2 = %4.3f   nobs = %d\n",
##             mod$coef[2], SEs[2], mod$coef[2]/SEs[2], summary(mod)$r.squared, length(mod$residuals)))

cat("# Column 1: Bernanke-Kuttner regression for top 10 observations:\n")
mod <- lm(sp500 ~ mps, top10)
SEs <- sqrt(diag(vcovHC(mod, type="HC0")))
cat(sprintf("%5.2f (%5.2f)  t = %4.2f   R^2 = %4.3f   nobs = %d\n",
            mod$coef[2], SEs[2], mod$coef[2]/SEs[2], summary(mod)$r.squared, length(mod$residuals)))

cat("# Column 2: Bernanke-Kuttner regression for other observations:\n")
mod <- lm(sp500 ~ mps, other)
SEs <- sqrt(diag(vcovHC(mod, type="HC0")))
cat(sprintf("%5.2f (%5.2f)  t = %4.2f   R^2 = %4.3f   nobs = %d\n",
            mod$coef[2], SEs[2], mod$coef[2]/SEs[2], summary(mod)$r.squared, length(mod$residuals)))

cat("# Column 3: EUR-USD regression for top 10 observations:\n")
mod <- lm(eurusd ~ mps, top10)
SEs <- sqrt(diag(vcovHC(mod, type="HC0")))
cat(sprintf("%5.3f (%5.3f)  t = %4.2f   R^2 = %4.3f   nobs = %d\n",
            mod$coef[2], SEs[2], mod$coef[2]/SEs[2], summary(mod)$r.squared, length(mod$residuals)))

cat("# Column 4: EUR-USD regression for other observations:\n")
mod <- lm(eurusd ~ mps, other)
SEs <- sqrt(diag(vcovHC(mod, type="HC0")))
cat(sprintf("%5.3f (%5.3f)  t = %4.2f   R^2 = %4.3f   nobs = %d\n",
            mod$coef[2], SEs[2], mod$coef[2]/SEs[2], summary(mod)$r.squared, length(mod$residuals)))
