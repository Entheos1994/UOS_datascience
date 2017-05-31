# exams.csv 
# logistic regression

exams <- read.csv("exams.csv", header=TRUE)
attach(exams)
# model 1 with exam_1 * exam_2 interaction
# lower AIC compared with model 2
exams.glm <- glm(admitted ~ exam_1 + exam_2 + exam_1 * exam_2, data=exams,family="binomial")
coef(summary(exams.glm))
anova(exams.glm)

predicts <- predict(exams.glm, newdata=data.frame(exam_1 = exams['exam_1'], exam_2 = exams['exam_2']), type = "response")
exams.null <- glm(admitted ~ 1, data=exams, family="binomial")

# deviance table
anova(exams.null, exams.glm, test="LRT") # likelihood ratio test for over all model

rss1 <- sum(exams.glm$res ^ 2)
rss2 <- sum(exams.null$res ^ 2)
f_test <- ((rss2 - rss1) / (4 - 1)) / (rss1 / (100-4))
# hosmer-lwewshowz test 
library(ResourceSelection)
hl <- hoslem.test(admitted, fitted(exams.glm), g=2) # fit 


sum(exams.glm$res^2)
# (b)
# model 2 no interaction term
exams.glm2 <- glm(admitted ~ exam_1 + exam_2, data=exams, family='binomial')

# probability predict
# p1 using interaction term
newdata <- data.frame(exam_1 = 62, exam_2 = 62)
p1 <- predict(exams.glm, newdata, type="response")
p2 <- predict(exams.glm2, newdata, type="response")

# (c)
# PRESS statistics for two model
preds <- fitted(exams.glm)

X <- cbind(1, exams$exam_1, exams$exam_2)
exams_H <- X %*% solve(t(X) %*% X) %*% t(X)
exams_Diag_H <- diag(exams_H)
exams_residuals1 <- exams.glm$residuals * (1/(1-exams_Diag_H))
exams_residuals2 <- exams.glm2$residuals * (1/(1-exams_Diag_H))

exams_Press1 <- sum(exams_residuals1^2)
exams_Press2 <- sum(exams_residuals2^2)

(d)
# deviance test
# 1 - pchisq
# D = 2 fau(Ifull - I mod)

1-pchisq(exams.glm2$deviance - exams.glm$deviance, exams.glm2$df.residual - exams.glm2$df.residual)
1-pchisq(exams.glm$deviance - exams.glm2$deviance, exams.glm$df.residual - exams.glm$df.residual)

# plot residuals with glm1

preds <- fitted(exams.glm)
plot(preds, exams.glm$residuals, pch=16, xlab='Predictions', ylab='Residuals', main='Scatter of Residuals')
text(0.1,15, '10')
text(0.8, -5, '28')
abline(h=0, lty=2,col='grey')


hist(exams.glm$residuals, xlim=c(-10,20), xlab='Residuals', main='Histogram of Residuals') # an outlier

# qq plot 
# standardized residual
# whether the residuals are normally distributed
# not a straight line
exams.stdres <- rstandard(exams.glm)
qqnorm(exams.stdres, 
       ylab='Standardized Residuals',
       xlab='Normal Scores',
       main='QQ plot')
qqline(exams.stdres)
