# MATH6157 CW2
# ID:28247418
# STUDENT: Han Zhang
# email: hz1u16@soton.ac.uk


# 1. Mixed model
# (a)
## glm fitting for various data combination 
library(MASS)
bacteria
attach(bacteria)
bac.glm1 <- glm(y ~ week + trt + ID, family=binomial, data=bacteria) # resid: 118.5 # AIC: 220.5
summary(bac.glm1)
# full model fitting
# summary shows that only the week variable has significant influence on the full model which can be observed from p values (<0.5),
# while other varibles are all inrelevant to the model, their p values way bigger than 0.5,
# so that this model is not appropreiate with extra noise

bac.glm2 <- glm(y ~ trt + ID, family=binomial, data=bacteria) # resid: 131.3 # AIC: 231.5
bac.glm3 <- glm(y ~ week + ID, family=binomial, data=bacteria) # resid: 118.5 # AIC:220.5
bac.glm4 <- glm(y ~ trt + week, family=binomial, data=bacteria) # resid: 203.8 # AIC 211.8
bac.glm5 <- glm(y ~ trt * week, family=binomial, data=bacteria) # resid: null # AIC: 215.12
bac.glm6 <- glm(y ~ trt, family=binomial, data=bacteria) # resid: null # AIC: 216.72

summary(bac.glm2)
summary(bac.glm3)
summary(bac.glm4)
summary(bac.glm5)
summary(bac.glm6)
# general fitting for various models
# from above summaries, the best model can be selected by comparing AIC, the lower the better
# "bac.glm4" gives the lowest AIC value of 203.8
# apparetnly the variable ID can be dropped out since it decrease the performance


# evaluate whether particular value of variable treatment influence model
# here we check the treatment of 'placebo'
bac.glm7 <- glm(y ~ I(trt != 'placebo') + I(trt == 'placebo'), family=binomial, data=bacteria)
bac.glm8 <- glm(y ~ week + I(trt != 'placebo'), family=binomial, data=bacteria)
summary(bac.glm7)
summary(bac.glm8)
# above summary information can see that a particular value 'placebo' of variable treatment don't affect the prediciton

# evaluate whether particular value of variable week influence model
# here we check the value of week which whether bigger than 2
bac.glm9 <- glm(y ~ trt + I(week > 2), family=binomial, data = bacteria) # AIC 207.18
summary(bac.glm9)
# summary information shows that weeks more than 2 (4, 6, 11) are more important than other weeks (0, 2)

par(mfrow=c(1,1))
qqnorm(resid(bac.glm4))
qqline(resid(bac.glm5))
# normal probability plot 
# the residual probability plot is skewed, each point represent the difference between prediction and actual value,
# the residual on the left hand is much away from diagonal line, this suggest that the residualas are severly skewed to the left.


# (b) random effect
# adding extra variability between variables
# nACQ = 1, corresponds to a Laplace approximation.

# treat the variable of week as random effect error
# evaluate whether the parameter 'nAGQ' have influence on our model
library(lme4)
bac.glmm1 <- glmer(y ~ trt + (1 | week), family=binomial, data=bacteria, nAGQ = 1) # 225.6
bac.glmm2 <- glmer(y ~ trt + (1 | week), family=binomial, data=bacteria, nAGQ = 25) # AIC 225.6
summary(bac.glmm1)
summary(bac.glmm2)
# summary shows that nAGQ does not affect the model


# treat the variable of ID as random effect error
bac.glmm3 <- glmer(y ~ trt + (1 | ID) + week, family=binomial, data=bacteria, nAGQ = 1) # 207.8
bac.glmm4 <- glmer(y ~ trt + (1 | ID), family=binomial, data=bacteria, nAGQ = 1 ) # 214.3
bac.glmm5 <- glmer(y ~ trt + (1 | week), family = binomial, data=bacteria,nAGQ = 1) # 216.5
summary(bac.glmm3)
summary(bac.glmm4)
summary(bac.glmm5)
# summary information reveals that model 'bac.glmm3' has the lowest AIC value (207.8), it performs better than comparing with other glmm models
# the previous selected model 'bac.glmm4' performs a little bit worse than 'bac.glm9' (207.8 > 207.13)

# (c) hypothesis 
bac.glmmwith <- glmer(y ~ trt + week + (1 | ID), family=binomial, data=bacteria, nAGQ = 1)
bac.glmmwihtout <- glm(y ~ trt + week, family=binomial, data=bacteria)
anova(bac.glmmwith, bac.glmmwihtout)
# one model is constructed with random effect in terms of Id and other model is constructed without variable ID
# since these two models are nested, here we conduct a chi-square test to see whether there is a residual reduction from one model to another model
# the test on variable random effect shows that the model with random effect results in less residual 
# such hypothesis can be indicated by p value (0.01402), hence, the null hypothesis can not be rejected and there is an obvious difference between two models
# overall, the model with random effect can be viewed a better model.

# (d) predict
# three new levels "X22", "Y15", "Z28"
# construct 15 new data points for five weeks and three treatments
newvalue <- data.frame(week=c(0, 2, 4, 6, 11, 0, 2, 4, 6, 11, 0, 2, 4, 6, 11),
                       ID=c("X22","X22","X22","X22","X22","X22","X22","X22","X22","X22","X22","X22","X22","X22","X22"),
                       trt=c("placebo","placebo","placebo","placebo","placebo","drug","drug","drug","drug","drug","drug+","drug+","drug+","drug+","drug+"))

bac.predict <- glmer(y ~ trt + week + (1 | ID), family =binomial(link='logit'), data= bacteria, nAGQ=1) # AIC 207.8
predicted <- predict(bac.predict, newdata=newvalue, type='response', re.form=NA) 
plot(predicted)
# the predicts for new patients will be all labeled with positive which means the bacteria still can be observed.
# new patients given by treatment of placebo gives the highest probability for the presence of bacteria where as patients getting treated by 'drug+' results in lowest probabilities.
# evaluate the results within same treatment group, the earlier the patients getting treatment, the higher the porbilities they are keep the bacteria


# (e)
# ignore week, aggregate values across treatment and ID
ignore_week <- aggregate(as.integer(bacteria$y)-1, by=list(bacteria$trt, bacteria$ID), FUN=mean)
# rename the dataframe
colnames(ignore_week) <- c("trt", 'ID', 'y');

ignore_week.glm1 <- glmer(y ~ trt + (1 | ID), family=binomial, data=bacteria, nAGQ=1);
summary(ignore_week.glm1) # AIC 214.3
ignore_week.predict <- predict(ignore_week.glm1, newdata=newvalue, type='response', re.form=NA);

# the prediction seems differ from previous model, since the patients are no longer affected by the variable week, the only factor would be treatment.
# patients who given treatment of placebo still have the highest probabilities(0.908) of bacteria observed, but a little bit lower than the previous model who results in 0.958
# considering other treatments, the week variable has interact influence to the performance,
# take a example of the treatment of 'drug', where the positive probabilities predcited by the model without week variable is lower 10 % than previous model
# one conclusion is that the variable of week does affect the performance of bacteria prediction and should not be removed from the model. 
# the other concolusion is that the treatment of placebo is relatively poorer solution for resisiting bacteria no matter the how long the time goes by.

detach(bacteria)

# 2. smooth regression
#(a) construct data  
library('faraway')
aatemp
tempdf <- aatemp[4:115, c('year', 'temp')]
temp <- tempdf$temp
year <- tempdf$year
par(mfrow=c(1,1))
plot(year,temp)
# not a significant arises for temperature from 1880 to 2000 year.

# (b)
# simple linear model
tempdf.lm <- lm(temp ~ year)
plot(year, temp, main = 'scatter / fitted line',cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
abline(tempdf.lm)
# a straight line can be drawed with fitted value from simple linear model.

# (c)
# c(i) apply the smooth method: 'local weighted regression' 
tempdf.loess <- loess(temp ~ year, tempdf, span=0.75)
plot(year, temp, main = 'Smooth function span with 0.75', cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
lines(year, tempdf.loess$fitted, lwd=3)
# the proportion of data points used for local fit is set by the parameters
# lower value turns out a complexity model with more variables


# c(ii) cross-validation for tuning span parameter
library(bootstrap)
?crossval

# helper function 
loess_fit <- function(x, y, span){
  loess(y ~ x, span=span)  
}

loess_pred <- function(loess, x){
  predict(loess,x)
}

# 20 replicate / 10 fold group
# span tuned from 0.1 - 0.5 by 0.05 interval
span_vector <- seq(0.1 , 0.5, by=.05);
mse_mat <- matrix(NA, nrow = length(span_vector), ncol=2)
len <- length(temp);
for (i in 1:length(span_vector)){
  span <- span_vector[i];
  mse_temp <- numeric(20);
    for (R in 1:20){
      cv <- crossval(year, temp, loess_fit, loess_pred, span, ngroup = 10);
      fitted <- cv$cv.fit;
      index <- which(!is.na(fitted));
      mse <- sum((fitted[index] - temp[index])^2);
      mse_temp[R] <- mse;
    }
  mse_mat[i,][1] <- span;
  mse_mat[i,][2] <- mean(mse_temp);
  
}

# plot parameter 
par(mfrow = c(1,2), pty = "s", cex.axis=1, cex.lab= 1)
plot(mse_mat, typ = 'l', lwd=2, cex.lab=2.5, cex.axis=1.5, cex.main = 1.5, pty='s', main='loess span tunning')
tempdf.best_loess <- loess(temp ~ year, span=0.15);
# with cross-validation, the model gives the lowest mse with span of 0.15


# fitting line 
plot(year, temp, main = 'Smooth function span with 0.15', cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
lines(year, tempdf.best_loess$fitted, lwd=3)
# the model seems overfitting a lot since the fitted line curved a lot and not smooth.


# kernel smooth (codes from lecture)
library(cvTools)
cv <- function(dataset, smooth.function, bandwidth.grid, K = 10, R=20)
{
  n <- nrow(dataset)
  mse <- matrix(NA, nrow = length(bandwidth.grid), ncol=2)
  for (b in 1:length(bandwidth.grid)){
    cv.R <- rep(0,R)
    for (r in 1:R){
      folds <- cvFolds(n, K)
      cv.value <- rep(0,K)
      for (k in 1:K){
        train <- dataset[folds$subsets[folds$which != k], ]
        test <- dataset[folds$subsets[folds$which == k], ]
        funcargs <- list(reg.x = train[, 1], reg.y = train[, 2], x.p = test[, 1],
                         h = bandwidth.grid[b])
        temp.pred <- do.call(smooth.function, funcargs)
        cv.value[k] <- mean((test[order(test[, 1]), 2] - temp.pred)^2)
      }
      cv.R[r] <- mean(cv.value)
      
    }
    mse[b, ] <- c(bandwidth.grid[b], mean(cv.R))
  }
  colnames(mse) <- c("Bandwidth", "MSE")
  return(mse)
}

ksmoothCV <- function(reg.x, reg.y, x.p, h){
  return(ksmooth(x = reg.x, y = reg.y, x.point = x.p, kernel = 'normal', bandwidth = h)$y)
}
# cv for parameter
temp.cv <- cv(tempdf, ksmoothCV, seq(1, 15, by= 1), R = 100)

# best kernel smooth
tempdf.kernel <- ksmooth(year, temp, kernel='normal', bandwidth = 6)

# plot 
par(mfrow = c(1,2), pty='s')
plot(temp.cv, typ='l', lwd=2, cex.lab = 1.5, cex.axis=1.5, cex.main = 1.5, pty='s', main='kernel smoother parameter')
plot(year, temp, main='kernel smooth');
lines(tempdf.kernel, lwd=2, main='kernel smooth')
# the kernel bandwith results in lowest mse at 7
# the fitted line still seems overfitting a lot

# R square calculation
# total residual
SST <- sum((temp - mean(temp))^2)

linear_r2 <- summary(tempdf.lm)$r.squared
loess_r2 <- 1- sum(tempdf.loess$residuals^2) / SST
best_loess_r2 <- 1 - sum(tempdf.best_loess$residuals^2) / SST
kernel_r2 <- 1 - sum((tempdf.kernel$y - temp)^2) / SST
models <- c("linear", "loess_0.75", "loess_0.15", "kernel_6")
# display 
r2_vector = c(linear_r2, loess_r2, best_loess_r2, kernel_r2)
cbind(models, r2_vector)

# r^2 can be used to select model, it determines how much variance can be interpreted from input to output
# according to r^2 value, the smmother method 'loess' with 0.15 span is the best function for this data set (r^2 achieving 0.457)
# however, we knows that as the number of parameters in the model approaches the number of data points, the model will be better able to accurately fit the dataset.
# so that there is a tradeoff bettween the explanation of variance and complexity, although linear model results in the lowest r^2 value, it has the highest number of freedom.
# thus, the simple model normally has good generalization on unseen data.
# on the other side, since loess function will fits polynomial regression models using data "near" x, the model becomes accurately but way more complex
# such a model virtually has less analytical usefulness.



# 3.Design and smoothing non-normal data
# (a)
set.seed(28247418)

# load library 'SLHD', generate maximin latin hypercube design with n = 100 in 10 variables
library(SLHD)
Mmdesign <- maximinSLHD(1, 100, 10)

# boxplot shows that maximin design generate data that completely normal distributed. 

par(mfrow=c(1,1))
boxplot(Mmdesign$StandDesign, names=c("x1", "x2", "x3","x4","x5","x6","x7","x8","x9","x10"), main="1d Projection")

#(b)
library(lhs)

# function eud can calculate inner-point euclidean distance
# one design 
mlhd <- maximinSLHD(1, 100, 10);
rlhd <- randomLHS(100, 10);
udd <- matrix(runif(1000), nrow=100);

eud <- function(design)
{
  min <- 10000;
  for (m in 1:9)
  {
    for (n in m+1:10){
      temp <- dist(rbind(design[m,], design[n,]))
      if (temp < min){
        min <- temp
      }
    }
  }
  return(min)
}

# initial distance vector
# rlhd denotes random latin hypercube
# udd denotes uniform distribution
rlhd_dis <- NULL;
udd_dis <- NULL;

for (i in 1:1000)
{
  print(i)
  rlhd <- randomLHS(100, 10);
  udd <- matrix(runif(1000), nrow=100);
  rlhd_dis[i] <- eud(rlhd);
  udd_dis[i] <- eud(udd);
}

# plot histogram 

# h1, m1 denotes the random latin hypercube distances distribution and mean value
par(mfrow = c(1,2), pty = "s")
h1 <- hist(rlhd_dis)
m1 <- mean(rlhd_dis)
abline(v =m1, col = "blue", lwd = 2)
text(m1-0.1, 200, '0.6726')

# h2, m2 denotes the uniform sampling distance distribution and mean value
h2 <- hist(udd_dis)
m2 <- mean(udd_dis)
abline(v=m2, col='blue', lwd=2)
text(m2-0.1, 200, '0.6677')
# from above histogram we can see that the minimum distance of two designs not disteibuted equally
# they both tends to left skewed with mean value of 0.6726 for random latin hypercube and a lower mean value of 0.6677 for uniform sampling

par(mfrow = c(1,3), pty = 's')
plot(mlhd$StandDesign, xlim=c(0,1), ylim=c(0,1), pty='s', xlab=expression(x[1]), ylab=expression(x[2]), pch=16, main='maximin')
plot(rlhd[,1], rlhd[,2], pch=16, main='random')
plot(udd[,1], udd[,2], pch=16, main='uniform')

# since the computer experiments apply a principle of space-filling to desgin points
# the scatter plot shows a straight view of the dsitance between inner-point in different desgins
# the uniform sampling seems to miss the principle badly, there are lots of white space between data points which indicate the data sample tends to generated with clustering. 
# on the other hand, the latin hypercube designs perform relative well for spreading out the desigin points sufficiently.



# (c)
# set cwd to path where math6157Cwk2.RData store
# laod data
load('math6157Cwk2.RData')
set.seed(28247418)
# generate random target value with given function
target <- math6157Cwk2Data(data.frame(mlhd$StandDesign))



# (d)
library(mgcv)

par(mfrow=c(2,5))
# plot the results and the generate LHD
for (i in 1:10)
{
  plot(target, mlhd$StandDesign[, i], pch=16)
}
# we can see that the target value does not distributed normally, where more than half values equals to 10.
# most variables seems do not have a seeable correlation with target y.
# the 3rd variable seems have postive correlation with target y and the 6th variable might have a negative correlation with target y.

gam.frame <- data.frame(target, mlhd$StandDesign)
smooth.formula <- as.formula(paste("target~", paste("s(X", 1:10, ")", sep="", collapse="+")))
gam.gam <- gam(smooth.formula, data=gam.frame)
summary(gam.gam)
# r^2 results in 0.564, not a good value but acceptable.
# the summary information again verities that most variable have no correlation with target y expect variable X3, X6 and X8
# who turns out being significanly importance in the model

# effect plots for full model
par(mfrow = c(2, 3), pty = 's')
for(i in 1:5) plot(gam.gam, residual = T, rug = F, select = i)
par(mfrow = c(2, 3), pty = 's')
for(i in 6:10) plot(gam.gam, residual = T, rug = F, select = i)


# model comparison:
# keep three significant variables X3, X6 and X8, remove others
gam.gam2 <- gam(target ~ s(X3) + s(X6) + s(X8) , data=gam.frame)
summary(gam.gam2)
anova(gam.gam2, gam.gam, test="Chisq")

# the anova with chi-square test can be used to compare two models with nested variables.
# it aims to measure the difference of the degrees of freedom, so is there is a significant difference between two models
# then we can reject the null hypothesis which suggests the two models are different, and the more complex model is fitting the data better without freedom concerning
# however, in this case, the high p value (0.6735) tells that the null hypothesis should be rejected which means the full model with more variables does not improve the prediction significanly
# thus, we should abandon those unnecessary variables. 


# effect plots for reduced model
par(mfrow = c(1,3), pty = 's')
for(i in 1:5) plot(gam.gam2, residual = T, rug = F, select = i)
# a obvious correlation can be viewed in effect plots
# where variable X3 and X8 has positive relationship and X6 has negative relationship against the target y.

# residual qq plot
par(mfrow = c(1,2), pty = 's', cex.lab = 1.5, cex.axis=1.5, cex.main=1.5, lwd=2)
plot(residuals(gam.gam2) ~ predict(gam.gam2), xlab = 'Predicted', ylab = 'Residuals', pch=16)
abline(h = 0)
qqnorm(residuals(gam.gam2), main = "Q-Q")
qqline(residuals(gam.gam2))
# the plot on the left shows the residual plot of the reduced model
# although some of residuals located around zero, they are not distributed normally in total.
# however, the residual plot seems exhibits heteroscedasticity the opposite way, in which case the residuals get larger as the prediciton being smaller.
# the heteroscedasticity reveals the inapproproiate standard errors which can be fixed with target transformation.
