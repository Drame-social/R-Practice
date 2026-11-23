# Phase 05 — Conditionals & Type Conversion

## Topics Covered

IF-THEN-ELSE logic with if_else(), ordered ELSE IF chains with case_when(), converting text to numbers and dates (SAS INPUT), converting numbers to text (SAS PUT), and missing values in conditions.

## Files

| File | Description |
|------|-------------|
| `05_conditionals_and_type_conversion.R` | Conditionals, type conversion, and missing data |

## Datasets Used

atlgrades.csv

Derived files are written to `./outputs/`.

## Key R Syntax

```r
grades <- grades %>%
  mutate(course   = if_else(grade >= 60, "Pass", "Fail"),
         ltrgrade = case_when(grade >= 90 ~ "A", grade >= 80 ~ "B",
                              grade >= 70 ~ "C", grade >= 60 ~ "D",
                              !is.na(grade) ~ "F"))

as.Date("01-11-2019", format = "%m-%d-%Y")   # INPUT(x, mmddyy10.)
```
