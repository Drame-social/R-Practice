# =============================================================================
# Phase 02 — Data Import & Creation
# R equivalent of SAS Module 2
# Packages: readr, readxl, dplyr
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(readxl)
library(dplyr)

# Read a CSV from ./data and standardize column names to lowercase
read_clean <- function(name) {
  read_csv(file.path(DATA_PATH, name), show_col_types = FALSE) %>%
    rename_with(~ tolower(trimws(.x)))
}

# ----------------------------------------------------------------------------
# 2.1 Import a CSV file — equivalent to SAS PROC IMPORT DBMS=CSV
# ----------------------------------------------------------------------------
phase1 <- read_clean("phase1.csv")
glimpse(phase1)

# ----------------------------------------------------------------------------
# 2.2 Import an Excel file — equivalent to SAS PROC IMPORT DBMS=XLS
#     The .xlsx copy preserves the data from the legacy BIFF4 workbook.
# ----------------------------------------------------------------------------
rawdat1 <- tryCatch(
  read_excel(file.path(DATA_PATH, "raw", "RAWDAT1.xlsx")),
  error = function(e) {
    message("Note: Could not read RAWDAT1.xlsx. ", conditionMessage(e))
    NULL
  }
)
if (!is.null(rawdat1)) glimpse(rawdat1)

# ----------------------------------------------------------------------------
# 2.3 Import a space-delimited text file — equivalent to SAS INFILE / INPUT
#     The file has no header row: study ID, case/control, age, exposure.
# ----------------------------------------------------------------------------
rawdata_txt <- read_table(file.path(DATA_PATH, "raw", "RAWDATA.TXT"),
                          col_names = c("studyid", "caco", "age", "exposure"),
                          col_types = "ccic")
print(head(rawdata_txt))

# ----------------------------------------------------------------------------
# 2.4 Create a dataset in code — equivalent to SAS DATALINES
# ----------------------------------------------------------------------------
sites <- tibble(
  site_id   = 1:3,
  site_name = c("Clinic North", "Clinic South", "Clinic East"),
  enrolled  = c(42, 37, 51)
)
print(sites)

# ----------------------------------------------------------------------------
# 2.5 Concatenate (stack) datasets — equivalent to SAS SET cohort1516 cohort1617
# ----------------------------------------------------------------------------
cohort1516 <- read_clean("cohort1516.csv")
cohort1617 <- read_clean("cohort1617.csv")
cohort_combined <- bind_rows(cohort1516, cohort1617)
cat("cohort1516:", nrow(cohort1516), " cohort1617:", nrow(cohort1617),
    " combined:", nrow(cohort_combined), "\n")
print(count(cohort_combined, yrenroll))

# ----------------------------------------------------------------------------
# 2.6 Stack the two study phases with a source flag — SAS SET ... IN=
# ----------------------------------------------------------------------------
phase2 <- read_clean("phase2.csv")
phases <- bind_rows(`1` = phase1, `2` = phase2, .id = "phase")
cat("phase1 + phase2 stacked:", nrow(phases), "rows\n")
print(phases %>% group_by(phase) %>%
        summarise(mean_age = round(mean(age, na.rm = TRUE), 1),
                  mean_bmi = round(mean(bmi, na.rm = TRUE), 1)))

write_csv(cohort_combined, file.path(OUTPUTS_PATH, "cohort_combined.csv"))
write_csv(phases,          file.path(OUTPUTS_PATH, "phase1_phase2_stacked.csv"))
cat("Saved outputs/cohort_combined.csv and outputs/phase1_phase2_stacked.csv\n")
