# Phase 03 — Data Merging & Subsetting

## Topics Covered

Merging by ID with full_join() and left_join() (SAS MERGE and IN=), subsetting rows with filter() and columns with select(), anti-joins, and sorting with arrange().

## Files

| File | Description |
|------|-------------|
| `03_data_merging_and_subsetting.R` | Merge, filter, and sort datasets |

## Datasets Used

phase2.csv, labs.csv, mod3lab.csv, final_demo.csv, final_clin.csv

Derived files are written to `./outputs/`.

## Key R Syntax

```r
p2_labs   <- left_join(phase2, labs, by = "studyid")          # MERGE ... IF A;
females   <- filter(mod3lab, sex == "female")                  # WHERE
lifestyle <- select(mod3lab, studyid, sex, smoke, sleep)       # KEEP=
unmatched <- anti_join(final_demo, final_clin, by = "id")
```
