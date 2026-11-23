# =============================================================================
# Phase 03 — Data Merging & Subsetting
# R equivalent of SAS Module 3
# Packages: readr, dplyr
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)

read_clean <- function(name) {
  read_csv(file.path(DATA_PATH, name), show_col_types = FALSE) %>%
    rename_with(~ tolower(trimws(.x)))
}

phase2     <- read_clean("phase2.csv")
labs       <- read_clean("labs.csv")
mod3lab    <- read_clean("mod3lab.csv")
final_demo <- read_clean("final_demo.csv")
final_clin <- read_clean("final_clin.csv")

# ----------------------------------------------------------------------------
# 3.1 Merge by ID — equivalent to SAS PROC SORT + DATA ... MERGE ... BY studyid
# ----------------------------------------------------------------------------
p2_labs_all <- full_join(phase2 %>% mutate(in_phase2 = TRUE),
                         labs   %>% mutate(in_labs = TRUE), by = "studyid")
cat("--- phase2 MERGE labs (all records) ---\n")
print(count(p2_labs_all, in_phase2, in_labs))

# Keep only phase2 records — equivalent to MERGE phase2(IN=A) labs; IF A;
p2_labs <- left_join(phase2, labs, by = "studyid")
cat("phase2 records kept:", nrow(p2_labs), "; with an MTHFR result:",
    sum(!is.na(p2_labs$mthfr)), "\n\n")

# ----------------------------------------------------------------------------
# 3.2 Subset rows — equivalent to SAS WHERE / subsetting IF
# ----------------------------------------------------------------------------
females        <- filter(mod3lab, sex == "female")
married_smoker <- filter(mod3lab, marital == "married", smoke == 1)
cat("mod3lab:", nrow(mod3lab), "rows; female:", nrow(females),
    "; married and smoking:", nrow(married_smoker), "\n")

# ----------------------------------------------------------------------------
# 3.3 Subset columns — equivalent to SAS KEEP= / DROP=
# ----------------------------------------------------------------------------
lifestyle <- select(mod3lab, studyid, sex, smoke, sleep, calorie, fruit, vitamin)
no_dates  <- select(mod3lab, -bd, -surveydt)
cat("KEEP 7 columns:", ncol(lifestyle), "; DROP 2 columns:", ncol(no_dates), "\n\n")

# ----------------------------------------------------------------------------
# 3.4 One-to-one merge of demographic and clinical files on patient ID
# ----------------------------------------------------------------------------
demo_clin <- left_join(final_demo, final_clin, by = "id")
cat("final_demo:", nrow(final_demo), " merged:", nrow(demo_clin), "\n")

# ----------------------------------------------------------------------------
# 3.5 Anti-join — demographic records with no clinical record
# ----------------------------------------------------------------------------
unmatched_demo <- anti_join(final_demo, final_clin, by = "id")
cat("Unmatched demographic records:", nrow(unmatched_demo), "\n\n")

# ----------------------------------------------------------------------------
# 3.6 Sort — equivalent to SAS PROC SORT BY htype DESCENDING bleeds
# ----------------------------------------------------------------------------
demo_clin_sorted <- arrange(demo_clin, htype, desc(bleeds))
print(head(select(demo_clin_sorted, id, htype, hlevel, bleeds)))

write_csv(demo_clin,      file.path(OUTPUTS_PATH, "demo_clin_merged.csv"))
write_csv(unmatched_demo, file.path(OUTPUTS_PATH, "unmatched_demo.csv"))
cat("Saved outputs/demo_clin_merged.csv and outputs/unmatched_demo.csv\n")
