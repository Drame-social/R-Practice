# Phase 03 — Data Merging & Subsetting

## Topics Covered

Filtering rows with filter(), selecting columns with select(), one-to-many merges, anti-joins to find unmatched records, and sorting with arrange().

## Files

| File | Description |
|------|-------------|
| `03_data_merging_and_subsetting.R` | Merge, filter, and sort datasets |

## Datasets Used

mod3lab.csv, final_demo.csv, final_clin.csv

## Key R Syntax

```r
# Filter rows
hiv_pos <- mod3lab %>% filter(hivstatus == 1)

# Anti-join — unmatched records
unmatched <- anti_join(final_demo, final_clin, by = "studyid")

# Sort
sorted <- mod3lab %>% arrange(studyid, desc(visitdate))
```
