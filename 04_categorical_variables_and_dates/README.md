# Phase 04 — Categorical Variables & Dates

## Topics Covered

Grouping a continuous variable with fixed cut points and with tertiles, deriving birth weight and BMI, converting SAS date numbers and text dates, and computing age at survey.

## Files

| File | Description |
|------|-------------|
| `04_categorical_variables_and_dates.R` | Create categories and work with dates |

## Datasets Used

mod4.csv

Derived files are written to `./outputs/`.

## Key R Syntax

```r
mod4 <- mod4 %>%
  mutate(wt3lev_r   = cut(weight, breaks = c(0, 126, 149, Inf), labels = c(0, 1, 2)),
         wt_tertile = ntile(weight, 3) - 1,                      # PROC RANK GROUPS=3
         birth_date = as.Date(bd, origin = "1960-01-01"),        # SAS date value
         calc_age   = as.numeric(ymd(surveydt) - birth_date) / 365.25)
```
