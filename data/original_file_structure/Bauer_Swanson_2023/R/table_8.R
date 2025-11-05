## compare accuracy of greenbook and Blue Chip forecasts
## Table 8 and Online Appendix (OA) Tables E.1-E.3

here::i_am("R/table_8.R")
library(here)

##################################################
## SETTINGS:
## (a) choose and set before running script, or
## (b) choose here (need to make sure variables aren't in workspace, e.g., using rm(list=ls())

## MACRO SERIES: 1 - unemployment rate, 2 - real GDP growth, 3 - CPI inflation
if (!exists("series"))
    series <- 1

## TIMING: lag Blue Chip forecasts?  1 - never (OA Table E.3), 2 - it depends (paper Table 8), 3 - always (OA Table E.2)
if (!exists("lagbc"))
    lagbc <- 2

## SAMPLE START: 1990 - Table 8, 1980 - OA Tables E.1-E.3
if (!exists("startyear"))
    startyear <- 1990
##################################################

cat("#", switch(series, "Unemployment rate", "Real GDP", "Inflation - CPI"), "\n")

## Greenbook
filename <- paste0("greenbook_", switch(series, "unemp", "rgdp", "cpi"), ".csv")
gb <- read.csv(here("data", filename), na.string="#N/A")
gb <- gb[,-c(2:5, 15)]     # remove columns - no need for backcasts and longest forecast
names(gb)[2:10] <- paste0("GB", 0:8)
gb$year <- floor(gb$DATE)
gb$quarter <- (gb$DATE - gb$year)*10
gb$GBdate <- as.Date(as.character(gb$GBdate), format="%Y%m%d")

gb <- gb[gb$year >= startyear,] # start sample in 1980

gb$gbmonth <- as.numeric(format(gb$GBdate, "%m"))
stopifnot(all.equal(gb$quarter, (gb$gbmonth+2) %/% 3))  # check month vs quarter
gb$gbym <- zoo::as.yearmon(gb$GBdate) # additional useful date variable
nobs <- nrow(gb)
ind <- gb$gbym[2:nobs] == gb$gbym[1:(nobs-1)] # multiple forecasts in one month?
if (any(ind)) {   # happened only in January 1980, use the later of the two forecasts
    ## print(gb[1+which(ind),])
    gb <- gb[-which(ind),]
}

## bluechip - lag?
if (lagbc == 1) {
    cat("# never lag Blue Chip forecasts\n")
    gb$lagbc <- 0
} else if (lagbc == 2) {
    cat("# lag Blue Chip forecasts depending on day\n")
    ## BASELINE - lag depending on date
    ## lag BC if Greenbook is closer to next month than to first of this month
    firstofmonth <- as.Date(paste(gb$year, gb$gbmonth, 1, sep="-"))
    firstofnextmonth <- as.Date(ifelse(gb$gbmonth<12,
                                       paste(gb$year, gb$gbmonth+1, 1, sep="-"),
                                       paste(gb$year+1, 1, 1, sep="-")))
    gb$lagbc <- difftime(gb$GBdate, firstofmonth, unit="day") > difftime(firstofnextmonth, gb$GBdate, unit="day")
} else if (lagbc == 3) {
    cat("# always lag Blue Chip forecasts\n")
    gb$lagbc <- 1
}
gb$bcym <- gb$gbym + gb$lagbc/12
gb$bcyyyymm <- as.numeric(format(gb$bcym, "%Y%m"))
gb <- gb[gb$year <= 2013,]

gb$DATE <- NULL; gb$quarter <- NULL; gb$gbym <- NULL; gb$bcym <- NULL
## sum(!is.na(gb$GB7))

## Blue Chip
filename <- paste0("bcei_", switch(series, "unemp", "rgdp", "cpi"), ".csv")
bc <- read.csv(here("data", "confidential", filename))
names(bc) <- c("year", "month", "BCb1", paste0("BC", 0:7))
bc$bcyyyymm <- bc$year*100 + bc$month
bc$yq <- zoo::yearqtr(bc$year + (bc$month-1)/12)
bc$year <- NULL
bc$month <- NULL

## merge data
forecasts <- merge(gb, bc, all.x=TRUE)
## line up forecasts:
##  if GB-quarter is earlier than BC-quarter (GB month is 3,6,9,12 and Blue Chip is lagged)
##  then shift all GB forecasts one quarter earlier
indShift <- forecasts$lagbc & (forecasts$gbmonth %% 3 == 0)
forecasts[indShift, paste0("GB", 0:7)] <- forecasts[indShift, paste0("GB", 1:8)]
forecasts$GB8 <- NULL; forecasts$gbmonth <- NULL; forecasts$BCb1 <- NULL

## macro data
if (series == 2) {
    ## real GDP growth
    macro <- read.csv(here("data", "GDPC1.csv"))
    macro$Y0 <- c(NA, 100*((macro$GDPC1[-1]/macro$GDPC1[-nrow(macro)])^4 - 1))
    macro$GDPC1 <- NULL
    macro$DATE <- as.Date(macro$DATE)
    macro$yq <- zoo::as.yearqtr(macro$DATE); macro$DATE <- NULL
} else if (series == 3) {
    ## CPI inflation
    macro <- read.csv(here("data", "CPIAUCSL.csv"))
    ## 1) quarterly averages
    macro$DATE <- as.Date(macro$DATE)
    macro$yq <- zoo::as.yearqtr(macro$DATE)
    macro <- aggregate(macro$CPIAUCSL, by=list(macro$yq), FUN=mean)
    names(macro) <- c("yq", "CPI")
    ## 2) annualized percent change from previous quarter
    macro$Y0 <- c(NA, 100*((macro$CPI[-1]/macro$CPI[-nrow(macro)])^4 - 1))
    macro$CPI <- NULL
} else if (series == 1) {
    ## unemployment rate
    macro <- read.csv(here("data", "UNRATE.csv"))
    names(macro)[2] <- "Y0"
    macro$DATE <- as.Date(macro$DATE)
    macro$yq <- zoo::as.yearqtr(macro$DATE)
    macro <- aggregate(macro$Y0, by=list(macro$yq), FUN=mean)
    names(macro) <- c("yq", "Y0")
}
macro <- macro[macro$yq >= 1980,]
for (i in 1:7)
    macro[paste0("Y", i)] <- c(tail(macro$Y0, -i), rep(NA, i))

data <- merge(forecasts, macro, all.x=TRUE)

cat("# Start year:", startyear, "\n")
cat("Date range:", range(data$bcyyyymm), "\n")
cat("Greenbooks:", format(range(data$GBdate)), "\n")

diebold_mariano <- function (e1, e2, alternative = c("two.sided", "less", "greater"),
                      h = 1, power = 2) {
    ## based on dm.test from forecast package
    alternative <- match.arg(alternative)
    d <- c(abs(e1))^power - c(abs(e2))^power
    ## Hansen-Hodrick long-run variance
    d.cov <- acf(d, na.action = na.omit, lag.max = h - 1, type = "covariance",
                 plot = FALSE)$acf[, , 1]
    dv <- sum(c(d.cov[1], 2 * d.cov[-1]))/length(d)

    if (dv > 0)
        STATISTIC <- mean(d, na.rm = TRUE)/sqrt(dv)
    else
        stop("Variance of DM statistic is zero")

    n <- length(d)
    k <- ((n + 1 - 2 * h + (h/n) * (h - 1))/n)^(1/2)
    STATISTIC <- STATISTIC * k
    names(STATISTIC) <- "DM"
    if (alternative == "two.sided")
        PVAL <- 2 * pt(-abs(STATISTIC), df = n - 1)
    else if (alternative == "less")
        PVAL <- pt(STATISTIC, df = n - 1)
    else if (alternative == "greater")
        PVAL <- pt(STATISTIC, df = n - 1, lower.tail = FALSE)
    PARAMETER <- c(h, power)
    names(PARAMETER) <- c("Forecast horizon", "Loss function power")
    structure(list(statistic = STATISTIC, parameter = PARAMETER,
        alternative = alternative, p.value = PVAL, method = "Diebold-Mariano Test",
        data.name = c(deparse(substitute(e1)), deparse(substitute(e2)))),
        class = "htest")
}

tbl <- data.frame(matrix(NA, 5, 10))
colnames(tbl) <- c("Horizon", "b(GB)", "se(GB)", "b(BC)", "se(BC)", "R^2", "p(GB=BC)", "RMSE GB", "RMSE BC", "p(RMSE eq)")
for (i in 0:4) {
    if (i <= 3) {
        tbl[i+1, 1] <- paste(i, "quarters ahead")
    } else if (i == 4) {
        tbl[i+1, 1] <- "0-3 quarters average"
        data$Y4 <- rowMeans(as.matrix(data[c("Y0", "Y1", "Y2", "Y3")]))
        data$GB4 <- rowMeans(as.matrix(data[c("GB0", "GB1", "GB2", "GB3")]))
        data$BC4 <- rowMeans(as.matrix(data[c("BC0", "BC1", "BC2", "BC3")]))
    }
    fmla <- formula(paste0("Y", i, " ~ GB", i, " + BC", i))
    mod <- lm(fmla, data)
    tbl[i+1, c(2,4)] <- mod$coef[-1]
    nobs <- length(residuals(mod))
    h <- min(ceiling((i+1)*2), 8) # Hansen-Hodrick lags
    V <- sandwich::vcovHAC(mod, weights=rep(1, h), prewhite=FALSE, adjust=FALSE)
    SEs <- sqrt(diag(V))
    tbl[i+1, c(3,5)] <- SEs[-1]
    tbl[i+1, 6] <- summary(mod)$r.squared
    ## test whether b(GB) > b(BC)
    data$GBpBC <- data[[paste0("GB", i)]] + data[[paste0("BC", i)]]
    fmla2 <- formula(paste0("Y", i, " ~ GBpBC + GB", i))
    mod2 <- lm(fmla2, data)
    V2 <- sandwich::vcovHAC(mod2, weights=rep(1, h), prewhite=FALSE, adjust=FALSE)
    tstats2 <- mod2$coef / sqrt(diag(V2))
    enc_pval <- 2*pt(abs(tstats2[3]), df=nobs-3, lower.tail=FALSE)
    tbl[i+1, 7] <- enc_pval   # two-sided p-value
    ## RMSE
    eGB <- data[[paste0("Y", i)]] - data[[paste0("GB", i)]]
    eBC <- data[[paste0("Y", i)]] - data[[paste0("BC", i)]]
    ind <- !(is.na(eGB) | is.na(eBC))
    RMSE_GB <- sqrt(mean(eGB[ind]^2)); RMSE_BC <- sqrt(mean(eBC[ind]^2))
    tbl[i+1, 8] <- RMSE_GB
    tbl[i+1, 9] <- RMSE_BC
    stopifnot(nobs == sum(ind))
    RMSE_pval <- diebold_mariano(eGB[ind], eBC[ind], h=h)$p.value
    tbl[i+1, 10] <- RMSE_pval
}
tbl[,-1] <- round(tbl[,-1], 2)
tbl <- tbl[,c(1, 8:10, 2:7)]
print(tbl)
