rm(list=ls())
#install.packages(c("haven", "forecast", "tseries", "lmtest", "nortest"))
library(readxl)
library(ggplot2)
library(forecast)
library(tseries)
library(lmtest)
library(nortest)
datos <- read_excel("data.xls") #leo los datos
head(datos)
hicp_italia <- ts(datos$IT, start = c(1996, 1), frequency = 12) #creo la serie
temporal par Italia
##############################################################################
########################## 1. REPRESENTAR LA SERIE ##########################
##############################################################################
ggplot(datos, aes(x = ...1, y = IT)) +
  geom_line() +
  labs(title = "Evolucion del HICP - Italia",
       x = "Fecha", y = "HICP") +
  theme_minimal()
##############################################################################
######### 2. SELECCION DE PERIODO DE ENTRENAMIENTO Y PREDICCION #############
##############################################################################
train <- window(hicp_italia, end = c(2010, 12))
plot(train)
test <- window(hicp_italia, start = c(2011, 1), end = c(2012, 5))
plot(test)
##############################################################################
################### SELECCIONANDO EL MODELO ARIMA A MANO #####################
##############################################################################
##############################################################################
########################## 3. TRANSFORMACION Y ARIMA ########################
##############################################################################
#Estabilizamos la varianza
(lambda = forecast::BoxCox.lambda(train))
#Como el valor de lambda es practicamente -1, esto sugiere que las fluctuaciones
aumentan
#con el nivel de la serie.
train_transf = forecast::BoxCox(train,lambda)



plot(train_transf)
#Estabilizamos la media
#Primero usamos lag=12 para eliminar estacionalidad
(ndifes = nsdiffs(train_transf)) #D = 1
dif_es = diff(train_transf, lag=12, differences=ndifes)
plot(dif_es)
#Y luego usamos lag=1 para eliminar tendencia
(ndif = ndiffs(dif_es)) #d = 1
dif_es_sim = diff(dif_es, lag=1, differences=ndif)
plot(dif_es_sim)
length(dif_es_sim)
dif_ts = ts(dif_es_sim)
#Veamos ahora las autocorrelaciones
#Calculamos la FAS
acf(dif_es_sim, lag.max = 200, plot=TRUE)
#Calculamos la FAP
pacf(dif_es_sim, lag.max = 200, plot=TRUE)
#ARIMA(0,1,0)(1,1,1)[12]
modelo = Arima(train, order=c(0,1,0),
               seasonal=list(order=c(1,1,1), period=12))
predicciones = forecast(modelo, length(test))
plot(predicciones)
lines(test, col = "red")
# Diagnostico del modelo
checkresiduals(modelo)
shapiro.test(residuals(modelo))
lillie.test(residuals(modelo))
runs.test(as.factor(residuals(modelo) > median(residuals(modelo))))
##############################################################################
########################## 4. PREDICCIONES ARIMA ############################
##############################################################################
# se predicen 17 meses (enero 2011- mayo 2012)
# se comparan las predicciones con los datos reales y con el suvizado exponencial
:
  pred_arima <- forecast(modelo, h = length(test))
autoplot(pred_arima) +
  autolayer(test, series = "Observado", color = "red") +
  ggtitle("Prediccion del HICP Italia (2011-2012) con modelo ARIMA (0,1,0)(1,1,1)
[12]") +
  ylab("HICP") +
  xlab("Ano") +
  guides(colour = guide_legend(title = "Serie"))

###############################################################################
########################## 5. MODELOS ETS (SUAVIZADO) #######################
##############################################################################
modelo_ets <- ets(train)
pred_ets <- forecast(modelo_ets, h = length(test))
autoplot(pred_ets) +
  autolayer(test, series = "Observado", color = "red") +
  ggtitle("Prediccion del HICP Italia (2011-2012) con ETS automatico") +
  ylab("HICP") +
  xlab("Ano") +
  guides(colour = guide_legend(title = "Serie"))
##############################################################################
####################### 6. MEDIDAS DE EVALUACION Y COMPARACION ##############
##############################################################################
accuracy_arima <- accuracy(pred_arima, test)
accuracy_ets <- accuracy(pred_ets, test)
print("Evaluacion modelo ARIMA:")
print(accuracy_arima)
print("Evaluacion modelo ETS:")
print(accuracy_ets)
##############################################################################
#################### SELECCIONANDO EL MODELO ARIMA AUTO ######################
##############################################################################
##############################################################################
########################## 3. TRANSFORMACION Y ARIMA ########################
##############################################################################
#el modelo lo selecciona automaticamente ARIMA, ajustado sobre la serie
transformada con Box-Cox y diferenciada segun necesidad.
#Se elige con auto.arima() evaluando AICc.
# Box-Cox -> para estabilizar la varianza
(lambda <- BoxCox.lambda(train))
hicp_transf <- BoxCox(train, lambda)
# Diferenciacion estacional y simple -> para estabilizar la media
ndifes <- nsdiffs(hicp_transf)
hicp_diff_seasonal <- diff(hicp_transf, lag=12, differences=ndifes)
ndif <- ndiffs(hicp_diff_seasonal)
hicp_diff_final <- diff(hicp_diff_seasonal, lag=1, differences=ndif)
# Modelo automatico ARIMA
modelo_arima <- auto.arima(train, lambda = lambda, seasonal=TRUE)

summary(modelo_arima)
# Diagnostico -> validacion mediante tests:
checkresiduals(modelo_arima)
shapiro.test(residuals(modelo_arima))
lillie.test(residuals(modelo_arima))
runs.test(as.factor(residuals(modelo_arima) > median(residuals(modelo_arima))))
##############################################################################
########################## 4. PREDICCIONES ARIMA ############################
##############################################################################
# se predicen 17 meses (enero 2011- mayo 2012)
# se comparan las predicciones con los datos reales y con el suvizado exponencial
:
  pred_arima <- forecast(modelo_arima, h = length(test))
# Visualizar prediccion ARIMA vs datos reales
autoplot(pred_arima) +
  autolayer(test, series = "Observado", color = "red") +
  ggtitle("Prediccion del HICP Italia (2011-2012) con modelo ARIMA") +
  ylab("HICP") +
  xlab("Ano") +
  guides(colour = guide_legend(title = "Serie"))
##############################################################################
########################## 5. MODELOS ETS (SUAVIZADO) #######################
##############################################################################
modelo_ets_auto <- ets(train)
pred_ets <- forecast(modelo_ets_auto, h = length(test))
# Visualizacion comparacion ETS
autoplot(pred_ets) +
  autolayer(test, series = "Observado", color = "red") +
  ggtitle("Prediccion del HICP Italia (2011-2012) con ETS automatico") +
  ylab("HICP") +
  xlab("Ano") +
  guides(colour = guide_legend(title = "Serie"))
##############################################################################
####################### 6. MEDIDAS DE EVALUACION Y COMPARACION ##############
##############################################################################
# Matricas ARIMA
accuracy_arima <- accuracy(pred_arima, test)
print("Evaluacion modelo ARIMA:")
print(accuracy_arima)
# Metricas ETS
accuracy_ets <- accuracy(pred_ets, test)
print("Evaluacion modelo ETS:")
print(accuracy_ets)