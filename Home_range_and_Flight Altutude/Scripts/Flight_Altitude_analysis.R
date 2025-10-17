# Flight Altitude Analysis for Three Birds
# Automatically downloads DEM (SRTM) from online sources
# Processes GPS data for: KU852, DNP5, KU1025

# Load required packages 
library(terra)
library(sf)
library(dplyr)
library(lubridate)
library(ggplot2)
library(elevatr)   

# Set data directory 
data_dir <- "C:/Users/msi/Desktop/R3"

# List of GPS files for each bird 
birds <- list(
  KU852  = "KU852_Migration_all.csv",
  DNP5   = "DNP5_Migration_all.csv",
  KU1025 = "KU1025_Migration_all.csv"
)

# Prepare a data frame to store combined results 
summary_all <- data.frame(
  ID = character(),
  mean_flight_altitude = numeric(),
  sd_flight_altitude = numeric(),
  min_flight_altitude = numeric(),
  max_flight_altitude = numeric(),
  N = numeric(),
  stringsAsFactors = FALSE
)

# Loop through each bird to calculate flight altitude (AGL)

for (id in names(birds)) {
  
  cat("===========================================\n")
  cat("Processing:", id, "\n")
  cat("===========================================\n")
  
  # Load GPS data 
  gps_file <- file.path(data_dir, birds[[id]])
  gps_data <- read.csv(gps_file, stringsAsFactors = FALSE)
  
  # Simplify column names 
  names(gps_data) <- gsub("\\.+", "_", names(gps_data))
  
  # Convert to sf object 
  gps_sf <- st_as_sf(gps_data, coords = c("Longitude", "Latitude"), crs = 4326)
  
  # Download SRTM DEM automatically based on extent of points 
  cat("Downloading SRTM DEM for", id, "...\n")
  dem <- get_elev_raster(gps_sf, z = 10, clip = "locations")  # z=10 gives ~90m resolution
  
  # Extract ground elevation 
  elev_values <- terra::extract(rast(dem), vect(gps_sf))
  gps_elev <- cbind(gps_data, Ground_elev_m = elev_values[, 2])
  
  # Compute altitude above ground (AGL) 
  gps_elev <- gps_elev %>%
    mutate(
      Flight_altitude_AGL_m = Altitude_Ellipsoid_ - Ground_elev_m,
      Flight_altitude_AGL_m = ifelse(Flight_altitude_AGL_m < 0, 0, Flight_altitude_AGL_m)
    )
  
  # Convert time column if available 
  if ("Collecting_time" %in% names(gps_elev)) {
    gps_elev$Collecting_time <- ymd_hms(gps_elev$Collecting_time, tz = "Asia/Bangkok")
  }
  
  # Calculate summary statistics 
  summary_stats <- gps_elev %>%
    summarise(
      mean_flight_altitude = mean(Flight_altitude_AGL_m, na.rm = TRUE),
      sd_flight_altitude   = sd(Flight_altitude_AGL_m, na.rm = TRUE),
      min_flight_altitude  = min(Flight_altitude_AGL_m, na.rm = TRUE),
      max_flight_altitude  = max(Flight_altitude_AGL_m, na.rm = TRUE),
      N = sum(!is.na(Flight_altitude_AGL_m))
    ) %>%
    mutate(ID = id)
  
  print(summary_stats)
  
  # Combine into overall results 
  summary_all <- rbind(summary_all, summary_stats)
  
  # Save processed CSV 
  out_csv <- file.path(data_dir, paste0(id, "_with_FlightAltitude.csv"))
  write.csv(gps_elev, out_csv, row.names = FALSE)
  
  # Create and save plot 
  if ("Collecting_time" %in% names(gps_elev)) {
    plot <- ggplot(gps_elev, aes(x = Collecting_time, y = Flight_altitude_AGL_m)) +
      geom_line(color = "blue") +
      labs(
        title = paste("Flight Altitude During Migration (", id, ")", sep = ""),
        x = "Time",
        y = "Flight Altitude (m above ground)"
      ) +
      theme_minimal()
    
    ggsave(
      filename = file.path(data_dir, paste0(id, "_FlightAltitude_plot.png")),
      plot = plot,
      width = 8,
      height = 4
    )
  }
}

# Save combined summary 
output_summary <- file.path(data_dir, "Flight_Altitude_Summary_all.csv")
write.csv(summary_all, output_summary, row.names = FALSE)

cat("\n✅ Finished processing all birds!\n")
cat("Summary table saved to:", output_summary, "\n")