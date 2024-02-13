This R code fetches PM2.5 pollution data from the EPA's Air Quality System (AQS) for a specific state and year range. It then filters and selects relevant columns, computes the number of moderate pollution days based on both old and updated AQI scales, and compares the results. Finally, it visualizes the comparison using a grouped bar plot and presents the data in a table format.

In the code. Just change 

`start_year <- 2023`  
`end_year <- 2023`


and your state code

state = "28"

To get years and appropriate state that you want.

2023 Comparison of PM25 AQI Moderate Days with both 12ug and 9ug
![image](https://github.com/Cuevman81/PM25_AQI_12ug_9ug_Comparison/assets/80535587/5b782e82-7b92-486f-8e8f-b2398c8c123c)
