# Data Directory

## Topics Covered

All datasets used across the 12 phases, converted from SAS .sas7bdat format to CSV for universal R compatibility. Raw source files (TXT and XLS) are in data/raw/.

## Files

| File | Description |
|------|-------------|
| `*.csv` | 25 analysis datasets |
| `raw/RAWDATA.TXT` | Raw delimited text file |
| `raw/RAWDAT1.xls` | Raw Excel source file |

## Datasets Used

All 25 CSV datasets

## Key R Syntax

```r
# Standard data load pattern used throughout this project
DATA_PATH <- "./data"
library(readr)
df <- read_csv(file.path(DATA_PATH, "filename.csv"))
```
