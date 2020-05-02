# read stock data
dte <-read.csv('~/DTE.csv')

# calculate net return
n <-dim(dte)[1]
attach(dte)
price <- dte$Adj.Close
net_r <- diff(price) / price[1:n-1]
net_r <- net_r * 100
# read Fama-French and get data from 2017/01/03 - 2019/12/30
tmp <- read.csv('~/ff.csv', skip = 4)
start <- which(tmp == 20170103)
end <- which(tmp == 20191230)
factors <- tmp[start:end,]
attach(factors)

# calculate excess return
excess_return <- net_r - RF[2:753]
Mkt.RF <- Mkt.RF[2:753]
SMB <- SMB[2:753]
HML <- HML[2:753]

# linear regression
ff <- lm(excess_return~Mkt.RF+SMB+HML)
summary(ff)
# Question 1 
## check collinearity
library('car')
vif(ff)

## check model assumptions
resid <- rstudent(ff)

## non-normality of errors
### skewness and kurtosis
library("moments")
sk <- skewness(resid)
sk
kurt <- kurtosis(resid)
kurt
### normal probability plot
qqnorm(resid, datax = TRUE)
qqline(resid, datax = TRUE)
### fit a parametric distribution to the resid
library('fitdistrplus')
fitr <- fitdist(resid, distr = 'norm', method = 'mle')
plot(fitr, histo = FALSE, demp = TRUE)
### perform normality tests
#### Shapiro-Wilk test
shapiro.test(resid)
#### Jarque-Bera test
library('tseries')
jarque.bera.test(resid)
#### Anderson-Darling test
library('nortest')
ad.test(resid)
#### Cramer-von Mises test
cvm.test(resid)
#### Kolmogorov-Smirnov test
lillie.test(resid)

## nonconstant variance of errors
plot(ff$fit, resid)
lines(lowess(ff$fit, resid), lwd = 5, col = 'red')

## nonlinearity effects of the predictors on the response
### mkt excess return
plot(Mkt.RF[1:751], resid)
lines(lowess(Mkt.RF[1:751], resid), lwd = 5, col = 'red')
### SMB
plot(SMB[1:751], resid)
lines(lowess(SMB[1:751], resid), lwd = 5, col = 'red')
### HML
plot(HML[1:751], resid)
lines(lowess(HML[1:751], resid), lwd = 5, col = 'red')

# Question 2
CAPM <- lm(excess_return~Mkt.RF)
## BIC
BIC(CAPM)
BIC(ff)

## Adjusted Rsquare
summary(CAPM)
summary(ff)

## Cp
library("leaps")
sup <- c(1:752)
capm_data <- data.frame(excess_return, Mkt.RF, sup)
capm_sub <- regsubsets(excess_return~., data = capm_data)
capm_sum <- summary(capm_sub)
capm_sum$which
capm_sum$cp
## CV & LOOCV test error (10-fold CV & LOOCV)
library('caret')
set.seed(1)
train.control_cv <- trainControl(method = "cv",number = 10)
train.control_loocv <- trainControl(method = "LOOCV", number = 10)
capm_data <- data.frame(excess_return, Mkt.RF)
ff_data <- data.frame(excess_return, Mkt.RF, SMB, HML)
### CV
ff_cv <- train(excess_return~., data = ff_data, method = "lm", trControl = train.control_cv)
capm_cv <- train(excess_return~., data = capm_data, method = "lm", trControl = train.control_cv)
print(ff_cv)
print(capm_cv)
### LOOCV
ff_loocv <- train(excess_return~., data = ff_data, method = "lm", trControl = train.control_loocv)
capm_loocv <- train(excess_return~., data = capm_data, method = "lm",  trControl = train.control_loocv)
print(ff_loocv)
print(capm_loocv)

# Question 3
## subset selection
library("leaps")
ff_sub <- regsubsets(excess_return~., data = ff_data)
ff_sum <- summary(ff_sub)
ff_sum$adjr2
ff_sum$cp
ff_sum$bic
ff_sum$which
ff_sum$outmat

## CV test
library('caret')
set.seed(10)
train.control_cv <- trainControl(method = "cv",number = 10)
### Fama-French
ff_data <- data.frame(excess_return, Mkt.RF, SMB, HML)
ff_cv <- train(excess_return~., data = ff_data, method = "lm", trControl = train.control_cv)
print(ff_cv)
### CAPM
capm_data <- data.frame(excess_return, Mkt.RF)
capm_cv <- train(excess_return~., data = capm_data, method = "lm", trControl = train.control_cv)
print(capm_cv)
### SMB
smb_data <- data.frame(excess_return, SMB)
smb_cv <- train(excess_return~., data = smb_data, method = "lm", trControl = train.control_cv)
print(smb_cv)
### HML
hml_data <- data.frame(excess_return, HML)
hml_cv <- train(excess_return~., data = hml_data, method = "lm", trControl = train.control_cv)
print(hml_cv)
### CAPM + SMB
cs_data <- data.frame(excess_return, Mkt.RF, SMB)
cs_cv <- train(excess_return~., data = cs_data, method = "lm", trControl = train.control_cv)
print(cs_cv)
### CAPM + HML
ch_data <- data.frame(excess_return, Mkt.RF, HML)
ch_cv <- train(excess_return~., data = ch_data, method = "lm", trControl = train.control_cv)
print(ch_cv)
### SMB + HML
sh_data <- data.frame(excess_return, SMB, HML)
sh_cv <- train(excess_return~., data = sh_data, method = "lm", trControl = train.control_cv)
print(sh_cv)
