# Phase 05 — Conditionals & Type Conversion

## Topics Covered

Multi-condition logic with case_when(), binary indicators with as.integer(), type conversions between numeric/character/date, and handling missing values with is.na() and na.rm.

## Files

| File | Description |
|------|-------------|
| `05_conditionals_and_type_conversion.R` | Conditionals, type conversion, and missing data |

## Datasets Used

final_clin.csv

## Key R Syntax

```r
df <- df %>%
  mutate(
    vl_category = case_when(
      vl < 200    ~ "Suppressed",
      vl < 1000   ~ "Low",
      vl < 100000 ~ "Moderate",
      TRUE        ~ "High"),
    suppressed = as.integer(vl < 200))
```
