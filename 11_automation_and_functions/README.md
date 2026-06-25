# Phase 11 — Automation & Custom Functions

## Topics Covered

Writing reusable analysis functions with tidy evaluation ({{ }}), running the same function across multiple outcomes, using map_dfr to batch-process datasets, and wrapping full pipelines into callable functions.

## Files

| File | Description |
|------|-------------|
| `11_automation_and_functions.R` | Reusable functions and batch pipelines |

## Datasets Used

final_demo.csv, final_clin.csv, mod3lab.csv, mod4.csv, mod6.csv, mod9.csv

## Key R Syntax

```r
# Reusable summary function
summarize_cohort <- function(data, group_var, outcome_var) {
  data %>%
    group_by({{ group_var }}) %>%
    summarise(n    = n(),
              mean = mean({{ outcome_var }}, na.rm = TRUE),
              .groups = "drop")
}

# Batch read + summarize
results <- map_dfr(file_list, run_vl_pipeline)
```
