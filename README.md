This R code fetches PM2.5 pollution data from the EPA's Air Quality System (AQS) for a specific state and year range. It then filters and selects relevant columns, computes the number of moderate pollution days based on both old and updated AQI scales, and compares the results. Finally, it visualizes the comparison using a grouped bar plot and presents the data in a table format.

In the code. Just change 

`start_year <- 2023`  
`end_year <- 2023`


and your state code

state = "28"

To get years and appropriate state that you want.

Note, in this code example, the data being pulled is from the T640(x) and T640(s) with parameter code 88101 which is NAAQS designation.  If running T640's for AQI purposes only, parameter code 88502 or something different, just change in R code.

The script counts only the corrected T640 series: AQS method codes 736/738 through 2023, and 636/638 ("Network Data Alignment enabled") from 2024. The raw 236/238 series reads high, so it is skipped. If you switch to another parameter code, check its method codes first. The chart below was made on 13 Feb 2024 from the raw series, so its counts run high. For Hernando in 2023, the script now gives 101 Moderate days on the old scale and 176 on the new one (+75).

2023 Comparison of PM25 AQI Moderate Days with both 12ug and 9ug
![image](https://github.com/Cuevman81/PM25_AQI_12ug_9ug_Comparison/assets/80535587/5b782e82-7b92-486f-8e8f-b2398c8c123c)
