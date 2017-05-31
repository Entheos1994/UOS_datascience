# 2 (a)
steam <-read.table('steam.txt', header = TRUE)
attach(steam)

steam.lm <- lm(formula=y~., data=steam[2:5])
summary(steam.lm)

# library mass 
# ridge regression

library(MASS)
steam.ridge <- lm.ridge(y ~ cg + cd + od + x, lambda = 10)
table1 <- cbind(coef(steam.ridge), coef(steam.lm))
colnames(table1) <- c("Ridge", "OLS")
print(table1)

steam.ridge2 <- lm.ridge(formula=y~., data=steam[2:5],lambda=seq(from=0, to=100, by=1))

matplot(x=t(steam.ridge2$coef),type='l',
        main="Ridge Regression Lambda vs Coefficient Plot",
        xlab="Lambda Values",
        ylab="Coefficients",
        col=c("black","red","blue","green","yellow"))
grid()
legend("topright",legend=rownames(steam.ridge2$coef),  
       fill=c("black","red","blue","green","yellow"),
       bty='n',
       cex=1)

# library lars
# lasso regression
library(lars)
x <- data.frame(steam[,2:5])
train_y <- as.numeric(steam[,1])
train_x <- as.matrix(cbind(1, x))
steam.lasso <- lars(x=train_x, y=train_y, type='lasso', intercept = T, normalize = F)
table2 <- cbind(coef.lars(steam.lasso, s=0, mode='lambda'), coef(steam.lm))
colnames(table2)=c("Lasso","OLS")
print(table2)


# library glmnet
library('glmnet')
steam.glm <- glmnet(y=train_y, x= train_x, alpha=1)
plot(steam.glm, xvar='lambda')
plot(steam.glm, xvar='norm')
plot(steam.glm, xvar='dev')

leg.txt <- c("cg","cd","od","x")
legend("topright",legend=c("cg","cd","od","x"),  
       fill=c("black","red","blue","green"),
       bty='n',
       cex=1)


# cv.glmnet for lambda parameter selection, cross-validation 5 folds
train_x_nointer <- as.matrix(data.frame(steam[,2:5]))

steam.lasso_cv <- cv.glmnet(y=train_y, x=train_x_nointer, alpha=1, nfolds=5)
coef(steam.lasso_cv)
steam.lasso_cv$cvm
steam.lasso_cv$lambda.min
min(steam.lasso_cv$cvm)

steam.ridge_cv <- cv.glmnet(y=train_y, x=train_x_nointer, alpha=0, nfolds=5)
coef(steam.ridge_cv)
steam.ridge_cv$cvm
steam.ridge_cv$lambda.min
min(steam.ridge_cv$cvm)

library(DAAG)
fit <- lm(y~., data=steam)
cv.lm(steam, fit, m=5)

# backwards stepwise regression
librart(MASS)
steam.back <- lm(y ~., data=steam[2:5])
steam.back <- stepAIC(steam.lm, direction = "backward")

cv.lm(steam, steam.back, m=5)


# forwards stepwise regression
steam.null <- lm(y~ 1, data=steam)
steam.forward <- step(steam.null, direction = "forward", scope= ~ + x + cg + cd + od)




(b)
attach(steam)
# linear model without cg term
steam.lm_nocg <- lm(y ~ cd + od + x, data=steam)
summary(steam.lm_nocg)
# linear model without cg and intercept term
steam.lm_nocg_nointer <- lm(y ~ cd + od + x -1, data=steam)
summary(steam.lm_nocg_nointer)
# introduce quadratic / cubic term 
steam.lm_quad <- lm(y ~ cd + od + x + I(x^2), data=steam) # 0.8809
steam.lm_quad2 <- lm(y ~ cd + od + I(od^2) + x + I(x^2), data=steam) # 0.8917
steam.lm_logy <- lm(log(y) ~ cd + od + x, data=steam) # ad-score 0.8885 
steam.lm_logy_nointer <-lm(log(y) ~ cd + od + x - 1, data=steam)


# take log transformation for target y
steam.ridge_cv_logy <- cv.glmnet(y=log(train_y), x=train_x_nointer, alpha=0, nfolds=5)
coef(steam.ridge_cv_logy)
steam.ridge_cv_logy$cvm
steam.ridge_cv_logy$lambda.min
predicted <- predict(steam.ridge_cv_logy, newx=as.matrix(steam[2:5]));
reversed_pred <- exp(predicted)
ms_logy <- sum((reversed_pred - train_y)^2) / 25

#(c) no x variable, no intercept for predicting 
# cg: 0.7, cd:30, od :20, 
# 95% confidence interval

steam.no_x <- lm(y ~ cd+ od + cg - 1, data=steam)
newx <- data.frame(cd=c(30), od=c(20), cg=c(0.7))
newy1 <- predict(steam.no_x, newdata = newx, interval = 'confidence')

steam.no_inter <- lm(y ~ cd + od + cg + x - 1, data=steam)
summary(steam.no_inter)





# press error for steam.lm_quad2 model

steam.lm_quad2 <- lm(y~ cd + od + I(od^2) + x + I(x^2))
X <- cbind(1, cd + od + I(od^2) + x + I(x^2))
H <- X %*% solve(t(X) %*% X) %*% t(X)
DiagH <- diag(H)
PredicedResiduals <- steam.lm_quad2$residuals *(1/1-DiagH)
PRESS <- sum(PredicedResiduals^2)

RSS <- sum(steam.lm_quad2$residuals ^2)


# glm deviance example 
roadbids <- read.table('ROADBIDS.txt', header=TRUE)
roadbids.glm <-glm(STATUS~NUMBIDS+DOTEST, family="binomial")
summary(roadbids.glm)






