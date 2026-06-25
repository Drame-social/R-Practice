# =============================================================================
# Phase 09 — Variable Documentation & Formats
# R equivalent of SAS Module 6 (reordered after transformations)
# Packages: readr, dplyr, labelled
# =============================================================================
DATA_PATH <- "./data"

library(readr)
library(dplyr)
library(labelled)   # install.packages("labelled") if needed

mod6 <- read_csv(file.path(DATA_PATH, "mod6.csv"))

# ----------------------------------------------------------------------------
# 9.1 Rename variables — equivalent to SAS RENAME=
# ----------------------------------------------------------------------------
mod6 <- mod6 %>%
  rename_with(~ tolower(trimws(.x)))   # force all names to lowercase, trimmed

# Targeted renames (example)
if ("pt_id" %in% names(mod6))  mod6 <- mod6 %>% rename(studyid = pt_id)
if ("gender" %in% names(mod6)) mod6 <- mod6 %>% rename(sex = gender)

# ----------------------------------------------------------------------------
# 9.2 Apply variable labels — equivalent to SAS LABEL statement
# ----------------------------------------------------------------------------
var_labels <- c(
  studyid   = "Unique study participant identifier",
  age       = "Age in years at enrollment",
  sex       = "Biological sex (1=Male, 2=Female)",
  race      = "Self-reported race/ethnicity",
  vl        = "HIV viral load (copies/mL)",
  cd4       = "CD4+ T-cell count (cells/mm3)",
  visitdate = "Date of clinic visit"
)
existing_labels <- var_labels[names(var_labels) %in% names(mod6)]
var_label(mod6) <- as.list(existing_labels)

# ----------------------------------------------------------------------------
# 9.3 Apply value labels (factor levels) — equivalent to SAS FORMAT
# ----------------------------------------------------------------------------
if ("sex" %in% names(mod6)) {
  mod6 <- mod6 %>%
    mutate(sex = factor(sex, levels = c(1, 2), labels = c("Male", "Female")))
}

# ----------------------------------------------------------------------------
# 9.4 Print codebook — equivalent to SAS PROC CONTENTS + PROC FORMAT listing
# ----------------------------------------------------------------------------
cat("--- Variable Codebook ---\n")
for (v in names(mod6)) {
  lbl <- attr(mod6[[v]], "label")
  typ <- class(mod6[[v]])[1]
  miss <- sum(is.na(mod6[[v]]))
  cat(sprintf("  %-20s  type=%-10s  missing=%d  label=%s\n",
              v, typ, miss, ifelse(is.null(lbl), "(none)", lbl)))
}

write_csv(mod6, file.path(DATA_PATH, "mod6_documented.csv"))
