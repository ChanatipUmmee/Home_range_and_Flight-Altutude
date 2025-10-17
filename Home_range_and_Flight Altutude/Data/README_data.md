# Data description

This folder contains the datasets used in the analyses of movement, home range, and flight altitude of three tagged individuals of the Himalayan Vulture (*Gyps himalayensis*).  
All data were collected using GPS transmitters deployed in northern Thailand under research permission granted by the Department of National Parks, Wildlife and Plant Conservation.

Sensitive information such as exact nest or roost locations has been retained privately for species protection.  
The files provided here include the full coordinate data required to reproduce the analyses, but they should not be redistributed without prior consent from the corresponding author.

---

## Data files

### 1. `KU852_Migration_all.csv`
GPS tracking data for individual **KU852**, covering the migration and home range period during 2021.  
Contains timestamped geographic coordinates, altitude (ellipsoid and corrected), and speed.

### 2. `DNP5_Migration_all.csv`
GPS data for individual **DNP5**, recorded during the 2025 migration and post-migration home range period.  
Used in both the *flight altitude* and *home range* analyses.

### 3. `KU1025_Migration_all.csv`
Tracking dataset for individual **KU1025** from 2025, including migration and stopover phases.  
Used to compare altitude and migration behaviour with DNP5.


## Home range data

### 4. `Home_range_KU852.csv`
Filtered dataset containing representative daily locations of KU852, used for Kernel Density Estimation (KDE) analysis of home range size.


### 5. `Home_range_KU903.csv`
Filtered dataset containing representative daily locations of KU903, used for Kernel Density Estimation (KDE) analysis of home range size.

### 6. `Home_range_DNP5.csv`
Daily position data of DNP5 during the breeding/home range period (May–July 2025).  
Used to estimate 95%, 75%, and 50% utilisation distributions.

### 7. `Home_range_KU1025.csv`
Subset of KU1025 tracking data used for KDE-based home range estimation after the completion of migration.


## Notes on data structure

Each CSV file includes the following core columns:

| Column name | Description |
|--------------|-------------|
| `Longitude` | Longitude in decimal degrees (WGS84) |
| `Latitude` | Latitude in decimal degrees (WGS84) |
| `Collecting_time` | Timestamp of GPS fix (local time, Asia/Bangkok) |
| `Altitude_Ellipsoid_` | Altitude from GPS ellipsoid model (metres) |
| `Altitude` | Ground-corrected altitude derived from DEM (metres) |
| `Speed` | Instantaneous ground speed (m/s), where available |

---

## Data use policy

The datasets in this repository are shared for scientific transparency and reproducibility.  
Please do not publish or redistribute the coordinate data without written permission from the authors.  
If you wish to use these data for further ecological or conservation work, please contact:

**Chanatip Ummee**  
Faculty of Veterinary Medicine, Kasetsart University  
Bangkok, Thailand  
[chanatip.umm@ku.th]
---

*Last updated: October 2025*
