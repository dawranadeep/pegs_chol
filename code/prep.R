setwd("/Users/dawr2/Desktop/Ranadeep_Daw_Projects/pegs")
library(dplyr)
library(car)


train = readRDS("./data/training_data.rds")
test  = readRDS("./data/testing_data.rds")

train$race = recode(train$race,
                     "'Black or African American'='Black';
                     'White'='White';
                     c('Multiple', 
                     'Native Hawaiian or Other Pacific Islanders',
                     'Asian',
                     'American Indian and Alaska Native') = 'Other'
                     ")

test$race = recode(test$race,
                    "'Black or African American'='Black';
                     'White'='White';
                     c('Multiple', 
                     'Native Hawaiian or Other Pacific Islanders',
                     'Asian',
                     'American Indian and Alaska Native') = 'Other'
                     ")



train$he_t203_income = NULL
train$he_t204_home_type = NULL
test$he_t204_home_type = NULL

race_prep <- function(df){
  df = cbind(df, model.matrix(~0+race, data=df))
  df$he_p136h_employ_perm = as.numeric(df$he_p136h_employ_perm) - 1
  df$he_l076_fatigue_fact = as.factor(df$he_l076_fatigue)
  df = cbind(df, model.matrix(~0+he_l076_fatigue_fact, data=df))
  df$race = NULL
  df$he_l076_fatigue = NULL
  df$he_l076_fatigue_fact = NULL
  #df$epr_number = NULL
  df$broad_wgs_sample_id_CHILDQ = NULL
  df$gender = ifelse(df$gender == "Female", 1, 0)
  df$he_c021_pre_diabetes_PARQ = as.numeric(df$he_c021_pre_diabetes_PARQ) - 1
  df$hypertension_derived = as.numeric(df$hypertension_derived) - 1
  df$he_b008_high_cholesterol = as.numeric(df$he_b008_high_cholesterol) - 1
  df$he_s179_100_cigarettes_PARQ = as.numeric(df$he_s179_100_cigarettes_PARQ) - 1
  df$he_q152_other_dust_PARQ = as.numeric(df$he_q152_other_dust_PARQ) - 1
  df$he_u210f_unusual_thoughts_PARQ = as.numeric(df$he_u210f_unusual_thoughts_PARQ) - 1
  df$he_p136c_employ_retired = as.numeric(df$he_p136c_employ_retired) - 1
  df$he_q143_coal_dust_PARQ = as.numeric(df$he_q143_coal_dust_PARQ) - 1
  df$he_u213_bipolar_relatives = as.numeric(df$he_u213_bipolar_relatives) - 1
  df$he_u210g_unusual_distracted_PARQ = as.numeric(df$he_u210g_unusual_distracted_PARQ) - 1
  #df = cbind(df, model.matrix(~0+he_t204_home_type, data=df))
  #df$he_t204_home_type = NULL
  df$he_t207_home_payment_diff = as.factor(df$he_t207_home_payment_diff)
  df = cbind(df, model.matrix(~0+he_t207_home_payment_diff, data=df))
  df$he_t207_home_payment_diff = NULL
  df$he_t197_mother_highest_edu_PARQ = as.factor(df$he_t197_mother_highest_edu_PARQ)
  df = cbind(df, model.matrix(~0+he_t197_mother_highest_edu_PARQ, data=df))
  df$he_t197_mother_highest_edu_PARQ = NULL
  df$he_t194_father_highest_edu_PARQ = as.factor(df$he_t194_father_highest_edu_PARQ)
  df = cbind(df, model.matrix(~0+he_t194_father_highest_edu_PARQ, data=df))
  df$he_t194_father_highest_edu_PARQ = NULL
  #df$he_t203_income = as.factor(df$he_t203_income)
  #df = cbind(df, model.matrix(~0+he_t203_income, data=df))
  #df$he_t203_income = NULL
  df
}

train <- race_prep(train)
test <- race_prep(test)


names(train) == names(test)



