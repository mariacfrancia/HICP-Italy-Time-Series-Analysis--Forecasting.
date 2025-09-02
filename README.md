# HICP Italy Time Series Analysis and Forecasting

# Overview

This project analyzes and forecasts the **Harmonized Index of Consumer Prices (HICP)** for Italy using **R** and **time series models**.  

It consists of **two parts**:

1. **ETS and seasonal adjustment (Part 1)**
2. **ARIMA/SARIMA modeling and comparison with ETS (Part 2)**

**Skills & Keywords:** Time Series Analysis, Forecasting, ETS Models, ARIMA/SARIMA, Seasonality Adjustment, R Programming, Data Visualization, HICP, Italy.

The project was carried out by a **group of 3 students**.

---

# Files

- **data.xls**: Excel file containing HICP data for multiple Eurozone countries.  
- **TimeSeries.R**: Implements Part 1: visualization, seasonal adjustment, ETS modeling, predictions, and forecast evaluation.  
- **ARIMA_HICP.R**: Implements Part 2: ARIMA/SARIMA modeling, Box-Cox transformation, differencing, predictions, comparison with ETS, and accuracy evaluation.  

---

# Problem Description

The project focuses on the monthly evolution of HICP in Italy, from 1996 onwards.  

## Part 1 - ETS & Seasonal Adjustment (`TimeSeries.R`)

1. Visualize the HICP series and describe trends.  
2. Seasonally adjust the series to remove monthly effects.  
3. Build **Exponential Smoothing (ETS) models** to predict HICP from Jan 2011 to May 2012. Compare additive, multiplicative, and automatic models.  
4. Evaluate forecast accuracy using standard metrics (MAE, RMSE, etc.).

## Part 2 - ARIMA/SARIMA Modeling (`ARIMA_HICP.R`)

1. Apply **Box-Cox transformation** and differencing to stabilize variance and remove trend/seasonality.  
2. Fit **ARIMA/SARIMA models**, justifying each modeling step.  
3. Predict HICP from Jan 2011 to May 2012 and compare predictions with observed values.  
4. Compare ARIMA/SARIMA forecasts with ETS forecasts from Part 1.  
5. Evaluate prediction accuracy using standard metrics.

---

# Implementation

- **Data:** `data.xls`  
- **Tools:** R, `ggplot2`, `forecast`, `fpp2`, `tseries`, `lmtest`, `nortest`, `readxl`  

## Part 1 Highlights

- Decompose series into **trend, seasonality, and residuals**.  
- Apply **ETS models** (Additive, Multiplicative, Automatic) for forecasting.  
- Evaluate predictions using accuracy measures.

## Part 2 Highlights

- Stabilize variance using **Box-Cox transformation**.  
- Remove trend and seasonality using **differencing**.  
- Fit **ARIMA/SARIMA models** considering autoregressive, moving average, and seasonal components.  
- Predict future values and compare with ETS forecasts.  
- Evaluate model performance with standard metrics.

---

# Summary

This repository demonstrates a complete workflow for **HICP forecasting in Italy**, including:

- Data visualization  
- Seasonal adjustment  
- Exponential smoothing (ETS)  
- ARIMA/SARIMA modeling  
- Prediction and evaluation  
- Model comparison  

It provides practical **time series forecasting techniques** used in economics and finance.
