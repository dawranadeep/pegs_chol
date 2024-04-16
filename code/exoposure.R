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

#load("data/latest/Surveys/Health_and_Exposure/healthexposure_16jun22_v3.1.RData")


#fwrite(epr.merged[1:10,], "test.csv")


epr.he = epr.he[, c("epr_number", "he_b008_high_cholesterol", 
          "_he_gender_", "he_bmi_derived", "he_s192_sleep_hours",
          "he_age_derived", "he_s189_alcohol_day_CHILDQ",
          "he_s179_100_cigarettes_PARQ"
          ), with = F]

setnames(epr.he,  "_he_gender_", "gender")

epr.merged = epr.he[epr.geo_all, on = .(epr_number), nomatch = NULL]

epr.merged = subset(epr.merged, gender  %in% c("Man", "Woman"))
epr.merged = subset(epr.merged, he_b008_high_cholesterol  %in% c("No", "Yes"))
epr.merged = subset(epr.merged, he_s179_100_cigarettes_PARQ  != "MISSING")
epr.merged = subset(epr.merged, he_age_derived  != "MISSING")
epr.merged = subset(epr.merged, he_bmi_derived  != "MISSING")
epr.merged = subset(epr.merged, he_bmi_derived  != "NULLIFIED DURING QC")
epr.merged = subset(epr.merged, he_s192_sleep_hours  != "MISSING")
epr.merged = subset(epr.merged, he_s192_sleep_hours  != "NULLIFIED DURING QC")
epr.merged = subset(epr.merged, !(he_s189_alcohol_day_CHILDQ  %in%  c("MISSING", "SKIPPED")))


epr.merged = epr.merged[, he_b008_high_cholesterol := 
                          as.factor(he_b008_high_cholesterol)]



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
