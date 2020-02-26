# read data DTE.csv
dte <- read.csv("~/DTE.csv")
attach(dte)
names(dte)

# Adj.close and log return
plot(Adj.Close)
# calculate dimension and log return
n <- dim(dte)[1]
ldte <- log(Adj.Close[-1] / Adj.Close[-n])
plot(ldte)

# moments of log return
m <- mean(ldte)
s <- sd(ldte)
library("moments")
sk <- skewness(ldte)
kt <- kurtosis(ldte)

# test of normality
# qqplot and line first
qqnorm(ldte, datax = TRUE)
qqline(ldte, datax = TRUE)
# fitting a parametric distribution
library("fitdistrplus")
fitn <- fitdist(ldte, distr = "norm", method = "mle")
summary(fitn)
plot(fitn, histo = FALSE, demp = TRUE)
# normsality tests
# Shapiro-Wilk 
shapiro.test(ldte)
# Jarque-Bera
library("tseries")
jarque.bera.test(ldte) # in tseries
jarque.test(ldte) # in moments
library("nortest")
# Anderson-Darling
ad.test(ldte)
# Cramer-von Mises
cvm.test(ldte)
# Kolmogorov-Smirnov
lillie.test(ldte)

# scaled distribution
library("metRology")
fitt <- fitdist(ldte, distr = "t.scaled", method = "mle", start = list(df = 3, mean = m, sd = s * sqrt((3 -2) / 3)))
summary(fitt)
plot(fitt, histo = FALSE, demp = TRUE)
