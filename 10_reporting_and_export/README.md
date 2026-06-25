# Phase 10 — Reporting & Export

## Topics Covered

Generating descriptive summary tables, exporting multi-sheet Excel workbooks with openxlsx, exporting CSVs with write_csv, and styling Excel output with createStyle.

## Files

| File | Description |
|------|-------------|
| `10_reporting_and_export.R` | Reporting and file export |

## Datasets Used

final_demo.csv, final_clin.csv

## Key R Syntax

```r
library(openxlsx)

wb <- createWorkbook()
addWorksheet(wb, "Demographics")
writeData(wb, "Demographics", final_demo)

# Bold header row
addStyle(wb, "Demographics",
  createStyle(textDecoration = "bold"),
  rows = 1, cols = 1:ncol(final_demo))

saveWorkbook(wb, "outputs/report.xlsx", overwrite = TRUE)
```
