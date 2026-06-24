# =============================================================================
# Phase 02 — Data Import & Creation
# R equivalent of SAS Module 2
# Packages: readr, readxl, haven, dplyr
# =============================================================================
# UPDATE this path to your local project data directory
DATA_PATH <- "./data"

library(readr)
library(readxl)
library(dplyr)

# ----------------------------------------------------------------------------
# 2.1 Import a CSV file
# ----------------------------------------------------------------------------
phase1 <- read_csv(file.path(DATA_PATH, "phase1.csv"))
glimpse(phase1)

# ----------------------------------------------------------------------------
# 2.2 Import an Excel file
# ----------------------------------------------------------------------------
rawdat1 <- read_excel(file.path(DATA_PATH, "raw", "RAWDAT1.xls"))
glimpse(rawdat1)

# ----------------------------------------------------------------------------
# 2.3 Import a delimited text file
# ----------------------------------------------------------------------------
rawdata_txt <- read_delim(file.path(DATA_PATH, "raw", "RAWDATA.TXT"),
                          delim = "\t", col_names = TRUE)

# ----------------------------------------------------------------------------
# 2.4 Concatenate (stack) two datasets — equivalent to SAS DATA SET1 SET2
# ----------------------------------------------------------------------------
cohort1516 <- read_csv(file.path(DATA_PATH, "cohort1516.csv"))
cohort1617 <- read_csv(file.path(DATA_PATH, "cohort1617.csv"))

cohort_combined <- bind_rows(cohort1516, cohort1617)
cat("Combined cohort rows:", nrow(cohort_combined), "\n")

# ----------------------------------------------------------------------------
# 2.5 Full merge of two datasets on a common key — equivalent to SAS MERGE BY
# ----------------------------------------------------------------------------
phase2 <- read_csv(file.path(DATA_PATH, "phase2.csv"))
labs   <- read_csv(file.path(DATA_PATH, "labs.csv"))

# Full join — keeps all records from both (equivalent to SAS MERGE without IN=)
merged_full <- full_join(phase1, phase2, by = "studyid")
cat("Full merge rows:", nrow(merged_full), "\n")

# Inner join — only matched records
merged_inner <- inner_join(phase2, labs, by = "studyid")
cat("Inner join rows:", nrow(merged_inner), "\n")

# Save to CSV
write_csv(cohort_combined,  file.path(DATA_PATH, "cohort_combined.csv"))
write_csv(merged_full,      file.path(DATA_PATH, "phase1_phase2_merged.csv"))
