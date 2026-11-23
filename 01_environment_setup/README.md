# Phase 01 — Environment Setup

## Topics Covered

Installing R and RStudio, setting the working directory, installing packages with install.packages(), loading libraries with library(), understanding the R console and script editor.

## Files

| File | Description |
|------|-------------|
| `README.md` | This file |

## Datasets Used

None

## Key R Syntax

```r
# Install the packages used in this repository
install.packages(c("tidyverse", "lubridate", "readxl", "openxlsx", "labelled", "maps"))
library(tidyverse)

# Set working directory
setwd("/path/to/your/project")

# Check R version
R.version.string
```
