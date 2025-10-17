# Home Range Analysis for Four Birds (Kernel Density Estimate)

# Load required packages
library(sf)
library(sp)
library(adehabitatHR)
library(dplyr)

# Set the folder where your data is stored 
data_dir <- "C:/Users/msi/Desktop/R2"

# GPS data files for each bird 
birds <- list(
  KU852  = "Home_range_KU852.csv",
  KU903  = "Home_range_KU903.csv",
  DNP5   = "Home_range_DNP5.csv",
  KU1025 = "Home_range_KU1025.csv"
)

# Prepare an empty data frame to store results 
results <- data.frame(
  ID = character(),
  Level = character(),
  Area_km2 = numeric(),
  stringsAsFactors = FALSE
)

# Loop through each bird to calculate KDE and home range areas

for (id in names(birds)) {
  
  cat("===========================================\n")
  cat("Processing:", id, "\n")
  cat("===========================================\n")
  
  # Load the GPS data 
  file_path <- file.path(data_dir, birds[[id]])
  df <- read.csv(file_path, stringsAsFactors = FALSE)
  
  # Add ID column if missing 
  df$ID <- id
  
  # Convert to sf object and transform to UTM 
  sf_data <- st_as_sf(df, coords = c("Longitude", "Latitude"), crs = 4326)
  sf_data_utm <- st_transform(sf_data, crs = 32647)
  sp_data_utm <- as(sf_data_utm, "Spatial")
  sp_data_utm$id <- df$ID
  
  # Check how many GPS points are available 
  cat("Number of GPS points used:", nrow(df), "\n")
  
  # Calculate Kernel Density Estimate (KDE) 
  kde <- kernelUD(sp_data_utm["id"], h = "href", extent = 3)
  
  # Generate home range polygons for 95%, 75%, 50% levels 
  ver95 <- getverticeshr(kde, 95)
  ver75 <- getverticeshr(kde, 75)
  ver50 <- getverticeshr(kde, 50)
  
  # Save polygons as shapefiles 
  st_write(st_as_sf(ver95), file.path(data_dir, paste0(id, "_KDE_95.shp")), delete_layer = TRUE)
  st_write(st_as_sf(ver75), file.path(data_dir, paste0(id, "_KDE_75.shp")), delete_layer = TRUE)
  st_write(st_as_sf(ver50), file.path(data_dir, paste0(id, "_KDE_50.shp")), delete_layer = TRUE)
  
  # Calculate areas in square kilometers 
  ver95_sf <- st_as_sf(ver95)
  ver75_sf <- st_as_sf(ver75)
  ver50_sf <- st_as_sf(ver50)
  
  area_95 <- as.numeric(st_area(ver95_sf)) / 1e6
  area_75 <- as.numeric(st_area(ver75_sf)) / 1e6
  area_50 <- as.numeric(st_area(ver50_sf)) / 1e6
  
  # Create a summary table for this bird 
  area_table <- data.frame(
    ID = id,
    Level = c("95%", "75%", "50%"),
    Area_km2 = c(area_95, area_75, area_50)
  )
  
  print(area_table)
  
  # Append to the master results table 
  results <- rbind(results, area_table)
}

# Save all results as a CSV file

output_path <- file.path(data_dir, "Home_range_all_results.csv")
write.csv(results, output_path, row.names = FALSE)

cat("\n✅ Finished processing all birds!\n")
cat("Results saved to:", output_path, "\n")