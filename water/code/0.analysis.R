setwd("/Users/dawr2/Desktop/Ranadeep_Daw_Projects/SBOOOST/water")

library(data.table)
library(ggplot2)
library(feather)
water = fread("input/field_results.csv")
water = water[parameter == "WaterTemperature"]
water = water[, c("longitude", "latitude", "fdr_result")]
water = water[complete.cases(water), ]
water = water[longitude < -100, ]
water = water[fdr_result > 0, ]
water = water[fdr_result < 60, ]

setnames(water, c("longitude", "latitude", "fdr_result"), c("Lon", "Lat", "Temperature"))
idx = sample(nrow(water), 25000)

watersub = data.frame(water[idx, ])

ggplot(watersub, aes(x=Lon, y=Lat, col=Temperature)) + 
  geom_point(size=0.3)
ggsave("output/Temperature.pdf")

write_feather(water, "output/water.feather")
