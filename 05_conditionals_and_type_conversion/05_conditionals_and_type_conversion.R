# =============================================================================
# Phase 05 — Conditionals & Type Conversion
# R equivalent of SAS Module 5
# Packages: readr, dplyr
# =============================================================================
DATA_PATH <- "./data"

library(readr)
library(dplyr)

final_clin <- read_csv(file.path(DATA_PATH, "final_clin.csv"))

# ----------------------------------------------------------------------------
# 5.1 Simple conditional — equivalent to SAS IF-THEN-ELSE
# ----------------------------------------------------------------------------
final_clin <- final_clin %>%
  mutate(
    vl_category = case_when(
      vl < 200          ~ "Suppressed",
      vl < 1000         ~ "Low",
      vl < 100000       ~ "Moderate",
      TRUE              ~ "High"
    )
  )

# ----------------------------------------------------------------------------
# 5.2 Binary indicator from condition — equivalent to SAS IF x THEN y = 1
# ----------------------------------------------------------------------------
final_clin <- final_clin %>%
  mutate(
    suppressed   = as.integer(vl < 200),
    on_art       = as.integer(!is.na(art_start_date)),
    missing_cd4  = as.integer(is.na(cd4))
  )

# ----------------------------------------------------------------------------
# 5.3 Type conversion — equivalent to SAS INPUT() and PUT()
# ----------------------------------------------------------------------------
final_clin <- final_clin %>%
  mutate(
    # Numeric to character
    studyid_char  = as.character(studyid),
    # Character to numeric (NAs introduced for non-numeric)
    vl_numeric    = suppressWarnings(as.numeric(vl)),
    # Character to date
    art_date_dt   = as.Date(art_start_date, format = "%Y-%m-%d")
  )

# ----------------------------------------------------------------------------
# 5.4 Handling missing values
# ----------------------------------------------------------------------------
cat("Missing CD4 count:", sum(is.na(final_clin$cd4)), "\n")

final_clin_nomiss <- final_clin %>% filter(!is.na(cd4))
cat("After dropping missing CD4:", nrow(final_clin_nomiss), "\n")

# Replace missing with mean
mean_cd4 <- mean(final_clin$cd4, na.rm = TRUE)
final_clin <- final_clin %>%
  mutate(cd4_imputed = ifelse(is.na(cd4), mean_cd4, cd4))

write_csv(final_clin, file.path(DATA_PATH, "final_clin_processed.csv"))
