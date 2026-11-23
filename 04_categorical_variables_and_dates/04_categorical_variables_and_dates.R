# =============================================================================
# Phase 04 — Categorical Variables & Dates
# R equivalent of SAS Module 4
# Packages: readr, dplyr, lubridate
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)
library(lubridate)

mod4 <- read_csv(file.path(DATA_PATH, "mod4.csv"), show_col_types = FALSE) %>%
  rename_with(tolower)

# ----------------------------------------------------------------------------
# 4.1 Distribution of a continuous variable — equivalent to PROC UNIVARIATE
# ----------------------------------------------------------------------------
cat("--- Weight (lb) ---\n")
print(summary(mod4$weight))

# ----------------------------------------------------------------------------
# 4.2 Two-level and three-level categories — equivalent to IF-THEN grouping
# ----------------------------------------------------------------------------
mod4 <- mod4 %>%
  mutate(
    wt2lev_r   = case_when(weight > 135 ~ 1, weight > 0 ~ 0),
    wt3lev_r   = cut(weight, breaks = c(0, 126, 149, Inf), labels = c(0, 1, 2)),
    wt_tertile = ntile(weight, 3) - 1          # PROC RANK GROUPS=3 (ties split)
  )
cat("\n--- WT2LEV (0: <=135 lb, 1: >135 lb) ---\n");  print(count(mod4, wt2lev_r))
cat("\n--- WT3LEV (cut points 126 and 149 lb) ---\n"); print(count(mod4, wt3lev_r))
cat("\n--- Weight tertiles ---\n");                    print(count(mod4, wt_tertile))

# ----------------------------------------------------------------------------
# 4.3 Derived numeric variables — birth weight and BMI
# ----------------------------------------------------------------------------
mod4 <- mod4 %>%
  mutate(
    bw_oz    = birthlb * 16 + birthoz,
    bw_gm    = bw_oz * 28.35,
    low_bw   = if_else(bw_gm <= 2500, 1, 0),
    ht_in    = heightft * 12 + heightin,
    weightkg = weight * 0.4536,
    heightm  = ht_in * 0.0254,
    bmi      = weightkg / heightm^2
  )
cat("\n--- Low birth weight (<=2500 g) ---\n"); print(count(mod4, low_bw))
cat("\n--- BMI ---\n");                         print(summary(mod4$bmi))

# ----------------------------------------------------------------------------
# 4.4 Dates — convert a SAS date number and a text date, then compute age
#     SAS stores dates as days since 1 January 1960.
# ----------------------------------------------------------------------------
mod4 <- mod4 %>%
  mutate(
    birth_date  = as.Date(bd, origin = "1960-01-01"),
    survey_date = ymd(surveydt),
    calc_age    = as.numeric(survey_date - birth_date) / 365.25,
    entryage    = floor(calc_age),
    survey_year = year(survey_date)
  )
print(head(select(mod4, studyid, birth_date, survey_date, calc_age, entryage)))
cat("\n--- Survey year ---\n"); print(count(mod4, survey_year))

write_csv(mod4, file.path(OUTPUTS_PATH, "mod4_processed.csv"))
cat("Saved outputs/mod4_processed.csv\n")
