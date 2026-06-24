# =============================================================================
# Phase 03 — Data Merging & Subsetting
# R equivalent of SAS Module 3
# Packages: readr, dplyr
# =============================================================================
DATA_PATH <- "./data"

library(readr)
library(dplyr)

mod3lab     <- read_csv(file.path(DATA_PATH, "mod3lab.csv"))
final_demo  <- read_csv(file.path(DATA_PATH, "final_demo.csv"))
final_clin  <- read_csv(file.path(DATA_PATH, "final_clin.csv"))

# ----------------------------------------------------------------------------
# 3.1 Subset rows — keep only records meeting a condition
# ----------------------------------------------------------------------------
hiv_positive <- mod3lab %>% filter(hivstatus == 1)
cat("HIV-positive records:", nrow(hiv_positive), "\n")

# Multiple conditions
adults_hiv <- mod3lab %>% filter(hivstatus == 1, age >= 18)

# ----------------------------------------------------------------------------
# 3.2 Subset columns — keep only variables of interest
# ----------------------------------------------------------------------------
demo_slim <- final_demo %>% select(studyid, age, sex, race)

# ----------------------------------------------------------------------------
# 3.3 One-to-many merge — equivalent to SAS MERGE with IN=
# ----------------------------------------------------------------------------
# Left join: all demo rows, matched clinical rows
demo_clin_left <- left_join(final_demo, final_clin, by = "studyid")

# Inner join: only matched records
demo_clin_inner <- inner_join(final_demo, final_clin, by = "studyid")

cat("Left join rows:", nrow(demo_clin_left), "\n")
cat("Inner join rows:", nrow(demo_clin_inner), "\n")

# ----------------------------------------------------------------------------
# 3.4 Anti-join — records in demo NOT in clinical (equivalent to SAS IN=A !IN=B)
# ----------------------------------------------------------------------------
unmatched_demo <- anti_join(final_demo, final_clin, by = "studyid")
cat("Unmatched demo records:", nrow(unmatched_demo), "\n")

# ----------------------------------------------------------------------------
# 3.5 Sort a dataset
# ----------------------------------------------------------------------------
mod3_sorted <- mod3lab %>% arrange(studyid, desc(visitdate))

write_csv(demo_clin_left,  file.path(DATA_PATH, "demo_clin_merged.csv"))
write_csv(unmatched_demo,  file.path(DATA_PATH, "unmatched_demo.csv"))
