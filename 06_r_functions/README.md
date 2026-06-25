# Phase 06 — R Functions

## Topics Covered

String functions from stringr (str_to_upper, str_sub, str_detect), numeric functions (round, sqrt, floor), statistical summaries (mean, median, sd), and writing custom functions with case_when.

## Files

| File | Description |
|------|-------------|
| `06_r_functions.R` | String, numeric, and custom functions |

## Datasets Used

patients.csv

## Key R Syntax

```r
library(stringr)

# String functions
df <- df %>%
  mutate(name_upper = str_to_upper(name),
         first3     = str_sub(name, 1, 3))

# Custom function
bmi_category <- function(bmi) {
  case_when(bmi < 18.5 ~ "Underweight",
            bmi < 25   ~ "Normal",
            TRUE       ~ "Overweight/Obese")
}
```
