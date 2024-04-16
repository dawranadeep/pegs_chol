setwd("/Users/dawr2/Desktop/Ranadeep_Daw_Projects/pegs")
library(dplyr)
library(car)
library(data.table)
library(caret)


epr.he = fread("data/latest/Surveys/Health_and_Exposure/healthexposure_16jun22_fmtd_v3.1.csv")
load("./output/geosp_covar.Rdata")
epr.geo_all =setDT(epr.geo_all)
epr.geo_all[,c("gis_study_event", "gis_latitude",
               "gis_longitude"):= NULL]




epr.he = epr.he[, c("epr_number", "he_b008_high_cholesterol", 
                    "_he_gender_", "he_bmi_derived", "he_s192_sleep_hours",
                    "he_age_derived", "he_s189_alcohol_day_CHILDQ",
                    "he_s179_100_cigarettes_PARQ", 
                    "he_s183_tobacco_smokeless", "he_k072_sunburn",
                    "he_k073_scars", "he_l076_fatigue"
), with = F]

setnames(epr.he,  "_he_gender_", "gender")



epr.merged = epr.he[epr.geo_all, on = .(epr_number), nomatch = NULL]

epr.merged = subset(epr.merged, gender  %in% c("Man", "Woman"))
epr.merged = subset(epr.merged, he_b008_high_cholesterol  %in% c("No", "Yes"))

remove_missing <- function(dt, col, mis = "'MISSING'"){
  return( eval(parse(text=
                       paste0("subset(", dt, ", ", col, "!=", mis, ")")
                     )))
}

epr.merged = remove_missing("epr.merged", "he_s179_100_cigarettes_PARQ")
epr.merged = remove_missing("epr.merged", "he_age_derived")
epr.merged = remove_missing("epr.merged", "he_bmi_derived")
epr.merged = remove_missing("epr.merged", "he_bmi_derived", "'NULLIFIED DURING QC'")
epr.merged = remove_missing("epr.merged", "he_s192_sleep_hours")
epr.merged = remove_missing("epr.merged", "he_s192_sleep_hours", "'NULLIFIED DURING QC'")
epr.merged = subset(epr.merged, !(he_s189_alcohol_day_CHILDQ  %in%  c("MISSING", "SKIPPED")))
#epr.merged = remove_missing("epr.merged", "he_t203_income")
epr.merged = remove_missing("epr.merged", "he_s183_tobacco_smokeless")
epr.merged = remove_missing("epr.merged", "he_k072_sunburn")
epr.merged = remove_missing("epr.merged", "he_k073_scars")
epr.merged = remove_missing("epr.merged", "he_l076_fatigue")
epr.merged$he_l076_fatigue = sapply(epr.merged$he_l076_fatigue, switch, 
       "Not at all" = "0", "A little bit" = "1", "Somewhat" = "2", "Quite a bit" = "3", "Very much" = "4",
       USE.NAMES = F)




epr.merged <- epr.merged[,gender_cat := 
                           lapply(.SD, function(x){x == "Man"}),
                         .SDcols = "gender"]
epr.merged <- epr.merged[,cigarette_cat := 
                           lapply(.SD, function(x){x == "No"}),
                         .SDcols = "he_s179_100_cigarettes_PARQ"]


fwrite(epr.merged, file = "./output/chol_full.csv")

train.index <- createDataPartition(epr.merged[, he_b008_high_cholesterol], p = .8, list = FALSE)
train <- epr.merged[ train.index,]
test  <- epr.merged[-train.index,]
#save(train, file = "./output/chol_train.Rdata")
#save(test, file = "./output/chol_test.Rdata")

fwrite(train, file = "./output/chol_train.csv")
fwrite(test, file = "./output/chol_test.csv")
