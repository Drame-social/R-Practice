# Phase 07 — Loops & Vectorization

## Topics Covered

for loops and vectorized operations as equivalents of SAS arrays: recoding a missing-value code across many columns, scoring across items, flagging any matching code across columns, counting non-missing entries, and applying functions over columns and files with purrr.

## Files

| File | Description |
|------|-------------|
| `07_loops_and_vectorization.R` | Loops, apply functions, and purrr |

## Datasets Used

mod8_a.csv, mod8_b.csv, mod8_c.csv, mod8_d.csv, flbygroup.csv, screener_data.csv, survey.csv

Derived files are written to `./outputs/`.

## Key R Syntax

```r
for (v in var_cols) loop_version[[v]][loop_version[[v]] %in% 9] <- NA   # ARRAY / DO
mod8_a <- mutate(mod8_a, across(all_of(var_cols), ~ na_if(.x, 9)))      # vectorized

mod8_d <- mutate(mod8_d, DRUGS = rowSums(!is.na(across(starts_with("DRUG")))))
```
