# Phase 04 — Categorical Variables & Dates

## Topics Covered

Creating factor variables with factor() and cut(), computing frequency tables with table(), parsing dates with lubridate, date arithmetic, and extracting year/month components.

## Files

| File | Description |
|------|-------------|
| `04_categorical_variables_and_dates.R` | Create categories and work with dates |

## Datasets Used

mod4.csv

## Key R Syntax

```r
library(lubridate)

# Categorize age
df <- df %>%
  mutate(age_group = cut(age,
    breaks = c(0,17,34,49,64,Inf),
    labels = c("<18","18-34","35-49","50-64","65+")))

# Date arithmetic
df <- df %>%
  mutate(visitdate_dt = ymd(visitdate),
         visit_year   = year(visitdate_dt))
```
