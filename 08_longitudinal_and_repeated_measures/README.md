# Phase 08 — Longitudinal & Repeated Measures

## Topics Covered

Sorting and creating lag variables with lag(), group-level summaries with group_by() + summarise(), wide-to-long reshaping with pivot_longer(), long-to-wide with pivot_wider(), and first/last visit extraction.

## Files

| File | Description |
|------|-------------|
| `08_longitudinal_and_repeated_measures.R` | Longitudinal analysis and reshaping |

## Datasets Used

mod9.csv, mod8_b.csv, mod8_c.csv

## Key R Syntax

```r
# Lag within group
df <- df %>%
  arrange(studyid, visitdate) %>%
  group_by(studyid) %>%
  mutate(prev_vl   = lag(vl),
         visit_num = row_number()) %>%
  ungroup()

# Wide to long
long_df <- df %>%
  pivot_longer(cols = starts_with("visit"),
               names_to = "visit", values_to = "result")
```
