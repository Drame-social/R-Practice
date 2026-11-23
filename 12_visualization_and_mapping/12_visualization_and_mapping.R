# =============================================================================
# Phase 12 — Visualization & Mapping
# R equivalent of SAS Module 12 (SGPLOT and county-level HIV data)
# Packages: readr, dplyr, ggplot2, maps
# =============================================================================
DATA_PATH    <- "./data"
OUTPUTS_PATH <- "./outputs"
dir.create(OUTPUTS_PATH, showWarnings = FALSE)

library(readr)
library(dplyr)
library(ggplot2)
library(maps)        # county boundaries; install.packages("maps") if needed

final_demo <- read_csv(file.path(DATA_PATH, "final_demo.csv"), show_col_types = FALSE)
final_clin <- read_csv(file.path(DATA_PATH, "final_clin.csv"), show_col_types = FALSE)
aidsvu     <- read_csv(file.path(DATA_PATH, "aidsvu_2016_newdx_county.csv"),
                       show_col_types = FALSE)
demo_clin  <- left_join(final_demo, final_clin, by = "id") %>%
  filter(!is.na(hlevel)) %>%
  mutate(hlevel = factor(hlevel, levels = c("Mild", "Moderate", "Severe")))

# ----------------------------------------------------------------------------
# 12.1 Grouped bar chart — hlevel by htype (SGPLOT VBAR / GROUP=)
# ----------------------------------------------------------------------------
p1 <- ggplot(demo_clin, aes(x = hlevel, fill = htype)) +
  geom_bar(position = "dodge") +
  labs(title = "Patients by hlevel and htype", x = "hlevel", y = "Patients",
       fill = "htype") +
  theme_minimal()
ggsave(file.path(OUTPUTS_PATH, "hlevel_by_htype.png"), p1, width = 6, height = 4, dpi = 150)

# ----------------------------------------------------------------------------
# 12.2 Histogram — bleeds (SGPLOT HISTOGRAM)
# ----------------------------------------------------------------------------
p2 <- ggplot(filter(demo_clin, !is.na(bleeds)), aes(x = bleeds)) +
  geom_histogram(bins = 30, colour = "white") +
  labs(title = "Distribution of bleeds", x = "Bleeds", y = "Patients") +
  theme_minimal()
ggsave(file.path(OUTPUTS_PATH, "bleeds_histogram.png"), p2, width = 6, height = 4, dpi = 150)

# ----------------------------------------------------------------------------
# 12.3 Box plot — bleeds by hlevel (SGPLOT VBOX / CATEGORY=)
# ----------------------------------------------------------------------------
p3 <- ggplot(filter(demo_clin, !is.na(bleeds)), aes(x = hlevel, y = bleeds)) +
  geom_boxplot() +
  labs(title = "Bleeds by hlevel", x = "hlevel", y = "Bleeds") +
  theme_minimal()
ggsave(file.path(OUTPUTS_PATH, "bleeds_by_hlevel.png"), p3, width = 6, height = 4, dpi = 150)

# ----------------------------------------------------------------------------
# 12.4 County map of HIV new-diagnosis rates, Georgia 2016 (AIDSVu)
#      Negative values are suppression codes, not rates, so they are set to
#      missing. County boundaries come from the maps package.
# ----------------------------------------------------------------------------
aidsvu <- aidsvu %>%
  filter(!is.na(county_name)) %>%                      # drop the blank last row
  mutate(across(c(newdx_rate, newdx_cases), ~ if_else(.x < 0, NA_real_, .x)),
         key = gsub("[^a-z]", "", tolower(sub(" County$", "", county_name))))
cat("Counties:", nrow(aidsvu), "; with a reported rate:", sum(!is.na(aidsvu$newdx_rate)),
    "; suppressed:", sum(is.na(aidsvu$newdx_rate)), "\n")

ga_counties <- map_data("county", "georgia") %>%
  mutate(key = gsub("[^a-z]", "", subregion))          # "de kalb" -> "dekalb"
ga_map <- left_join(ga_counties, aidsvu, by = "key")
cat("County polygons without a matching AIDSVu row:",
    n_distinct(ga_map$key[is.na(ga_map$county_name)]), "\n")

p4 <- ggplot(ga_map, aes(long, lat, group = group, fill = newdx_rate)) +
  geom_polygon(colour = "white", linewidth = 0.1) +
  coord_quickmap() +
  scale_fill_viridis_c(option = "magma", direction = -1, na.value = "grey85",
                       name = "Rate per\n100,000") +
  labs(title = "HIV new-diagnosis rates by county, Georgia 2016",
       subtitle = "Grey: suppressed or not reported") +
  theme_void()
ggsave(file.path(OUTPUTS_PATH, "ga_county_newdx_map.png"), p4, width = 7, height = 7, dpi = 150)

cat("Plots saved to outputs/\n")
