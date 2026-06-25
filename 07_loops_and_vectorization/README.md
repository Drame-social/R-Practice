# Phase 07 — Loops & Vectorization

## Topics Covered

for loops over variable lists, sapply/lapply for column-wise operations, purrr::map for reading multiple datasets, and across() for vectorized column transformations.

## Files

| File | Description |
|------|-------------|
| `07_loops_and_vectorization.R` | Loops, apply functions, and purrr |

## Datasets Used

mod8_a.csv, flbygroup.csv, screener_data.csv, survey.csv

## Key R Syntax

```r
library(purrr)

# Read multiple files
datasets <- map(file_list,
  ~ read_csv(file.path(DATA_PATH, .x)))

# Apply function to all numeric columns
df <- df %>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))
```
