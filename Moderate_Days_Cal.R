# Load necessary libraries
library(gridExtra)
library(grid)
library(dplyr)
library(zoo)
library(aqsr)
library(ggplot2)
library(lubridate)
library(scales)
library(tidyr)

# Create the user
myuser <- create_user(email = "api_user_name", key = "api_user_key")

# Define the start and end years
start_year <- 2023
end_year <- 2023

# Create an empty list to store the data for each year
data_list <- list()

# Loop through the years
for (year in start_year:end_year) {
  # Define the start and end dates for the current year
  bdate <- paste0(year, "0101")
  edate <- paste0(year, "1231")
  
  # Fetch the data for the current year
  PM25_Daily24HR_Trends <- aqs_dailyData(aqs_user = myuser,
                                         endpoint = "byState",
                                         state = "28",
                                         bdate = bdate,
                                         edate = edate,
                                         param = "88101")
  
  # Store the data for the current year in the list
  data_list[[as.character(year)]] <- PM25_Daily24HR_Trends
}

# Combine the data for all years into a single data frame
combined_data <- bind_rows(data_list)

# Filter and select the desired columns
filtered_data <- combined_data %>%
  filter(pollutant_standard == "PM25 Annual 2012") %>%
  select(state_code, county_code, site_number, latitude, longitude, sample_duration,
         date_local, arithmetic_mean, local_site_name, county, city)

# Filter and select the desired columns
filtered_data <- combined_data %>%
  filter(pollutant_standard == "PM25 Annual 2012" &
           method %in% c("Teledyne T640 at 5.0 LPM - Broadband spectroscopy", 
                         "Teledyne T640X at 16.67 LPM - Broadband spectroscopy")) %>%
  select(state_code, county_code, site_number, latitude, longitude, sample_duration,
         date_local, arithmetic_mean, local_site_name, county, city)

colnames(filtered_data)[which(names(filtered_data) == "arithmetic_mean")] <- "pm25"
colnames(filtered_data)[which(names(filtered_data) == "date_local")] <- "date"

# Save the filtered data to a CSV file
write.csv(filtered_data, file = "filtered_data.csv", row.names = FALSE)


filtered_data$date = as.Date(filtered_data$date)

# Get unique site names
site_names <- unique(filtered_data$local_site_name)

# Initialize a data frame to store results
results <- data.frame()

# Loop over each site name
for (site in site_names) {
  # Filter data for current site
  site_data <- filtered_data %>% 
    filter(local_site_name == site)
  
  # Count moderate days based on old AQI scale (12.1 to 35.4)
  AQI_Scale_12.1_Moderate <- site_data %>% 
    filter(pm25 >= 12.1 & pm25 <= 35.4) %>% 
    nrow()
  
  # Count moderate days based on updated AQI scale (9.1 to 35.4)
  AQI_Scale_9.1_Moderate <- site_data %>% 
    filter(pm25 >= 9.1 & pm25 <= 35.4) %>% 
    nrow()
  
  # Calculate Additional_Moderate_Days
  Additional_Moderate_Days <- AQI_Scale_9.1_Moderate - AQI_Scale_12.1_Moderate
  
  # Add results to data frame
  results <- rbind(results, data.frame(site_name = site, AQI_Scale_12.1_Moderate = AQI_Scale_12.1_Moderate, AQI_Scale_9.1_Moderate = AQI_Scale_9.1_Moderate, Additional_Moderate_Days = Additional_Moderate_Days))
}

# Print results
print(results)

# Reshape data for plotting
results_long <- gather(results, key = "AQI_Scale", value = "Moderate_Days", AQI_Scale_12.1_Moderate, AQI_Scale_9.1_Moderate)

# Create a grouped bar plot
p <- ggplot(results_long, aes(x = site_name, y = Moderate_Days, fill = AQI_Scale)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Site Name", y = "Number of Moderate Days", title = "Comparison of Moderate Days under Old and New AQI Scales")

# Create a tableGrob
t <- tableGrob(results, theme = ttheme_default(base_size = 12))

# Add the table to the plot
grid.arrange(p, t, ncol = 2)
