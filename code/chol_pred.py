import os
import pandas as pd
import numpy as np

from sklearn.ensemble import RandomForestClassifier as RFC
from sklearn.metrics import confusion_matrix
from sklearn.tree import DecisionTreeClassifier


def eval_cm(predictions):
    TP = predictions[1,1]
    TN = predictions[0,0]
    FP = predictions[0,1]
    FN = predictions[1,0]
    sens = TP/(TP + FN)
    spec = TN/(TN + FP)
    acc = (TP + TN)/(TP + TN + FP + FN)
    return sens, spec, acc


os.chdir("/Users/dawr2/Desktop/Ranadeep_Daw_Projects/pegs")



train = pd.read_csv("output/chol_train.csv")
test  = pd.read_csv("output/chol_test.csv")



features = [x for x in train.columns if x not in ['epr_number', 'he_b008_high_cholesterol', 'gender', 'he_s179_100_cigarettes_PARQ'] ]
rf = RFC(n_estimators=1000, random_state=42,
         max_depth=2,
         n_jobs=-1,
         class_weight="balanced")
rf.fit(train[features], 
       train.he_b008_high_cholesterol)


features2 = ["gender_cat", "cigarette_cat",
             "he_bmi_derived",                   
             "he_s192_sleep_hours",              
             "he_age_derived",              
             "he_s189_alcohol_day_CHILDQ" ]
#rf.fit(train[features2], train.he_b008_high_cholesterol)
#np.corrcoef(train.he_b008_high_cholesterol == "Yes", train.he_bmi_derived)
#np.corrcoef(train.he_b008_high_cholesterol == "Yes", train.he_s192_sleep_hours)
#np.corrcoef(train.he_b008_high_cholesterol == "Yes", train.cigarette_cat)
#np.corrcoef(train.he_b008_high_cholesterol == "Yes", train.gender_cat)


predictions = rf.predict(test[features])
print(confusion_matrix(test.he_b008_high_cholesterol, predictions))

sensitivity, specificity, accuracy = eval_cm(confusion_matrix(test.he_b008_high_cholesterol, predictions))
print(sensitivity, specificity, accuracy)


# Get numerical feature importances
importances = list(rf.feature_importances_)

# List of tuples with variable and importance
feature_importances = [(feature, round(importance, 5)) for feature, importance in zip(features, importances)]

# Sort the feature importances by most important first
feature_importances = sorted(feature_importances, key = lambda x: x[1], reverse = True)

# Print out the feature and importances 
[print('Variable: {:20} Importance: {}'.format(*pair)) for pair in feature_importances];




dt = DecisionTreeClassifier(criterion="entropy",max_depth=3)
dt.fit(train[features2], train.he_b008_high_cholesterol)
predictions = dt.predict(test[features2])
print(confusion_matrix(test.he_b008_high_cholesterol, predictions))



from sklearn.ensemble import AdaBoostClassifier
AdaBoost = AdaBoostClassifier(n_estimators=1000,learning_rate=0.25,algorithm='SAMME')

AdaBoost.fit(train[features], train.he_b008_high_cholesterol)

predictions = AdaBoost.predict(test[features])
print(confusion_matrix(test.he_b008_high_cholesterol, predictions))

sensitivity, specificity, accuracy = eval_cm(confusion_matrix(test.he_b008_high_cholesterol, predictions))
print(sensitivity, specificity, accuracy)






import xgboost as xgb
# Define hyperparameters
params = {"objective": "binary:logistic",
          "max_depth": 2,
          "sampling_method": "gradient_based"}

# Create regression matrices
dtrain_reg = xgb.DMatrix(train[features], train.he_b008_high_cholesterol == "Yes", enable_categorical=True)
dtest_reg = xgb.DMatrix(test[features], test.he_b008_high_cholesterol == "Yes", enable_categorical=True)
model = xgb.train(
   params=params,
   dtrain=dtrain_reg,
   num_boost_round=100,
)

preds = model.predict(dtest_reg)
#accuracy = model.score(X_test, y_test)


import matplotlib.pyplot as plt
plt.scatter(test.he_b008_high_cholesterol, preds)




import tensorflow as tf
