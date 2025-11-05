library(remotes)
library(tidyr)
library(dplyr)
library(ggplot2)


# Instal VAR external instrument package
remotes::install_github("angusmoore/varexternalinstrument")
library(vars)
library(varexternalinstrument)



data(GKdata)

GKdata


gkvar <- VAR(GKdata[, c("logip", "logcpi", "gs1", "ebp")], p = 12, type = "const")

shockcol <- externalinstrument(gkvar, GKdata$ff4_tc, "gs1")
shockcol



ma_representation <- Phi(gkvar, 50)
irfs <- apply(ma_representation, 3, function(x) x %*% shockcol)
irfs <- as.data.frame(t(irfs))

colnames(irfs) <- names(shockcol)


irfs <- mutate(irfs, horizon = 0:50)
irfs <- gather(irfs, key = variable, value = response, -horizon)
ggplot(irfs, aes(x = horizon, y = response, group = variable, color = variable)) + geom_line()







