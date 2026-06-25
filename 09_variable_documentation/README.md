# Phase 09 — Variable Documentation & Formats

## Topics Covered

Renaming variables with rename() and rename_with(), applying variable labels with the labelled package, creating factor levels as value labels, and printing a codebook of all variables.

## Files

| File | Description |
|------|-------------|
| `09_variable_documentation.R` | Labels, renaming, and codebook generation |

## Datasets Used

mod6.csv

## Key R Syntax

```r
library(labelled)

# Apply variable labels
var_label(df) <- list(
  studyid = "Unique study participant identifier",
  age     = "Age in years at enrollment",
  vl      = "HIV viral load (copies/mL)")

# Apply value labels (factor)
df <- df %>%
  mutate(sex = factor(sex,
    levels = c(1,2),
    labels = c("Male","Female")))
```
