# Phase 10 — Reporting & Export

## Topics Covered

Frequency tables with percentages, grouped descriptive statistics, cross-tabulations with counts and row percentages, and exporting a multi-sheet Excel report with openxlsx and a CSV file.

## Files

| File | Description |
|------|-------------|
| `10_reporting_and_export.R` | Reporting and file export |

## Datasets Used

final_demo.csv, final_clin.csv

Derived files are written to `./outputs/`.

## Key R Syntax

```r
demo_clin <- left_join(final_demo, final_clin, by = "id")
demo_clin %>% group_by(hlevel) %>%
  summarise(n = sum(!is.na(bleeds)), mean = mean(bleeds, na.rm = TRUE))
prop.table(table(demo_clin$htype, demo_clin$hlevel), 1)

write.xlsx(list("Summary" = summary_tbl), "outputs/clinical_cohort_report.xlsx")
```
