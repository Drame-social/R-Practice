# Phase 09 — Variable Documentation & Formats

## Topics Covered

Variable labels with the labelled package (SAS LABEL), value labels with factor() and cut() (PROC FORMAT), formatted cross-tabulations, and a codebook table (PROC CONTENTS). Variables without a documented meaning are left unlabeled.

## Files

| File | Description |
|------|-------------|
| `09_variable_documentation.R` | Labels, value formats, and codebook |

## Datasets Used

mod6.csv

Derived files are written to `./outputs/`.

## Key R Syntax

```r
var_label(mod6) <- list(bmi = "Body mass index (kg/m2)",
                        entryage = "Participant age at enrollment")

yesno <- function(x) factor(x, levels = c(0, 1), labels = c("No", "Yes"))
mod6 <- mutate(mod6, smoke_label = yesno(smoke))
```
