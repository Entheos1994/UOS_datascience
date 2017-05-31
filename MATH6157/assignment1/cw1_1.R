# 1.1 simple linear 
weights <- c(2.99, 3.04, 3.23, 3.60, 3.98, 4.50, 4.60, 4.95, 5.05, 5.35, 5.62, 5.95, 6.09, 6.28, 6.69)
ages <- c(1, 2, 3, 5, 6,9, 10, 11, 12, 13, 14, 16, 17, 20, 22)
df <- data.frame(ages, weights)
df.lm <- lm(weights ~ ages)

weights2 <- c(2.99, 3.04, 3.23, 3.60, 3.98, 4.50, 4.60, 4.95, 5.05, 5.35, 5.62, 5.95, 6.09, 6.28)
ages2 <- c(1, 2, 3, 5, 6,9, 10, 11, 12, 13, 14, 16, 17, 20)


summary(df.lm)
plot(ages, weights, ylim=c(2,8), main='Scatter plot')
abline(lm(weights~ages))
plot(df.lm)

# quadratic regression
df.lm2 <- lm (weights ~ ages + I(ages^2))
fitted2 <- fitted(df.lm2)
lines(ages, fitted2, type='l', col='red')
summary(df.lm2)

# cubic regression
df.lm3 <- lm (weights ~ ages + I(ages^2) + I(ages^3))
fitted3 <- fitted(df.lm3)
lines(ages, fitted3, type='l', col = 'green3')
summary(df.lm3)

df.lm4 <- lm(weights ~ ages -1)
fitted4 <-fitted(df.lm4)
lines(ages, fitted4, type='l', col='blue3')

df.lm5 <- lm(weights ~ ages + I(ages^2) + I(ages^3) + I(ages^4))

# predict
newx <- data.frame(ages=c(26))
newy1 <- predict(df.lm, newdata=newx)
newy2 <- predict(df.lm2, newdata=newx)
newy3 <- predict(df.lm3, newdata=newx)


newy1 <- predict(df.lm, newdata=newx, interval='predict')
newy2 <- predict(df.lm2, newdata=newx, interval='predict')
newy3 <- predict(df.lm3, newdata=newx, interval = 'predict')


# improvement
df.lm_log <- lm(log(weights) ~ ages)
summary(df.lm_log)

df.lm3_short <- lm(weights2 ~ ages2 + I(ages2^2) + I(ages2^3))
summary(df.lm3_short)