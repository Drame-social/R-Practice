# =============================================================================
# Phase 11 — Automation & Custom Functions
# R equivalent of SAS Module 11 (Macros)
# Packages: readr, dplyr, purrr
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)
library(purrr)

# ----------------------------------------------------------------------------
# 11.1 Reusable function — equivalent to a parameterized SAS %MACRO
# ----------------------------------------------------------------------------
summarize_by <- function(data, group_var, outcome_var) {
  data %>%
    group_by({{ group_var }}) %>%
    summarise(n       = sum(!is.na({{ outcome_var }})),
              mean    = round(mean({{ outcome_var }}, na.rm = TRUE), 2),
              sd      = round(sd({{ outcome_var }},   na.rm = TRUE), 2),
              missing = sum(is.na({{ outcome_var }})),
              .groups = "drop")
}

final_demo <- read_csv(file.path(DATA_PATH, "final_demo.csv"), show_col_types = FALSE)
final_clin <- read_csv(file.path(DATA_PATH, "final_clin.csv"), show_col_types = FALSE)
demo_clin  <- left_join(final_demo, final_clin, by = "id")

# Call the "macro" with different parameters
cat("--- bleeds by hlevel ---\n");  print(summarize_by(demo_clin, hlevel, bleeds))
cat("--- bleeds by htype ---\n");   print(summarize_by(demo_clin, htype,  bleeds))
cat("--- weightkg by htype ---\n"); print(summarize_by(demo_clin, htype,  weightkg))

# ----------------------------------------------------------------------------
# 11.2 Loop over datasets — equivalent to a SAS %DO loop
# ----------------------------------------------------------------------------
inventory <- map_dfr(c("mod3lab", "mod4", "mod6", "mod9", "patients", "final_clin"),
  function(name) {
    df <- read_csv(file.path(DATA_PATH, paste0(name, ".csv")), show_col_types = FALSE)
    tibble(dataset     = name,
           rows        = nrow(df),
           cols        = ncol(df),
           pct_missing = round(mean(is.na(df)) * 100, 2))
  })
cat("--- Dataset inventory ---\n"); print(inventory)

# ----------------------------------------------------------------------------
# 11.3 Pipeline — one function that reads, cleans, summarizes, and saves
# ----------------------------------------------------------------------------
run_screening_pipeline <- function(csv_name, out_name) {
  summary <- read_csv(file.path(DATA_PATH, csv_name), show_col_types = FALSE) %>%
    mutate(month = format(as.Date(Vdatesub), "%Y-%m")) %>%
    group_by(SITE, month) %>%
    summarise(screened     = n(),
              complete     = sum(Vstatus == "Complete", na.rm = TRUE),
              eligible     = sum(elig == 1, na.rm = TRUE),
              elig_missing = sum(is.na(elig)),
              .groups = "drop")
  write_csv(summary, file.path(OUTPUTS_PATH, out_name))
  summary
}

screening <- run_screening_pipeline("screener_data.csv", "screening_by_site_month.csv")
cat("--- Screening by site and month ---\n"); print(screening, n = Inf)
write_csv(inventory, file.path(OUTPUTS_PATH, "dataset_inventory.csv"))
cat("Saved outputs/screening_by_site_month.csv and outputs/dataset_inventory.csv\n")
