# RStudio_Final_Project

country_wise_latest (Số liệu thế giới theo từng quốc gia mỗi tuần) : ##Bỏ file này
	+ Country/Region: Quốc gia
	+ Confirmed: Tổng số ca bệnh tính đến tuần này
	+ Deaths: Tổng số ca tử vong tính đến tuần này
	+ Recovered: Tổng số ca đã khỏi bệnh tính đến tuần này
	+ Active: Tổng số ca đang điều trị tính đến tuần này
	+ New cases: Số ca bệnh mới của tuần này
	+ New.deaths: Số ca tử vong tuần này
	+ New.recovered: Số ca hồi phục tuần này;
	+ Deaths / 100 Cases : Tỉ lệ tử vong trên 100 người = 100*Deaths/Confirmed;
	+ Confirmed last week : Tổng số ca bệnh tính đến tuần trước
	+ 1 week change: = Confirmed - Confirmed last week
	+ 1 week % increase : Phần trăm gia tăng số ca nhiễm trong tuần này so với tổng số ca nhiễm của tuần trước = 100* 1 week change / Confirmed last week
	+ WHO Region : Khu vực của WHO gồm (6): Eastern Mediterranean; Europe; Africa; Americas; Western Pacific; South-East Asia 
covid_19_clean_complete (Số liệu thế giơi theo từng quốc gia mỗi ngày):
	+ Province/State: Tỉnh/ Bang của quốc gia (Không chi tiết toàn bộ)
	+ Country/Region: Quốc gia
	+ Lat: Vĩ độ
	+ Long : Kinh độ
	+ Date: Ngày dạng : YYYY-MM-DD (Từ 2020-01-22 đến 2020-07-27)
	+ Confirmed : Tổng ca ghi nhận
	+ Deaths: Tổng ca tử vong
	+ Recovered: Tổng ca hồi phục
	+ Active : Tổng ca đang điều trị
	+ WHO Region : Khu vực của WHO gồm (6): Eastern Mediterranean; Europe; Africa; Americas; Western Pacific; South-East Asia
day_wise (Toàn thế giới từng ngày):
	+ Date: Ngày dạng : YYYY-MM-DD (Từ 2020-01-22 đến 2020-07-27)
	+ Confirmed : Tổng ca ghi nhận
	+ Deaths: Tổng ca tử vong
	+ Recovered: Tổng ca hồi phục
	+ Active : Tổng ca đang điều trị
	+ New cases: Số ca bệnh mới trong ngày
	+ New.deaths: Số ca tử vong trong ngày
	+ New.recovered: Số ca hồi phục trong ngày;
	+ Deaths / 100 Cases : Tỉ lệ tử vong trên 100 người = 100*Deaths/Confirmed;
	+ Recovered / 100 Cases : Tỉ lệ hồi phục trên 100 người = 100*Recovered/Confirmed;
	+ Deaths / 100 Recovered : Tỉ lệ tử vong trên 100 người hồi phục = 100*Deaths/Recovered;
	+ No. of countries: Số quốc gia đã bị nhiễm
full_grouped (Dữ liệu theo từng ngày của từng quốc gia) :
	+ Date: Ngày dạng : YYYY-MM-DD (Từ 2020-01-22 đến 2020-07-27)
	+ Country/Region: Quốc gia
	+ Confirmed : Tổng ca ghi nhận
	+ Deaths: Tổng ca tử vong
	+ Recovered: Tổng ca hồi phục
	+ Active : Tổng ca đang điều trị
	+ New cases: Số ca bệnh mới trong ngày
	+ New.deaths: Số ca tử vong trong ngày
	+ New.recovered: Số ca hồi phục trong ngày;
	+ WHO Region : Khu vực của WHO gồm (6): Eastern Mediterranean; Europe; Africa; Americas; Western Pacific; South-East Asia
worldometer_data :
	+ Country/Region: Quốc gia
	+ Continent: Lục địa gồm (6): "North America"; "South America"; "Asia"; "Europe"; "Africa"; "Australia/Oceania"
	+ Population: Tổng dân số
	+ TotalCases: Tổng số ca nhiễm
	+ NewCases: Ca nhiễm mới
	+ TotalDeaths: Tổng số ca tử vong
	+ ActiveCases: Tổng số ca đang điều trị
	+ "Serious,Critical" : Tình trạng NGUY HIỂM/TÍCH CỰC
	+ Tot Cases/1M pop : Tổng ca nhiễm trên 1 triệu dân ( đã được làm tròn ) = 1.000.000*TotalCases/Population
	+ Deaths/1M pop : Số ca tử vong trên 1 triệu dân ( đã được làm tròn ) = 1.000.000*TotalDeaths/Population
	+ TotalTests : Tổng số người đã thực hiện test Covid19
	+ Tests/1M pop : số người đã thực hiện test Covid19 trên 1 triệu dân ( đã được làm tròn ) = 1.000.000*TotalTests/Population
	+ WHO Region : Khu vực của WHO gồm (6): Eastern Mediterranean; Europe; Africa; Americas; Western Pacific; South-East Asia
