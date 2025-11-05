## install dependencies (latest version)
## run this prior to running other scripts

if (!("here" %in% (.packages())))
    install.packages("here") # only do this if not run from run_all.R, which loads here package

install.packages(c("sandwich", "lubridate", "dplyr", "magrittr", "zoo", "quantmod"))
