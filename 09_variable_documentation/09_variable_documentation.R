# =============================================================================
# Phase 09 — Variable Documentation & Formats
# R equivalent of SAS Module 6 (labels, formats, codebook)
# Packages: readr, dplyr, labelled
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)
library(labelled)   # install.packages("labelled") if needed

mod6 <- read_csv(file.path(DATA_PATH, "mod6.csv"), show_col_types = FALSE) %>%
  rename_with(~ tolower(trimws(.x)))

# ----------------------------------------------------------------------------
# 9.1 Variable labels — equivalent to SAS LABEL
#     Labels come from how each variable is derived or labeled in the SAS
#     version of this module. Variables without a documented meaning are left
#     unlabeled rather than guessed.
# ----------------------------------------------------------------------------
var_labels <- list(
  studyid  = "Participant identifier",
  sex1     = "Gender (numeric code)",
  wt3lev   = "Weight category (3 levels)",
  wt2lev   = "Weight category (2 levels)",
  bd       = "Birth date (SAS date value)",
  surveydt = "Survey date",
  weight   = "Weight (lb)",
  heightft = "Height, feet component",
  heightin = "Height, inches component",
  birthlb  = "Birth weight, pounds component",
  birthoz  = "Birth weight, ounces component",
  bw_oz    = "Birth weight (oz)",
  bw_gm    = "Birth weight (g)",
  bw_gm1   = "Low birth weight (<=2500 g)",
  ht_in    = "Height (in)",
  weightkg = "Weight (kg)",
  heightm  = "Height (m)",
  bmi      = "Body mass index (kg/m2)",
  calc_age = "Exact age at survey (years)",
  entryage = "Participant age at enrollment",
  kids     = "Total number of kids in household"
)
var_label(mod6) <- var_labels[names(var_labels) %in% names(mod6)]

# ----------------------------------------------------------------------------
# 9.2 Value labels — equivalent to SAS PROC FORMAT
# ----------------------------------------------------------------------------
yesno <- function(x) factor(x, levels = c(0, 1), labels = c("No", "Yes"))
mod6 <- mod6 %>%
  mutate(smoke_label   = yesno(smoke),
         plane_label   = yesno(plane),
         vitamin_label = yesno(vitamin),
         age_group     = cut(entryage, breaks = c(14, 24, 29, 100),
                             labels = c("<25", "25-29", "30+")))

cat("--- Smoking by weight category (formatted) ---\n")
print(table(mod6$smoke_label, mod6$wt3lev, useNA = "ifany"))
cat("\n--- Age group by smoking ---\n")
print(table(mod6$age_group, mod6$smoke_label, useNA = "ifany"))

# ----------------------------------------------------------------------------
# 9.3 Codebook — equivalent to SAS PROC CONTENTS
# ----------------------------------------------------------------------------
codebook <- tibble(
  variable  = names(mod6),
  type      = vapply(mod6, function(x) class(x)[1], character(1)),
  n_missing = vapply(mod6, function(x) sum(is.na(x)), integer(1)),
  n_unique  = vapply(mod6, function(x) length(unique(na.omit(x))), integer(1)),
  label     = vapply(names(mod6), function(v) {
                lbl <- var_label(mod6[[v]]); if (is.null(lbl)) "" else lbl
              }, character(1))
)
print(codebook, n = Inf)

write_csv(codebook, file.path(OUTPUTS_PATH, "mod6_codebook.csv"))
write_csv(mod6,     file.path(OUTPUTS_PATH, "mod6_documented.csv"))
cat("Saved outputs/mod6_codebook.csv and outputs/mod6_documented.csv\n")
