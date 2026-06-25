# =============================================================================
# Phase 04 — Categorical Variables & Dates
# R equivalent of SAS Module 4
# Packages: readr, dplyr, lubridate, forcats
# =============================================================================
DATA_PATH <- "./data"

library(readr)
library(dplyr)
library(lubridate)
library(forcats)

mod4 <- read_csv(file.path(DATA_PATH, "mod4.csv"))

# ----------------------------------------------------------------------------
# 4.1 Create a categorical (factor) variable from a numeric — equivalent to SAS FORMAT
# ----------------------------------------------------------------------------
mod4 <- mod4 %>%
  mutate(
    age_group = cut(age,
                    breaks = c(0, 17, 34, 49, 64, Inf),
                    labels = c("<18", "18-34", "35-49", "50-64", "65+"),
                    right  = TRUE),
    sex_label = factor(sex, levels = c(1, 2), labels = c("Male", "Female"))
  )

# ----------------------------------------------------------------------------
# 4.2 Frequency counts — equivalent to SAS PROC FREQ
# ----------------------------------------------------------------------------
cat("\n--- Age Group Distribution ---\n")
print(table(mod4$age_group))

cat("\n--- Sex Distribution ---\n")
print(table(mod4$sex_label))

# ----------------------------------------------------------------------------
# 4.3 Date parsing and arithmetic — equivalent to SAS date functions
# ----------------------------------------------------------------------------
mod4 <- mod4 %>%
  mutate(
    # Parse character dates
    visitdate_dt = ymd(visitdate),
    birthdate_dt = ymd(birthdate),
    # Calculate age from dates
    age_calc     = as.numeric(difftime(visitdate_dt, birthdate_dt, units = "days")) %/% 365.25,
    # Year and month extraction
    visit_year   = year(visitdate_dt),
    visit_month  = month(visitdate_dt, label = TRUE)
  )

cat("\n--- Visit Year Distribution ---\n")
print(table(mod4$visit_year))

write_csv(mod4, file.path(DATA_PATH, "mod4_processed.csv"))
