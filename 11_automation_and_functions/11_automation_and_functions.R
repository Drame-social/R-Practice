# =============================================================================
# Phase 11 — Automation & Custom Functions
# R equivalent of SAS Module 11 (Macros)
# Packages: readr, dplyr, purrr
# =============================================================================
DATA_PATH <- "./data"

library(readr)
library(dplyr)
library(purrr)

# ----------------------------------------------------------------------------
# 11.1 Custom reusable function — equivalent to SAS %MACRO
# ----------------------------------------------------------------------------
summarize_cohort <- function(data, group_var, outcome_var) {
  data %>%
    group_by({{ group_var }}) %>%
    summarise(
      n        = n(),
      mean_val = round(mean({{ outcome_var }}, na.rm = TRUE), 2),
      sd_val   = round(sd({{ outcome_var }}, na.rm = TRUE), 2),
      missing  = sum(is.na({{ outcome_var }})),
      .groups  = "drop"
    )
}

final_clin <- read_csv(file.path(DATA_PATH, "final_clin.csv"),
                       show_col_types = FALSE)
final_demo <- read_csv(file.path(DATA_PATH, "final_demo.csv"),
                       show_col_types = FALSE)

demo_clin <- left_join(final_demo, final_clin, by = "studyid")

# Run the same function for multiple outcomes
cat("--- CD4 by Sex ---\n")
print(summarize_cohort(demo_clin, sex, cd4))

cat("\n--- Viral Load by Sex ---\n")
print(summarize_cohort(demo_clin, sex, vl))

# ----------------------------------------------------------------------------
# 11.2 Apply function across multiple datasets — equivalent to SAS %DO loop
# ----------------------------------------------------------------------------
dataset_names <- c("mod3lab", "mod4", "mod6", "mod9")
datasets <- map(dataset_names,
                ~ read_csv(file.path(DATA_PATH, paste0(.x, ".csv")),
                           show_col_types = FALSE))
names(datasets) <- dataset_names

dim_report <- map_dfr(names(datasets),
                      ~ tibble(dataset = .x,
                               rows    = nrow(datasets[[.x]]),
                               cols    = ncol(datasets[[.x]])))

cat("\n--- Dataset Inventory ---\n")
print(dim_report)

# ----------------------------------------------------------------------------
# 11.3 Pipeline function — wrap a full analysis into one callable unit
# ----------------------------------------------------------------------------
run_vl_pipeline <- function(csv_name) {
  read_csv(file.path(DATA_PATH, csv_name), show_col_types = FALSE) %>%
    filter(!is.na(vl)) %>%
    mutate(suppressed = vl < 200) %>%
    summarise(
      dataset     = csv_name,
      n           = n(),
      pct_supp    = round(mean(suppressed) * 100, 1)
    )
}

vl_results <- map_dfr(c("mod3lab.csv", "mod9.csv"), run_vl_pipeline)
cat("\n--- Viral Load Suppression Pipeline ---\n")
print(vl_results)
