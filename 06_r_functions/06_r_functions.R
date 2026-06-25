# =============================================================================
# Phase 06 — R Functions
# R equivalent of SAS Module 7 (SAS Functions)
# Packages: readr, dplyr, stringr
# =============================================================================
DATA_PATH <- "./data"

library(readr)
library(dplyr)
library(stringr)

patients <- read_csv(file.path(DATA_PATH, "patients.csv"))

# ----------------------------------------------------------------------------
# 6.1 String functions — equivalent to SAS UPCASE, SUBSTR, INDEX, TRIM
# ----------------------------------------------------------------------------
patients <- patients %>%
  mutate(
    name_upper   = str_to_upper(name),
    name_lower   = str_to_lower(name),
    first3       = str_sub(name, 1, 3),
    name_trimmed = str_trim(name),
    has_dr       = str_detect(name, regex("^Dr\\.", ignore_case = TRUE))
  )

# ----------------------------------------------------------------------------
# 6.2 Numeric functions — equivalent to SAS ROUND, ABS, SQRT, INT
# ----------------------------------------------------------------------------
patients <- patients %>%
  mutate(
    age_rounded = round(age, 0),
    age_sqrt    = sqrt(age),
    age_floor   = floor(age),
    age_abs     = abs(age - 40)   # distance from 40
  )

# ----------------------------------------------------------------------------
# 6.3 Statistical summary functions
# ----------------------------------------------------------------------------
cat("--- Summary Statistics ---\n")
cat("Mean age:   ", mean(patients$age, na.rm = TRUE), "\n")
cat("Median age: ", median(patients$age, na.rm = TRUE), "\n")
cat("SD age:     ", sd(patients$age, na.rm = TRUE), "\n")
cat("Min/Max:    ", min(patients$age, na.rm = TRUE), "/",
                    max(patients$age, na.rm = TRUE), "\n")

# ----------------------------------------------------------------------------
# 6.4 Custom function — equivalent to SAS macro or user-defined format
# ----------------------------------------------------------------------------
bmi_category <- function(bmi) {
  case_when(
    bmi < 18.5             ~ "Underweight",
    bmi < 25.0             ~ "Normal",
    bmi < 30.0             ~ "Overweight",
    TRUE                   ~ "Obese"
  )
}

patients <- patients %>%
  mutate(bmi_cat = bmi_category(bmi))

print(table(patients$bmi_cat))

write_csv(patients, file.path(DATA_PATH, "patients_functions.csv"))
