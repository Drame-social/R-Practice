# Phase 08 — Longitudinal & Repeated Measures

## Topics Covered

Working with several visits per patient: visits per patient, first visit (SAS FIRST.), visit numbers, lagged values and change, per-patient summaries merged back to baseline, and reshaping with pivot_longer() and pivot_wider() (PROC TRANSPOSE).

## Files

| File | Description |
|------|-------------|
| `08_longitudinal_and_repeated_measures.R` | Longitudinal analysis and reshaping |

## Datasets Used

patients.csv, mod8_c.csv

Derived files are written to `./outputs/`.

## Key R Syntax

```r
first_visit <- patients %>% arrange(id, visdate) %>%
  group_by(id) %>% slice_head(n = 1) %>% ungroup()              # IF FIRST.id

patients <- patients %>% group_by(id) %>%
  mutate(visit_number = row_number(),
         weight_change = weight - lag(weight)) %>% ungroup()      # LAG
```
