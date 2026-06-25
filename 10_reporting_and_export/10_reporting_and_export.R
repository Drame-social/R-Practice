# =============================================================================
# Phase 10 — Reporting & Export
# R equivalent of SAS Module 10
# Packages: readr, dplyr, knitr, openxlsx, gtsummary
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)
library(openxlsx)    # install.packages("openxlsx") if needed

final_demo <- read_csv(file.path(DATA_PATH, "final_demo.csv"))
final_clin <- read_csv(file.path(DATA_PATH, "final_clin.csv"))

demo_clin  <- left_join(final_demo, final_clin, by = "studyid")

# ----------------------------------------------------------------------------
# 10.1 Summary table — equivalent to SAS PROC FREQ + PROC MEANS
# ----------------------------------------------------------------------------
cat("--- Descriptive Summary ---\n")
cat("N:", nrow(demo_clin), "\n\n")
cat("Age:\n")
print(summary(demo_clin$age))

cat("\nSex distribution:\n")
print(prop.table(table(demo_clin$sex)) * 100)

cat("\nViral load suppression (<200):\n")
demo_clin <- demo_clin %>%
  mutate(suppressed = vl < 200)
print(table(demo_clin$suppressed))

# ----------------------------------------------------------------------------
# 10.2 Export to Excel — equivalent to SAS ODS EXCEL / PROC EXPORT
# ----------------------------------------------------------------------------
wb <- createWorkbook()

addWorksheet(wb, "Demographics")
writeData(wb, "Demographics", final_demo)
addStyle(wb, "Demographics", createStyle(textDecoration = "bold"),
         rows = 1, cols = 1:ncol(final_demo))

addWorksheet(wb, "Clinical")
writeData(wb, "Clinical", final_clin)

addWorksheet(wb, "Summary")
summary_tbl <- demo_clin %>%
  summarise(
    N              = n(),
    mean_age       = round(mean(age, na.rm = TRUE), 1),
    pct_suppressed = round(mean(suppressed, na.rm = TRUE) * 100, 1)
  )
writeData(wb, "Summary", summary_tbl)

saveWorkbook(wb, file.path(OUTPUTS_PATH, "hiv_cohort_report.xlsx"),
             overwrite = TRUE)
cat("\nExcel report saved to outputs/hiv_cohort_report.xlsx\n")

# ----------------------------------------------------------------------------
# 10.3 Export to CSV — equivalent to SAS PROC EXPORT DBMS=CSV
# ----------------------------------------------------------------------------
write_csv(demo_clin, file.path(OUTPUTS_PATH, "demo_clin_final.csv"))
cat("CSV saved to outputs/demo_clin_final.csv\n")
