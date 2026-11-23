# =============================================================================
# Phase 06 — R Functions
# R equivalent of SAS Module 7 (SAS Functions)
# Packages: readr, dplyr, stringr, lubridate
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)
library(stringr)
library(lubridate)

mock <- read_csv(file.path(DATA_PATH, "mock_data.csv"), show_col_types = FALSE) %>%
  select(-password)   # credentials-style field is not needed for any exercise

# ----------------------------------------------------------------------------
# 6.1 Character functions — SAS COMPRESS, UPCASE, SCAN, SUBSTR, INDEX, COUNTW
# ----------------------------------------------------------------------------
mock <- mock %>%
  mutate(
    phone_digits  = str_remove_all(phone_num, "\\D"),          # COMPRESS
    supervisor_uc = str_to_upper(supervisor),                  # UPCASE
    last_name     = word(supervisor, -1),                      # SCAN(x, -1)
    email_domain  = str_split_i(email, "@", 2),                # SCAN(x, 2, '@')
    area_code     = str_sub(phone_digits, 1, 3),               # SUBSTR
    has_red       = str_detect(colors, "red"),                 # INDEX > 0
    n_colors      = str_count(colors, ",") + 1,                # COUNTW
    zip5          = str_pad(zipcode, 5, pad = "0")             # PUT(z, z5.)
  )
print(head(select(mock, phone_num, phone_digits, supervisor, last_name,
                  email_domain, zip5)))

# ----------------------------------------------------------------------------
# 6.2 Numeric functions — SAS MEAN, SUM, N, ABS, INT, SQRT
# ----------------------------------------------------------------------------
score_cols <- paste0("score", 1:5)
mock <- mock %>%
  mutate(
    score_mean = round(rowMeans(across(all_of(score_cols)), na.rm = TRUE), 2),
    score_sum  = rowSums(across(all_of(score_cols)), na.rm = TRUE),
    score_n    = rowSums(!is.na(across(all_of(score_cols)))),
    value_abs  = abs(value),
    value_int  = trunc(value),
    value_sqrt = round(sqrt(value_abs), 3)
  )
print(head(select(mock, value, value_abs, value_int, value_sqrt)))

# ----------------------------------------------------------------------------
# 6.3 Date functions — SAS YEAR, MONTH, INTCK
# ----------------------------------------------------------------------------
mock <- mock %>%
  mutate(date         = ymd(date),
         year         = year(date),
         month        = month(date),
         days_to_2018 = as.numeric(ymd("2018-01-01") - date))

# ----------------------------------------------------------------------------
# 6.4 Summary statistics — equivalent to PROC MEANS
# ----------------------------------------------------------------------------
cat("\n--- Mean score per record ---\n")
print(summary(mock$score_mean))

# ----------------------------------------------------------------------------
# 6.5 User-defined function — reusable categorization
# ----------------------------------------------------------------------------
score_band <- function(x) {
  case_when(is.na(x) ~ NA_character_,
            x < 4    ~ "Low",
            x < 7    ~ "Medium",
            TRUE     ~ "High")
}
mock <- mutate(mock, score_band = score_band(score_mean))
print(count(mock, score_band))

write_csv(mock, file.path(OUTPUTS_PATH, "mock_data_functions.csv"))
cat("Saved outputs/mock_data_functions.csv\n")
