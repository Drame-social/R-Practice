# Phase 02 — Data Import & Creation

## Topics Covered

Importing CSV files with read_csv(), reading Excel files with read_excel(), reading delimited text files, stacking datasets with bind_rows(), and merging with left_join() / inner_join().

## Files

| File | Description |
|------|-------------|
| `02_data_import_and_creation.R` | Import, merge, and stack datasets |

## Datasets Used

phase1.csv, phase2.csv, cohort1516.csv, cohort1617.csv, labs.csv, RAWDAT1.xls, RAWDATA.TXT

## Key R Syntax

```r
library(readr); library(dplyr)

# Import CSV
df <- read_csv("./data/phase1.csv")

# Stack datasets
combined <- bind_rows(cohort1516, cohort1617)

# Left join
merged <- left_join(demo, clin, by = "studyid")
```
