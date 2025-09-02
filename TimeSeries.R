
rm(list=ls())
#install.packages("readxl")
library(readxl)

datos <- read_excel("data.xls")

head(datos)

##############################################################################
########################## 1. REPRESENTAR LA SERIE ########################## 
##############################################################################

library(ggplot2)

# Evolución del HICP - Italia
ggplot(datos, aes(x = ...1, y = IT)) +
  geom_line() +
  labs(title = "Evolución del HICP - Italia",
       x = "Fecha", y = "HICP") +
  theme_minimal()



##############################################################################
#################### 2. SERIE AJUSTADA DE ESTACIONALIDAD #####################
##############################################################################

hicp_italia <- ts(datos$IT, start = c(1996, 1), frequency = 12)

descomposicion <- decompose(hicp_italia)

plot(descomposicion)

# La parte estacional está en descomposicion$seasonal.
hicp_ajustada <- hicp_italia - descomposicion$seasonal
plot(hicp_ajustada,
     main = "Serie ajustada de estacionalidad de HICP Italia",
     ylab = "HICP ajustado",
     xlab = "Año")



##############################################################################
#################### 3. MODELO DE SUAVIZADO EXPONENCIAL #####################
##############################################################################

library(fpp2) 
library(forecast)

hicp_train <- window(hicp_italia, end = c(2010, 12))
hicp_test  <- window(hicp_italia, start = c(2011, 1), end = c(2012, 5))

# Ajustar modelo de suavizado exponencial 
modelo_ets_adi <- ets(hicp_train, model='AAA')
pred_adi = forecast(modelo_ets_adi, h = length(hicp_test))

modelo_ets_mul <- ets(hicp_train, model='MAM')
pred_mul = forecast(modelo_ets_mul, h = length(hicp_test))

modelo_ets_auto = ets(hicp_train)
pred_auto = forecast(modelo_ets_auto, h = length(hicp_test))

# Visualizar predicción vs datos reales
#Modelo aditivo
autoplot(pred_adi) +
  autolayer(hicp_test, series = "Observado", color = "red") +
  ggtitle("Predicción del HICP Italia (2011-2012) con ETS aditivo") +
  ylab("HICP") +
  xlab("Año") +
  guides(colour = guide_legend(title = "Serie"))

#Modelo multiplicativo
autoplot(pred_mul) +
  autolayer(hicp_test, series = "Observado", color = "red") +
  ggtitle("Predicción del HICP Italia (2011-2012) con ETS multiplicativo") +
  ylab("HICP") +
  xlab("Año") +
  guides(colour = guide_legend(title = "Serie"))

#Modelo automatico
autoplot(pred_auto) +
  autolayer(hicp_test, series = "Observado", color = "red") +
  ggtitle("Predicción del HICP Italia (2011-2012) con ETS automatico") +
  ylab("HICP") +
  xlab("Año") +
  guides(colour = guide_legend(title = "Serie"))

##############################################################################
################### 4. MEDIDAS DE EVALUACIÓN PREDICCIONES ####################
##############################################################################
accuracy(pred_adi, hicp_test)
accuracy(pred_mul, hicp_test)
accuracy(pred_auto, hicp_test)
