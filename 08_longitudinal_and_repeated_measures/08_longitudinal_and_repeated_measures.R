# =============================================================================
# Phase 08 — Longitudinal & Repeated Measures
# R equivalent of SAS Module 9
# Packages: readr, dplyr, tidyr
# =============================================================================
DATA_PATH <- "./data"

library(readr)
library(dplyr)
library(tidyr)
library(lubridate)

mod9    <- read_csv(file.path(DATA_PATH, "mod9.csv"))
mod8_b  <- read_csv(file.path(DATA_PATH, "mod8_b.csv"))
mod8_c  <- read_csv(file.path(DATA_PATH, "mod8_c.csv"))

# ----------------------------------------------------------------------------
# 8.1 Sort and lag — equivalent to SAS LAG() / RETAIN
# ----------------------------------------------------------------------------
mod9 <- mod9 %>%
  arrange(studyid, visitdate) %>%
  group_by(studyid) %>%
  mutate(
    prev_vl      = lag(vl),
    vl_change    = vl - prev_vl,
    visit_number = row_number()
  ) %>%
  ungroup()

# ----------------------------------------------------------------------------
# 8.2 Summarize by group — equivalent to SAS PROC MEANS BY / PROC SUMMARY
# ----------------------------------------------------------------------------
patient_summary <- mod9 %>%
  group_by(studyid) %>%
  summarise(
    n_visits     = n(),
    first_visit  = min(visitdate, na.rm = TRUE),
    last_visit   = max(visitdate, na.rm = TRUE),
    mean_vl      = mean(vl, na.rm = TRUE),
    min_cd4      = min(cd4, na.rm = TRUE),
    max_cd4      = max(cd4, na.rm = TRUE),
    ever_suppressed = any(vl < 200, na.rm = TRUE),
    .groups = "drop"
  )

cat("Patients summarized:", nrow(patient_summary), "\n")

# ----------------------------------------------------------------------------
# 8.3 Wide ↔ Long reshape — equivalent to SAS PROC TRANSPOSE
# ----------------------------------------------------------------------------
# Wide → Long (pivot_longer)
mod8_c_long <- mod8_c %>%
  pivot_longer(cols = starts_with("visit"),
               names_to  = "visit_num",
               values_to = "result")

# Long → Wide (pivot_wider)
mod8_c_wide <- mod8_c_long %>%
  pivot_wider(names_from  = "visit_num",
              values_from = "result")

# ----------------------------------------------------------------------------
# 8.4 First and last observation per subject
# ----------------------------------------------------------------------------
first_visits <- mod9 %>%
  group_by(studyid) %>%
  slice_min(visitdate, n = 1) %>%
  ungroup()

last_visits <- mod9 %>%
  group_by(studyid) %>%
  slice_max(visitdate, n = 1) %>%
  ungroup()

write_csv(patient_summary,  file.path(DATA_PATH, "patient_longitudinal_summary.csv"))
write_csv(mod8_c_long,      file.path(DATA_PATH, "mod8_c_long.csv"))
