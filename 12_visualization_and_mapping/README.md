# Phase 12 — Visualization & Mapping

## Topics Covered

Bar charts and stacked proportional bars with ggplot2, histograms with reference lines, box plots by group, saving plots to PNG with ggsave, and county-level choropleth maps using the maps package and AIDSVu data.

## Files

| File | Description |
|------|-------------|
| `12_visualization_and_mapping.R` | ggplot2 charts and county choropleth map |

## Datasets Used

final_demo.csv, final_clin.csv, aidsvu_2016_newdx_county.csv

## Key R Syntax

```r
library(ggplot2)

# Bar chart
ggplot(df, aes(x = sex, fill = suppressed)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal()

# Save to file
ggsave("outputs/plot.png", width = 6, height = 4, dpi = 150)
```
