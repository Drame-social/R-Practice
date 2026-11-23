# Phase 02 — Data Import & Creation

## Topics Covered

Importing CSV files with read_csv(), an Excel file with read_excel(), and a space-delimited text file with no header row; creating a small dataset in code; stacking datasets with bind_rows() and flagging their source. The Excel example reads the converted workbook, raw/RAWDAT1.xlsx.

## Files

| File | Description |
|------|-------------|
| `02_data_import_and_creation.R` | Import, create, and stack datasets |

## Datasets Used

phase1.csv, phase2.csv, cohort1516.csv, cohort1617.csv, raw/RAWDAT1.xlsx, raw/RAWDATA.TXT

Derived files are written to `./outputs/`.

## Key R Syntax

```r
rawdata_txt <- read_table("./data/raw/RAWDATA.TXT",
                          col_names = c("studyid", "caco", "age", "exposure"))

cohort_combined <- bind_rows(cohort1516, cohort1617)
phases <- bind_rows(`1` = phase1, `2` = phase2, .id = "phase")
```
