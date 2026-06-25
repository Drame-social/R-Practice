# =============================================================================
# Phase 12 — Visualization & Mapping
# R equivalent of SAS Module 12
# Packages: ggplot2, dplyr, readr, maps
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)
library(ggplot2)

final_demo  <- read_csv(file.path(DATA_PATH, "final_demo.csv"),  show_col_types = FALSE)
final_clin  <- read_csv(file.path(DATA_PATH, "final_clin.csv"),  show_col_types = FALSE)
aidsvu      <- read_csv(file.path(DATA_PATH, "aidsvu_2016_newdx_county.csv"),
                        show_col_types = FALSE)

demo_clin <- left_join(final_demo, final_clin, by = "studyid") %>%
  mutate(
    age_group  = cut(age,
                     breaks = c(0, 24, 34, 44, 54, Inf),
                     labels = c("<25","25-34","35-44","45-54","55+")),
    suppressed = factor(vl < 200, levels = c(FALSE, TRUE),
                        labels = c("Not Suppressed", "Suppressed"))
  )

# ----------------------------------------------------------------------------
# 12.1 Bar chart — viral load suppression by sex
# ----------------------------------------------------------------------------
p1 <- ggplot(demo_clin %>% filter(!is.na(suppressed), !is.na(sex)),
             aes(x = factor(sex, labels = c("Male","Female")),
                 fill = suppressed)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("#d9534f","#5cb85c")) +
  labs(title    = "Viral Load Suppression by Sex",
       x        = "Sex",
       y        = "Proportion",
       fill     = "VL Status",
       caption  = "VL suppression defined as <200 copies/mL") +
  theme_minimal()

ggsave(file.path(OUTPUTS_PATH, "vl_suppression_by_sex.png"),
       p1, width = 6, height = 4, dpi = 150)

# ----------------------------------------------------------------------------
# 12.2 Histogram — CD4 count distribution
# ----------------------------------------------------------------------------
p2 <- ggplot(demo_clin %>% filter(!is.na(cd4)),
             aes(x = cd4)) +
  geom_histogram(bins = 30, fill = "#337ab7", color = "white") +
  geom_vline(xintercept = 200, linetype = "dashed", color = "red") +
  annotate("text", x = 230, y = 30, label = "CD4=200", color = "red", size = 3) +
  labs(title = "CD4 Count Distribution",
       x = "CD4 Count (cells/mm³)",
       y = "Frequency") +
  theme_minimal()

ggsave(file.path(OUTPUTS_PATH, "cd4_distribution.png"),
       p2, width = 6, height = 4, dpi = 150)

# ----------------------------------------------------------------------------
# 12.3 Box plot — CD4 by age group
# ----------------------------------------------------------------------------
p3 <- ggplot(demo_clin %>% filter(!is.na(cd4), !is.na(age_group)),
             aes(x = age_group, y = cd4, fill = age_group)) +
  geom_boxplot(alpha = 0.7, outlier.shape = 21) +
  scale_fill_brewer(palette = "Blues") +
  labs(title = "CD4 Count by Age Group",
       x = "Age Group",
       y = "CD4 Count (cells/mm³)") +
  theme_minimal() +
  theme(legend.position = "none")

ggsave(file.path(OUTPUTS_PATH, "cd4_by_age_group.png"),
       p3, width = 7, height = 4, dpi = 150)

# ----------------------------------------------------------------------------
# 12.4 County-level choropleth — AIDSVu new diagnoses
# ----------------------------------------------------------------------------
if (requireNamespace("maps", quietly = TRUE)) {
  library(maps)
  county_map <- map_data("county")
  aidsvu_clean <- aidsvu %>%
    rename_with(tolower) %>%
    mutate(subregion = tolower(gsub(" County", "", county)))

  map_data_merged <- county_map %>%
    left_join(aidsvu_clean, by = c("subregion"))

  p4 <- ggplot(map_data_merged, aes(long, lat, group = group, fill = rate)) +
    geom_polygon(color = NA) +
    scale_fill_viridis_c(option = "magma", na.value = "grey90",
                         name = "Rate per\n100,000") +
    labs(title   = "HIV New Diagnoses by County (2016)",
         caption = "Source: AIDSVu 2016") +
    theme_void()

  ggsave(file.path(OUTPUTS_PATH, "hiv_new_dx_county_map.png"),
         p4, width = 9, height = 5, dpi = 150)
  cat("Map saved.\n")
}

cat("All plots saved to outputs/\n")
