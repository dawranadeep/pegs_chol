setwd("/Users/dawr2/Desktop/Ranadeep_Daw_Projects/pegs")


library(dplyr)
library(car)


train = readRDS("./data/training_data.rds")
test  = readRDS("./data/testing_data.rds")



load("./data/GIS/gis_15dec22_v3.1.RData")
load("./data/GIS/earthdata_15dec22_v3.1.RData")
load("./data/GIS/eji_21jun23_v3.1.RData")
load("./data/GIS/hazards_15dec22_v3.1.RData")
load("./data/GIS/svi_21jun23_v3.1.RData")


epr.gis = epr.gis[with(epr.gis, order(epr_number,gis_study_event )), ]
epr.earthdata = epr.earthdata[with(epr.earthdata, order(epr_number,gis_study_event )), ]
epr.eji = epr.eji[with(epr.eji, order(epr_number,gis_study_event )), ]
epr.hazards = epr.hazards[with(epr.hazards, order(epr_number,gis_study_event )), ]
epr.svi = epr.svi[with(epr.svi, order(epr_number,gis_study_event )), ]


epr.gis = epr.gis[, c("epr_number", "gis_study_event", "gis_latitude",  "gis_longitude")]
epr.hazards = epr.hazards[complete.cases(epr.hazards), ]
epr.earthdata = epr.earthdata[complete.cases(epr.earthdata), ]

epr.geo_all = epr.gis
epr.geo_all = merge(epr.geo_all, epr.earthdata, by = c('epr_number', 'gis_study_event'))
#epr.geo_all = merge(epr.geo_all, epr.eji, by = c('epr_number', 'gis_study_event'))
epr.geo_all = merge(epr.geo_all, epr.hazards, by = c('epr_number', 'gis_study_event'))
#epr.geo_all = merge(epr.geo_all, epr.svi, by = c('epr_number', 'gis_study_event'))



h_and_e_dup = intersect(epr.geo_all$epr_number[epr.geo_all$gis_study_event == "health_and_exposure"],
          epr.geo_all$epr_number[epr.geo_all$gis_study_event == "current_address_exposome_a"]
)
h_and_e_dup_idx = intersect(which(epr.geo_all$gis_study_event == "health_and_exposure"),
  which(epr.geo_all$epr_number %in% h_and_e_dup))

epr.geo_all = epr.geo_all[-h_and_e_dup_idx, ]



enr_dup = intersect(epr.geo_all$epr_number[epr.geo_all$gis_study_event == "enrollment"],
                        epr.geo_all$epr_number[epr.geo_all$gis_study_event == "current_address_exposome_a"]
)
enr_dup_idx = intersect(which(epr.geo_all$gis_study_event == "enrollment"),
                            which(epr.geo_all$epr_number %in% enr_dup))

epr.geo_all = epr.geo_all[-enr_dup_idx, ]


h_e_enr_dup = intersect(epr.geo_all$epr_number[epr.geo_all$gis_study_event == "enrollment"],
                    epr.geo_all$epr_number[epr.geo_all$gis_study_event == "health_and_exposure"]
)
h_e_enr_dup_idx = intersect(which(epr.geo_all$gis_study_event == "enrollment"),
                        which(epr.geo_all$epr_number %in% h_e_enr_dup))

epr.geo_all = epr.geo_all[-h_e_enr_dup_idx, ]


dim(unique(epr.geo_all[c("epr_number", "gis_study_event")]))
dim(unique(epr.geo_all[c("epr_number")]))


save(epr.geo_all, file = "./output/geosp_covar.Rdata")

