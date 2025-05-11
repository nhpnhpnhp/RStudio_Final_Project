##Tải các thư viện cần thiết cho toàn bộ dự án

# Phần 1: Chuẩn bị môi trường

# Cài đặt các thư viện cần thiết cho phân tích.
install.packages("tidyverse")
install.packages("lubridate")
install.packages("prophet")
install.packages("caret")
install.packages("cluster")
install.packages("zoo")
install.packages("reshape2")
install.packages("randomForest")
install.packages("shiny")

# Tải các thư viện cần thiết
library(tidyverse)
library(lubridate)    
library(prophet)     
library(caret)        
library(cluster)      

# Các thư viện bổ sung (sẽ dùng ở các bước sau)
library(zoo)          
library(reshape2)     
library(randomForest) 
library(shiny)

# Thiết lập tùy chọn cơ bản
options(scipen = 999)