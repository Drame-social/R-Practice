# R Programming for Public Health Analytics

**Author:** Aly Drame, MD, MPH, MBA
**Language:** R (tidyverse)
**Domain:** HIV surveillance, immunization compliance, epidemiologic data analysis
**Data:** Course datasets from AEPI537D — Intro to SAS Programming, Emory Rollins School of Public Health (converted to CSV for R compatibility)

---

## Overview

This repository applies core R programming skills to real public health datasets, organized by the natural data analysis workflow. It is the R counterpart to [sas-public-health-analytics](https://github.com/Drame-social/sas-public-health-analytics), performing equivalent analyses using idiomatic R (tidyverse / ggplot2).

---

## Workflow

```
01 Environment Setup
     ↓
02 Data Import & Creation
     ↓
03 Data Merging & Subsetting
     ↓
04 Categorical Variables & Dates
     ↓
05 Conditionals & Type Conversion
     ↓
06 R Functions
     ↓
07 Loops & Vectorization
     ↓
08 Longitudinal & Repeated Measures
     ↓
09 Variable Documentation
     ↓
10 Reporting & Export
     ↓
11 Automation & Custom Functions
     ↓
12 Visualization & Mapping
```

---

## Datasets

| File | Rows | Cols | Description |
|------|------|------|-------------|
| aidsvu_2016_newdx_county.csv | 160 | 7 | HIV new diagnoses by county, 2016 |
| atlgrades.csv | 26 | 4 | Student grade records |
| cohort1516.csv | 204 | 6 | Cohort enrollment, 2015–16 |
| cohort1617.csv | 152 | 6 | Cohort enrollment, 2016–17 |
| final_clin.csv | 1,006 | 36 | Clinical HIV outcomes |
| final_demo.csv | 1,006 | 6 | Patient demographics |
| flbygroup.csv | 100 | 3 | Flu data by group |
| labs.csv | 30 | 2 | Laboratory results |
| mod3lab.csv | 356 | 20 | Module 3 lab dataset |
| mod4.csv | 356 | 24 | Module 4 categorical/date data |
| mod6.csv | 356 | 35 | Module 6 variable documentation |
| mod8_a/b/c/d.csv | varies | varies | Arrays and repeated measures |
| mod9.csv | 356 | 20 | Longitudinal visit data |
| mock_data.csv | 50 | 16 | General mock patient data |
| patients.csv | 2,148 | 22 | Patient-level records |
| patients_part2.csv | 1,236 | 22 | Additional patient records |
| phase1.csv / phase2.csv | 20/10 | 4 | Study phase enrollment |
| screener_data.csv | 280 | 5 | Screening questionnaire |
| survey.csv | 356 | 6 | Survey responses |
| tagsetex.csv | 10 | 4 | Tag set example |

---

## Key Packages

| Package | Purpose |
|---------|---------|
| readr | CSV import/export |
| dplyr | Data manipulation and joining |
| tidyr | Reshaping (pivot_longer / pivot_wider) |
| lubridate | Date parsing and arithmetic |
| stringr | String operations |
| forcats | Factor/categorical variable handling |
| purrr | Functional iteration (map/walk) |
| ggplot2 | Data visualization |
| openxlsx | Excel export |
| labelled | Variable labels (SAS-style metadata) |
| maps | US county-level choropleth maps |

---

## How to Run

1. Clone this repo
2. Open RStudio and set the working directory to the repo root
3. Install required packages:
   ```r
   install.packages(c("tidyverse", "lubridate", "openxlsx", "labelled", "maps"))
   ```
4. Run scripts in phase order — each script reads from `./data` and writes outputs to `./data` or a local `./outputs` folder

---

## Related Repositories

- [sas-public-health-analytics](https://github.com/Drame-social/sas-public-health-analytics) — SAS version (same analyses)
- [Introduction-to-Python](https://github.com/Drame-social/Introduction-to-Python) — Python version (same analyses)
