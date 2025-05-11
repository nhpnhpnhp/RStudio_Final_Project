#3. Bước 2: Tiền xử lý & EDA - Phần tiền xử lý dữ liệu

# Tải các thư viện cần thiết
library(readr)
library(tidyverse)
library(lubridate)
library(zoo)

getwd()
setwd("D:/Đại học/TL-HOCKI2.2/TL_LT_R_CPT_QT/DoAn_R/FinalDataR/COVID19_Analysis")

# Hàm tiền xử lý và tạo đặc trưng
preprocess_data <- function() {
  # Đọc tất cả file CSV từ thư mục Data
  day_wise <- read_csv("Data/day_wise.csv")
  worldometer <- read_csv("Data/worldometer_data.csv")
  full_grouped <- read_csv("Data/full_grouped.csv")
  covid_complete <- read_csv("Data/covid_19_clean_complete.csv")
  usa_county_wise <- read_csv("Data/usa_county_wise.csv")
  
  # Tiền xử lý cơ bản
  # 1. Xử lý NA (thay NA bằng 0)
  day_wise <- day_wise %>% mutate(across(everything(), ~replace(., is.na(.), 0)))
  worldometer <- worldometer %>% mutate(across(everything(), ~replace(., is.na(.), 0)))
  full_grouped <- full_grouped %>% mutate(across(everything(), ~replace(., is.na(.), 0)))
  
  # 2. Đổi kiểu Date (sửa định dạng và tên cột nếu cần)
  # Kiểm tra và điều chỉnh tên cột Date
  if ("Date" %in% colnames(day_wise)) {
    day_wise <- day_wise %>% filter(!is.na(Date) & !grepl("[^0-9/-]", Date)) %>% mutate(Date = as.Date(Date, format = "%m/%d/%Y"))
  } else if ("date" %in% colnames(day_wise)) {
    day_wise <- day_wise %>% filter(!is.na(date) & !grepl("[^0-9/-]", date)) %>% mutate(Date = as.Date(date, format = "%m/%d/%Y"))
  }
  
  if ("Date" %in% colnames(worldometer)) {
    worldometer <- worldometer %>% filter(!is.na(Date) & !grepl("[^0-9/-]", Date)) %>% mutate(Date = as.Date(Date, format = "%m/%d/%Y"))
  } else if ("date" %in% colnames(worldometer)) {
    worldometer <- worldometer %>% filter(!is.na(date) & !grepl("[^0-9/-]", date)) %>% mutate(Date = as.Date(date, format = "%m/%d/%Y"))
  }
  
  full_grouped <- full_grouped %>% filter(!is.na(Date) & !grepl("[^0-9/-]", Date)) %>% mutate(Date = as.Date(Date, format = "%m/%d/%Y"))
  covid_complete <- covid_complete %>% filter(!is.na(Date) & !grepl("[^0-9/-]", Date)) %>% mutate(Date = as.Date(Date, format = "%m/%d/%Y"))
  usa_county_wise <- usa_county_wise %>% filter(!is.na(Date) & !grepl("[^0-9/-]", Date)) %>% mutate(Date = as.Date(Date, format = "%m/%d/%Y"))
  
  # 3. Chuẩn hóa dữ liệu
  day_wise <- day_wise %>% mutate(across(c(Confirmed, Deaths, Recovered), as.numeric))
  worldometer <- worldometer %>% mutate(across(c(TotalCases, TotalDeaths, TotalTests), as.numeric))
  full_grouped <- full_grouped %>% mutate(across(c(Confirmed, Deaths, Recovered, New_cases), as.numeric))
# ------------------------------------------------------------------------------------------------------------------------------------------------
#4. Bước 3: Feature Engineering
  # Feature Engineering
  # a. worldometer với các đặc trưng
  worldometer_with_features <- worldometer %>%
    mutate(
      Death_Rate = ifelse(TotalCases > 0, TotalDeaths / TotalCases * 100, 0),
      Test_Rate = ifelse(Population > 0, TotalTests / Population * 100, 0)
    )
  
  # b. full_grouped với các đặc trưng
  full_grouped_with_features <- full_grouped %>%
    group_by(`Country/Region`) %>%
    arrange(Date) %>%
    mutate(
      Growth_Rate = (New_cases / lag(Confirmed, default = first(Confirmed))) * 100,
      Death_Rate = ifelse(Confirmed > 0, Deaths / Confirmed * 100, 0),
      Recovery_Rate = ifelse(Confirmed > 0, Recovered / Confirmed * 100, 0),
      Rolling_Mean = rollmean(New_cases, k = 7, fill = NA, align = "right")
    ) %>%
    ungroup()
  
  # Lưu file đã làm sạch và với đặc trưng
  write_csv(day_wise, "output/cleaned_day_wise.csv")
  write_csv(worldometer, "output/cleaned_worldometer.csv")
  write_csv(worldometer_with_features, "output/worldometer_with_features.csv")
  write_csv(full_grouped_with_features, "output/full_grouped_with_features.csv")
  
  # Trả về dữ liệu để kiểm tra
  return(list(
    day_wise = day_wise,
    worldometer = worldometer,
    worldometer_with_features = worldometer_with_features,
    full_grouped_with_features = full_grouped_with_features
  ))
}

# Thực thi hàm
processed_data <- preprocess_data()

# Kiểm tra kết quả
print("Xử lý và tạo đặc trưng thành công!")
head(processed_data$day_wise)
head(processed_data$worldometer_with_features)
head(processed_data$full_grouped_with_features)