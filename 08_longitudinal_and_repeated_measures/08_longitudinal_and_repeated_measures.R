# =============================================================================
# Phase 08 — Longitudinal & Repeated Measures
# R equivalent of SAS Module 9
# Data: patients.csv has one row per visit and several visits per patient.
# Packages: readr, dplyr, tidyr
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)
library(tidyr)

patients <- read_csv(file.path(DATA_PATH, "patients.csv"), show_col_types = FALSE,
                     col_types = cols(weight = col_double(), height = col_double(),
                                      visdate = col_date()))

# ----------------------------------------------------------------------------
# 8.1 Visits per patient — SAS PROC SUMMARY CLASS id; SUM of VISIT=1
# ----------------------------------------------------------------------------
totvisit <- count(patients, id, name = "totvisit")
cat("Patients:", n_distinct(patients$id), " Visits:", nrow(patients), "\n")
cat("--- Visits per patient ---\n"); print(count(totvisit, totvisit))

# ----------------------------------------------------------------------------
# 8.2 First visit per patient — SAS BY id; IF FIRST.id
# ----------------------------------------------------------------------------
patients    <- arrange(patients, id, visdate)
first_visit <- patients %>% group_by(id) %>% slice_head(n = 1) %>% ungroup()
cat("--- Full-time employment at baseline (empft) ---\n")
print(count(first_visit, empft))

# ----------------------------------------------------------------------------
# 8.3 Visit number, lag and change — SAS RETAIN / LAG within BY group
# ----------------------------------------------------------------------------
patients <- patients %>%
  group_by(id) %>%
  mutate(visit_number    = row_number(),
         prev_weight     = lag(weight),
         weight_change   = weight - prev_weight,
         days_since_prev = as.numeric(visdate - lag(visdate))) %>%
  ungroup()
print(head(select(patients, id, visdate, visit_number, weight,
                  weight_change, days_since_prev), 6))

# ----------------------------------------------------------------------------
# 8.4 Per-patient summaries merged back to baseline — PROC SUMMARY + MERGE
# ----------------------------------------------------------------------------
per_patient <- patients %>%
  group_by(id) %>%
  summarise(totvisit  = n(),
            avgblds   = mean(allblds, na.rm = TRUE),
            avgjtblds = mean(jtblds,  na.rm = TRUE),
            everempft = max(empft,    na.rm = TRUE),
            .groups = "drop")
baseline <- left_join(first_visit, per_patient, by = "id")
cat("--- Average bleeds per visit, per patient ---\n")
print(summary(per_patient$avgblds))

# ----------------------------------------------------------------------------
# 8.5 Wide to long and back — SAS PROC TRANSPOSE (clot locations in mod8_c)
# ----------------------------------------------------------------------------
mod8_c <- read_csv(file.path(DATA_PATH, "mod8_c.csv"), show_col_types = FALSE)
mod8_c_long <- mod8_c %>%
  pivot_longer(starts_with("LOCATN"), names_to = "position",
               values_to = "location", values_drop_na = TRUE)
cat("mod8_c wide:", dim(mod8_c), " -> long (non-missing):", dim(mod8_c_long), "\n")
mod8_c_wide <- pivot_wider(mod8_c_long, id_cols = STUDYID,
                           names_from = position, values_from = location)
cat("Back to wide:", dim(mod8_c_wide), "\n")

write_csv(baseline,    file.path(OUTPUTS_PATH, "patient_baseline_summary.csv"))
write_csv(mod8_c_long, file.path(OUTPUTS_PATH, "mod8_c_long.csv"))
cat("Saved outputs/patient_baseline_summary.csv and outputs/mod8_c_long.csv\n")
