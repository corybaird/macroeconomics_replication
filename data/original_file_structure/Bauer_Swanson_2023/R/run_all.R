## run all R scripts to reproduce tables in paper and Online Appendix

install.packages("here")
here::i_am("R/run_all.R")
library(here)

source(here("R", "setup.R"))

source(here("R", "tables_6_7.R"))

cat("# Table 8\n")
lagbc <- 2; startyear <- 1990
series <- 1
source(here("R", "table_8.R"))
series <- 2
source(here("R", "table_8.R"))
series <- 3
source(here("R", "table_8.R"))

## Appendix Tables
startyear <- 1980
cat("# Table E.1\n")
lagbc <- 2
series <- 1
source(here("R", "table_8.R"))
series <- 2
source(here("R", "table_8.R"))
series <- 3
source(here("R", "table_8.R"))
cat("# Table E.2\n")
lagbc <- 3
series <- 1
source(here("R", "table_8.R"))
series <- 2
source(here("R", "table_8.R"))
series <- 3
source(here("R", "table_8.R"))
cat("# Table E.3\n")
lagbc <- 1
series <- 1
source(here("R", "table_8.R"))
series <- 2
source(here("R", "table_8.R"))
series <- 3
source(here("R", "table_8.R"))
