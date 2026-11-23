# Phase 12 — Visualization & Mapping

## Topics Covered

Grouped bar charts, histograms, and box plots with ggplot2, and a county map of HIV new-diagnosis rates for Georgia (AIDSVu, 2016) using county boundaries from the maps package. Negative values in the AIDSVu file are suppression codes and are set to missing; suppressed counties are shown in grey.

## Files

| File | Description |
|------|-------------|
| `12_visualization_and_mapping.R` | ggplot2 charts and county choropleth map |

## Datasets Used

final_demo.csv, final_clin.csv, aidsvu_2016_newdx_county.csv

Derived files are written to `./outputs/`.

## Key R Syntax

```r
aidsvu <- aidsvu %>%
  filter(!is.na(county_name)) %>%
  mutate(newdx_rate = if_else(newdx_rate < 0, NA_real_, newdx_rate))  # suppression codes

ga_map <- left_join(map_data("county", "georgia") %>% mutate(key = gsub("[^a-z]", "", subregion)),
                    aidsvu, by = "key")
ggplot(ga_map, aes(long, lat, group = group, fill = newdx_rate)) + geom_polygon()
```
