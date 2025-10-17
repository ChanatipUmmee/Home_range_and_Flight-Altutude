# Himalayan Vulture Migration and Home Range Analysis

This repository contains data processing and analysis scripts for studying the **flight altitude** and **home range** of multiple birds using GPS tracking data.  

---

## 1. Flight Altitude Analysis

### Overview
We calculated flight altitude above ground (AGL) for three birds during migration using GPS data and a Digital Elevation Model (DEM). The analysis provides statistics and visualizations of flight behaviour over time.

### Birds Analyzed
- KU852
- DNP5
- KU1025

### Method
1. Load GPS tracking data (`*.csv`) and DEM (`SRTM_DEM.tif`).
2. Convert GPS coordinates to spatial objects.
3. Extract ground elevation from the DEM.
4. Calculate flight altitude above ground (AGL). Negative values are set to 0.
5. Compute summary statistics: mean, standard deviation, min, max, and number of points.
6. Generate time-series plots of flight altitude.

### Output
- CSV files for each bird with calculated flight altitude (`*_with_FlightAltitude.csv`)
- PNG plots of flight altitude over time (`*_FlightAltitude_plot.png`)
- Combined summary table: `Flight_Altitude_Summary_all.csv`

---

## 2. Home Range Analysis (Kernel Density Estimate, KDE)

### Overview
We estimated home ranges for four birds using Kernel Density Estimation (KDE) based on GPS locations. Home ranges were calculated for the 95%, 75%, and 50% levels.

### Birds Analyzed
- KU852
- KU903
- DNP5
- KU1025

### Method
1. Load GPS tracking data (`*.csv`).
2. Convert GPS coordinates to spatial objects and transform to UTM for accurate area calculations.
3. Compute KDE for each bird.
4. Generate home range polygons at 95%, 75%, and 50% levels.
5. Calculate area in square kilometers.
6. Save polygons as shapefiles for GIS visualization.

### Output
- Shapefiles for each bird at 95%, 75%, 50% levels (`*_KDE_95.shp`, `*_KDE_75.shp`, `*_KDE_50.shp`)
- Combined CSV of home range areas: `Home_range_all_results.csv`

---

## Setup

### Requirements
- R (≥ 4.0)
- R packages: `sf`, `sp`, `adehabitatHR`, `dplyr`, `terra`, `lubridate`, `ggplot2`

### Folder Structure
```
C:/Users/msi/Desktop/R2/        <- Home range files
C:/Users/msi/Desktop/R3/        <- Flight altitude files & DEM
```

### How to Run
1. Update `data_dir` in each script to point to your data folder.
2. Run `Flight_Altitude_analysis.R` for flight altitude.
3. Run `Home_Range_KDE_analysis.R` for home range estimation.
4. Check the output CSVs and PNG/shapefiles in the same folder.

---

## Notes
- Flight altitude is calculated relative to ground elevation (AGL). Any negative values are set to zero.
- KDE areas are in square kilometers and represent the probability-based home range of each individual.
- All scripts are designed to handle multiple birds automatically.

---

## Author
**Chanatip Ummee**  
Faculty of Veterinary Medicine, Kasetsart University  
Bangkok, Thailand  
[chanatip.umm@ku.th]

