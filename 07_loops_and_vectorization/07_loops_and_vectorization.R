# =============================================================================
# Phase 07 — Loops & Vectorization
# R equivalent of SAS Module 8 (Arrays)
# Packages: readr, dplyr, purrr
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)
library(purrr)

mod8_a <- read_csv(file.path(DATA_PATH, "mod8_a.csv"), show_col_types = FALSE)
mod8_b <- read_csv(file.path(DATA_PATH, "mod8_b.csv"), show_col_types = FALSE)
mod8_c <- read_csv(file.path(DATA_PATH, "mod8_c.csv"), show_col_types = FALSE)
mod8_d <- read_csv(file.path(DATA_PATH, "mod8_d.csv"), show_col_types = FALSE)

# ----------------------------------------------------------------------------
# 7.1 Recode a missing-value code across many columns
#     SAS: ARRAY blanks{15} var1-var15; DO i=1 TO 15; IF blanks{i}=9 THEN .
# ----------------------------------------------------------------------------
var_cols <- paste0("var", 1:15)
before <- sum(as.matrix(mod8_a[var_cols]) == 9, na.rm = TRUE)

loop_version <- mod8_a
for (v in var_cols) {                                   # explicit loop
  loop_version[[v]][loop_version[[v]] %in% 9] <- NA
}
vector_version <- mod8_a %>%                            # vectorized version
  mutate(across(all_of(var_cols), ~ na_if(.x, 9)))
cat("Values coded 9 recoded to missing:", before, "\n")
cat("Loop and vectorized versions agree:",
    isTRUE(all.equal(loop_version, vector_version)), "\n\n")
mod8_a <- vector_version

# ----------------------------------------------------------------------------
# 7.2 Score across columns, missing if any item is missing (SAS Example 2)
# ----------------------------------------------------------------------------
mod8_b <- mutate(mod8_b, score = TEST1 + TEST2 + TEST3)   # NA if any item is NA
cat("--- Score (0-3) ---\n"); print(count(mod8_b, score))

# ----------------------------------------------------------------------------
# 7.3 Flag if any column holds a target code (SAS Example 3)
#     LOC = 1 if any LOCATN1-10 is in (1, 2, 6, 7); FAMHIS = RELTCLOT and LOC
# ----------------------------------------------------------------------------
loc_cols <- paste0("LOCATN", 1:10)
mod8_c <- mod8_c %>%
  mutate(LOC    = as.integer(rowSums(across(all_of(loc_cols), ~ .x %in% c(1, 2, 6, 7))) > 0),
         FAMHIS = as.integer(RELTCLOT %in% 1 & LOC == 1))
print(count(mod8_c, RELTCLOT, LOC, FAMHIS))

# ----------------------------------------------------------------------------
# 7.4 Count non-missing entries across 21 columns (SAS Example 4)
# ----------------------------------------------------------------------------
drug_cols <- grep("^DRUG", names(mod8_d), value = TRUE)
mod8_d <- mutate(mod8_d, DRUGS = rowSums(!is.na(across(all_of(drug_cols)))))
cat("--- Number of drug entries per person ---\n"); print(count(mod8_d, DRUGS))

# ----------------------------------------------------------------------------
# 7.5 Apply a function over columns and over files (purrr)
# ----------------------------------------------------------------------------
col_missing <- map_int(mod8_a[var_cols], ~ sum(is.na(.x)))
print(col_missing)

walk(c("flbygroup.csv", "screener_data.csv", "survey.csv"), function(f) {
  df <- read_csv(file.path(DATA_PATH, f), show_col_types = FALSE)
  cat(sprintf("  %-20s %d rows x %d cols\n", f, nrow(df), ncol(df)))
})

write_csv(mod8_a, file.path(OUTPUTS_PATH, "mod8_a_recoded.csv"))
cat("Saved outputs/mod8_a_recoded.csv\n")
