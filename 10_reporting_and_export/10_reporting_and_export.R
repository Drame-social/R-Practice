# =============================================================================
# Phase 10 — Reporting & Export
# R equivalent of SAS Module 10 (PROC FREQ / MEANS, ODS, PROC EXPORT)
# Data: final_demo.csv and final_clin.csv, linked by patient id
# Packages: readr, dplyr, openxlsx
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)
library(openxlsx)    # install.packages("openxlsx") if needed

final_demo <- read_csv(file.path(DATA_PATH, "final_demo.csv"), show_col_types = FALSE)
final_clin <- read_csv(file.path(DATA_PATH, "final_clin.csv"), show_col_types = FALSE)
demo_clin  <- left_join(final_demo, final_clin, by = "id")

# ----------------------------------------------------------------------------
# 10.1 Frequency tables — equivalent to PROC FREQ
# ----------------------------------------------------------------------------
cat("N patients:", nrow(demo_clin), "\n\n")
for (v in c("htype", "hlevel", "hepther")) {
  cat("---", v, "---\n")
  print(demo_clin %>% count(.data[[v]]) %>% mutate(pct = round(n / sum(n) * 100, 1)))
}

# ----------------------------------------------------------------------------
# 10.2 Descriptive statistics by group — equivalent to PROC MEANS CLASS hlevel
# ----------------------------------------------------------------------------
bleeds_by_level <- demo_clin %>%
  filter(!is.na(hlevel)) %>%
  group_by(hlevel) %>%
  summarise(n      = sum(!is.na(bleeds)),
            mean   = round(mean(bleeds, na.rm = TRUE), 1),
            sd     = round(sd(bleeds, na.rm = TRUE), 1),
            median = median(bleeds, na.rm = TRUE),
            min    = min(bleeds, na.rm = TRUE),
            max    = max(bleeds, na.rm = TRUE),
            .groups = "drop")
cat("--- Bleeds by hlevel ---\n"); print(bleeds_by_level)

# ----------------------------------------------------------------------------
# 10.3 Cross-tabulation — equivalent to PROC FREQ TABLES htype*hlevel
# ----------------------------------------------------------------------------
xtab <- table(demo_clin$htype, demo_clin$hlevel)
cat("\n--- htype by hlevel (counts) ---\n");  print(addmargins(xtab))
cat("\n--- htype by hlevel (row %) ---\n");   print(round(prop.table(xtab, 1) * 100, 1))

# ----------------------------------------------------------------------------
# 10.4 Multi-sheet Excel report — equivalent to ODS EXCEL / PROC EXPORT
# ----------------------------------------------------------------------------
summary_tbl <- tibble(
  n_patients     = nrow(demo_clin),
  n_hemophilia_a = sum(demo_clin$htype == "Hemophilia A", na.rm = TRUE),
  n_hemophilia_b = sum(demo_clin$htype == "Hemophilia B", na.rm = TRUE),
  mean_bleeds    = round(mean(demo_clin$bleeds, na.rm = TRUE), 1),
  median_bleeds  = median(demo_clin$bleeds, na.rm = TRUE)
)
xlsx_path <- file.path(OUTPUTS_PATH, "clinical_cohort_report.xlsx")
write.xlsx(list("Summary"         = summary_tbl,
                "Bleeds by level" = bleeds_by_level,
                "Type by level"   = as.data.frame.matrix(addmargins(xtab))),
           xlsx_path, rowNames = c(FALSE, FALSE, TRUE), overwrite = TRUE)
cat("Excel report saved to", xlsx_path, "\n")

# ----------------------------------------------------------------------------
# 10.5 CSV export — equivalent to PROC EXPORT DBMS=CSV
# ----------------------------------------------------------------------------
write_csv(demo_clin, file.path(OUTPUTS_PATH, "demo_clin_final.csv"))
cat("CSV saved to outputs/demo_clin_final.csv\n")
