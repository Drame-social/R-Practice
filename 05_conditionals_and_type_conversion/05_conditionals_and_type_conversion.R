# =============================================================================
# Phase 05 — Conditionals & Type Conversion
# R equivalent of SAS Module 5
# Packages: readr, dplyr
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)

grades <- read_csv(file.path(DATA_PATH, "atlgrades.csv"), show_col_types = FALSE) %>%
  rename_with(tolower)

# ----------------------------------------------------------------------------
# 5.1 IF-THEN-ELSE — pass/fail
# ----------------------------------------------------------------------------
grades <- mutate(grades, course = if_else(grade >= 60, "Pass", "Fail"))
print(count(grades, course))

# ----------------------------------------------------------------------------
# 5.2 IF-THEN / ELSE IF chain — letter grades
#     case_when() checks conditions in order, like SAS ELSE IF. Separate IF
#     statements without ELSE would let later conditions overwrite earlier
#     ones, which is the common SAS mistake this mirrors.
# ----------------------------------------------------------------------------
grades <- grades %>%
  mutate(ltrgrade = case_when(
    grade >= 90 ~ "A",
    grade >= 80 ~ "B",
    grade >= 70 ~ "C",
    grade >= 60 ~ "D",
    !is.na(grade) ~ "F"
  ))
print(head(select(grades, name, grade, ltrgrade)))
print(table(grades$group, grades$ltrgrade))

# ----------------------------------------------------------------------------
# 5.3 Character to numeric — equivalent to SAS INPUT() with informats
# ----------------------------------------------------------------------------
cat("\n'50000'      ->", as.numeric("50000"), "\n")
cat("'15%'        ->", as.numeric(sub("%", "", "15%")) / 100, "\n")
cat("'43,000.24'  ->", as.numeric(gsub(",", "", "43,000.24")), "\n")
cat("'01-11-2019' ->", format(as.Date("01-11-2019", format = "%m-%d-%Y")), "\n\n")

# ----------------------------------------------------------------------------
# 5.4 Numeric to character — equivalent to SAS PUT()
# ----------------------------------------------------------------------------
grades <- grades %>%
  mutate(grade_txt  = if_else(is.na(grade), "", sprintf("%.0f", grade)),
         attend_txt = recode(attendx, `1` = "Attended", `0` = "Absent"))
glimpse(grades)

# ----------------------------------------------------------------------------
# 5.5 Missing values in conditions
# ----------------------------------------------------------------------------
cat("Missing grades:", sum(is.na(grades$grade)), "\n")

write_csv(grades, file.path(OUTPUTS_PATH, "atlgrades_processed.csv"))
cat("Saved outputs/atlgrades_processed.csv\n")
