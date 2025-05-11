#5. Bước 4: Áp dụng mô hình ML

# Tải các thư viện cần thiết
install.packages("randomForest")
library(tidyverse)
library(caret)
library(prophet)
library(cluster)
library(randomForest)
library(readr)
library(ggplot2)


print(file.exists("output/full_grouped_with_features.csv"))

getwd()
setwd("D:/Đại học/TL-HOCKI2.2/TL_LT_R_CPT_QT/DoAn_R/FinalDataR/COVID19_Analysis")
# Hàm huấn luyện và lưu các mô hình
train_models <- function() {
  # --- 1. Regression: Dự đoán số ca nhiễm mới (New cases) ---
  data_reg <- read_csv("output/full_grouped_with_features.csv")
  view(data_reg)
  
  # Chuẩn bị dữ liệu: loại bỏ NA và giá trị bất thường
  data_reg <- data_reg %>%
    filter(!is.na(`New cases`) & !is.na(Growth_Rate) & !is.na(Death_Rate) & !is.na(Recovery_Rate) & !is.na(Rolling_Mean)) %>%
    filter(is.finite(Growth_Rate) & is.finite(Death_Rate) & is.finite(Recovery_Rate) & is.finite(Rolling_Mean)) %>%
    select(`New cases`, Growth_Rate, Death_Rate, Recovery_Rate, Rolling_Mean)
  
  # Chia dữ liệu thành tập huấn luyện (80%) và kiểm tra (20%)
  set.seed(123)
  trainIndex_reg <- createDataPartition(data_reg$`New cases`, p = 0.8, list = FALSE)
  train_data_reg <- data_reg[trainIndex_reg, ]
  test_data_reg <- data_reg[-trainIndex_reg, ]
  
  # Huấn luyện mô hình hồi quy tuyến tính
  regression_model <- lm(`New cases` ~ Growth_Rate + Death_Rate + Recovery_Rate + Rolling_Mean, data = train_data_reg)
  
  # Dự đoán và đánh giá
  predictions_reg <- predict(regression_model, newdata = test_data_reg)
  rmse_reg <- sqrt(mean((test_data_reg$`New cases` - predictions_reg)^2))
  r2_reg <- cor(test_data_reg$`New cases`, predictions_reg)^2
  cat("Regression - RMSE:", rmse_reg, "\n")
  cat("Regression - R-squared:", r2_reg, "\n")
  
  # Lưu mô hình
  saveRDS(regression_model, "output/regression_model.rds")
  
  regression_model <- readRDS("output/regression_model.rds")
  
  # Lưu dự đoán
  test_data_reg <- test_data_reg %>%
    mutate(Predicted_New_cases = predictions_reg)
  write_csv(test_data_reg, "output/regression_predictions.csv")
  
  # --- 2. Time Series: Dự đoán xu hướng ca nhiễm mới ---
  data_ts <- read_csv("output/full_grouped_with_features.csv") %>%
    group_by(Date) %>%
    summarise(y = sum(`New cases`, na.rm = TRUE)) %>%
    rename(ds = Date)
  
  # Huấn luyện mô hình Prophet
  prophet_model <- prophet()
  prophet_model <- add_country_holidays(prophet_model, country_name = 'US')
  prophet_model <- fit.prophet(prophet_model, data_ts)
  
  # Dự đoán 30 ngày tới
  future <- make_future_dataframe(prophet_model, periods = 30)
  forecast <- predict(prophet_model, future)
  
  # Lưu mô hình
  saveRDS(prophet_model, "output/prophet_model.rds")
  write_csv(forecast, "output/prophet_forecast.csv")
  
  # --- 3. Clustering: Phân cụm quốc gia ---
  data_cluster <- read_csv("output/worldometer_with_features.csv") %>%
    filter(!is.na(Death_Rate) & !is.na(Test_Rate)) %>%
    select(Death_Rate, Test_Rate)
  
  # Chuẩn hóa dữ liệu
  data_cluster_scaled <- scale(data_cluster)
  
  # Huấn luyện mô hình K-Means (3 cụm)
  set.seed(123)
  kmeans_model <- kmeans(data_cluster_scaled, centers = 3, nstart = 25)
  
  # Thêm nhãn cụm vào dữ liệu gốc
  data_cluster <- read_csv("output/worldometer_with_features.csv") %>%
    mutate(Cluster = as.factor(kmeans_model$cluster))
  
  # Lưu mô hình và dữ liệu phân cụm
  saveRDS(kmeans_model, "output/kmeans_model.rds")
  write_csv(data_cluster, "output/clustered_data.csv")
  
  # --- 4. Classification: Phân loại quốc gia nguy cơ cao/thấp ---
  data_class <- read_csv("output/worldometer_with_features.csv") %>%
    filter(!is.na(Death_Rate) & !is.na(Test_Rate)) %>%
    mutate(Risk_Level = as.factor(ifelse(Death_Rate > 5, "High", "Low"))) %>%
    select(Risk_Level, TotalCases, TotalDeaths, TotalTests, Population, Death_Rate, Test_Rate)
  
  # Chia dữ liệu
  set.seed(123)
  trainIndex_class <- createDataPartition(data_class$Risk_Level, p = 0.8, list = FALSE)
  train_data_class <- data_class[trainIndex_class, ]
  test_data_class <- data_class[-trainIndex_class, ]
  
  # Huấn luyện mô hình Random Forest
  rf_model <- randomForest(Risk_Level ~ TotalCases + TotalDeaths + TotalTests + Population + Death_Rate + Test_Rate, 
                           data = train_data_class, ntree = 100)
  
  # Dự đoán và đánh giá
  predictions_class <- predict(rf_model, test_data_class)
  confusionMatrix(predictions_class, test_data_class$Risk_Level)
  
  # Lưu mô hình
  saveRDS(rf_model, "output/rf_model.rds")
  
  # Lưu dự đoán
  test_data_class <- test_data_class %>%
    mutate(Predicted_Risk_Level = predictions_class)
  write_csv(test_data_class, "output/classification_predictions.csv")
  
  # Trả về danh sách các mô hình
  return(list(
    regression_model = regression_model,
    prophet_model = prophet_model,
    kmeans_model = kmeans_model,
    rf_model = rf_model
  ))
}

# Thực thi hàm
models <- train_models()

# Kiểm tra kết quả
print("Các mô hình đã được huấn luyện và lưu!")
