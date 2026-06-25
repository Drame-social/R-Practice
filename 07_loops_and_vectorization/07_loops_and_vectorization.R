# =============================================================================
# Phase 07 — Loops & Vectorization
# R equivalent of SAS Module 8 (Arrays)
# Packages: readr, dplyr, purrr
# =============================================================================
DATA_PATH <- "./data"

library(readr)
library(dplyr)
library(purrr)

mod8_a <- read_csv(file.path(DATA_PATH, "mod8_a.csv"))

# ----------------------------------------------------------------------------
# 7.1 for loop — equivalent to SAS DO loop
# ----------------------------------------------------------------------------
cat("--- For Loop: Variable Summaries ---\n")
numeric_vars <- names(mod8_a)[sapply(mod8_a, is.numeric)]
for (v in numeric_vars) {
  cat(sprintf("  %-20s  mean=%.2f  missing=%d\n",
              v,
              mean(mod8_a[[v]], na.rm = TRUE),
              sum(is.na(mod8_a[[v]]))))
}

# ----------------------------------------------------------------------------
# 7.2 sapply / lapply — equivalent to SAS array processing
# ----------------------------------------------------------------------------
# Compute mean for all numeric columns at once
col_means <- sapply(mod8_a[, numeric_vars], mean, na.rm = TRUE)
cat("\n--- Column Means ---\n")
print(round(col_means, 2))

# ----------------------------------------------------------------------------
# 7.3 purrr::map — functional iteration (tidyverse style)
# ----------------------------------------------------------------------------
datasets_to_read <- c("flbygroup.csv", "screener_data.csv", "survey.csv")
all_datasets <- map(datasets_to_read,
                    ~ read_csv(file.path(DATA_PATH, .x), show_col_types = FALSE))
names(all_datasets) <- tools::file_path_sans_ext(datasets_to_read)
cat("\n--- Dataset Dimensions ---\n")
walk2(names(all_datasets), all_datasets,
      ~ cat(sprintf("  %-20s  %d rows x %d cols\n", .x, nrow(.y), ncol(.y))))

# ----------------------------------------------------------------------------
# 7.4 Vectorized column operations — R's default, no loop needed
# ----------------------------------------------------------------------------
mod8_a <- mod8_a %>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))   # round all numeric cols

write_csv(mod8_a, file.path(DATA_PATH, "mod8_a_processed.csv"))
