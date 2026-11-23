# Phase 11 — Automation & Custom Functions

## Topics Covered

Parameterized functions with tidy evaluation as equivalents of SAS macros, loops over datasets with purrr (%DO), and a small pipeline function that reads, cleans, summarizes, and saves in one call.

## Files

| File | Description |
|------|-------------|
| `11_automation_and_functions.R` | Reusable functions and batch pipelines |

## Datasets Used

final_demo.csv, final_clin.csv, mod3lab.csv, mod4.csv, mod6.csv, mod9.csv, patients.csv, screener_data.csv

Derived files are written to `./outputs/`.

## Key R Syntax

```r
summarize_by <- function(data, group_var, outcome_var) {
  data %>% group_by({{ group_var }}) %>%
    summarise(n = sum(!is.na({{ outcome_var }})),
              mean = mean({{ outcome_var }}, na.rm = TRUE))
}
summarize_by(demo_clin, hlevel, bleeds)
```
