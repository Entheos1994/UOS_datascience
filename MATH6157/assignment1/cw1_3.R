library(evir)
day1772 <- read.table('cetdl1772on.dat')

days <- c('V2','V3','V4','V5','V6','V7','V8','V9','V10','V11','V12','V13','V14')

max(day1772[day1772[, 'V1'] == 1772, days])

max_vector = c
for (year in 1901:2000){
  max_vector <- c(max_vector, max(day1772[day1772[, 'V1'] == year, days]))
}

max_vector <- unlist(max_vector[2:101])
year_vector <- seq(1901,2000) 

df <- data.frame(year_vector, max_vector)
df.gumbel <- gumbel(df[, 'max_vector']) #
b <- df.gumbel$par.ests['sigma'] 
a <- df.gumbel$par.ests['mu']
p <- 0.1 # probability of exceeding threshold value x
limit <- a - b * log(-log(1-p)) # return period of 10 years
limit2 <- a + b * log(10) # fundamental formula for flood control

# plot maximum temperature data
plot(df[, 'max_vector'], ylim=c(0,300), pch=19, main='Annual Maximum temperature')
# points(50, limit, col='red', pch=19)
abline(limit,0,col='red')
text(60,240,'Limit',col='red')


hist(df[, 'max_vector'], xlab='Temperature', ylab='Frequency', main='Extreme value distribution')
# par(new=TRUE)
plot(limit,col='red',add=TRUE)




# b mean month data
library(tseries)
month1659 <- read.table('cetml1659on.txt', header = TRUE)
row.names(month1659) <- month1659[, 'Y']
month1659[, 'Y'] <- NULL
month1659[,'YEAR'] <-NULL

month_data <- c()
for (year in 2001:2016){
  month_data <- c(month_data, as.numeric(month1659[as.character(year),]))
}
temp <- data.frame(month_data)
temp_ts <- ts(temp)


summary(temp_ts)

plot(temp_ts, xlab='Months', ylab='Temperature (°C)', main='Monthly Temperature series')

acf(temp_ts) # dies away geometrically, may be appropriate for autoregressive model
              # clearly most lags are more than 5%, so not a white noise process.
pacf(temp_ts,  main='temperature pacf') # a

library(forecast)
plot(ma(temp_ts, 12))
plot(temp_ts - ma(temp_ts, 12))
# ts model

temp_ts.arma <- arma(temp_ts, order = c (2,4))
summary(arma(temp_ts, order = c(2,4)))
summary(arma(temp_ts, order = c(2,2)))
temp_ts.arma <- arma(temp_ts, order = c (2,2))
plot(temp_ts.arma$residuals, ylab='Residual', main='ARMA residual')
hist(temp_ts.arma$residuals, xlab='Residual', main='ARMA residual')

# confidence intervals 
library('forecast') # load package forecast
temp_ts.arima <- arima(temp_ts, order=c(2,0,2))
temp_ts.forecast_prediction <- forecast.Arima(temp_ts.arima, h=7)
temp_ts.forecast_interval <- forecast.Arima(temp_ts.arima, h=7, calc.ci=TRUE)


forecast(temp_ts.arima,levels= 0.95)

temp_ts.forecast <- forecast.Arima(temp_ts.arima, h=7)
plot.forecast(temp_ts.forecast, fcol='black', shaded=TRUE, shadecols=c('orange', 'red'), main='Temperature Forecast', ylab='Temperature', xlab='Months')

predict(temp_ts.arima, data.frame())

temp_ts.arima_log <- arima(log(temp_ts), order=c(2,0,2))
temp_ts.log_forecast <- forecast.Arima(temp_ts.arima_log, h =7)
plot.forecast(temp_ts.log_forecast, fcol='black', shaded=TRUE, shadecols = c('orange', 'red'))
