# Phase 06 — R Functions

## Topics Covered

Character functions (equivalents of SAS COMPRESS, UPCASE, SCAN, SUBSTR, INDEX, COUNTW), numeric functions across columns (MEAN, SUM, N, ABS, INT, SQRT), date parts, and a user-defined function.

## Files

| File | Description |
|------|-------------|
| `06_r_functions.R` | String, numeric, and custom functions |

## Datasets Used

mock_data.csv

Derived files are written to `./outputs/`.

## Key R Syntax

```r
mock <- mock %>%
  mutate(phone_digits = str_remove_all(phone_num, "\\D"),          # COMPRESS
         email_domain = str_split_i(email, "@", 2),                 # SCAN
         score_mean   = rowMeans(across(score1:score5), na.rm = TRUE),
         score_band   = score_band(score_mean))
```
