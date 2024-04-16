import os
import pandas as pd
import numpy as np

from sklearn.ensemble import RandomForestClassifier as RFC
from sklearn.metrics import confusion_matrix
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import KFold
from sklearn.metrics import f1_score



def eval_cm(predictions):
    TP = predictions[1,1]
    TN = predictions[0,0]
    FP = predictions[0,1]
    FN = predictions[1,0]
    sens = TP/(TP + FN)
    spec = TN/(TN + FP)
    acc = (TP + TN)/(TP + TN + FP + FN)
    return np.array([sens, spec, acc])[:,None]


os.chdir("/Users/dawr2/Desktop/Ranadeep_Daw_Projects/pegs")

#train = pd.read_csv("output/chol_train.csv")
#test  = pd.read_csv("output/chol_test.csv")
chol = pd.read_csv("output/chol_full.csv")

features = [x for x in chol.columns if x not in ['epr_number', 'he_b008_high_cholesterol', 'gender', 'he_s179_100_cigarettes_PARQ'] ]

k = 10
kf_10 = KFold(n_splits = k, random_state = 24, shuffle=True)
rf = RFC(n_estimators=3000, random_state=42,
         max_depth=8, n_jobs=-1,
         class_weight="balanced_subsample")

rfc_list = np.zeros((3,0))
IMP = np.zeros((len(features), k))

iii = 0
for train_index, test_index in kf_10.split(chol):
    print(iii)
    train, test = chol.iloc[train_index, :], chol.iloc[test_index, :]
    rf.fit(train[features], train.he_b008_high_cholesterol)
    y_pred = rf.predict(test[features])
    y_test = test.he_b008_high_cholesterol
    rfc_this = eval_cm(confusion_matrix(y_test, y_pred))
    rfc_list = np.concatenate((rfc_list, rfc_this), 1)
    IMP[:, iii] = rf.feature_importances_
    iii = iii+1




# List of tuples with variable and importance
feature_importances = [(feature, round(importance, 5)) for feature, importance in zip(features, IMP.mean(1))]

# Sort the feature importances by most important first
feature_importances = sorted(feature_importances, key = lambda x: x[1], reverse = True)

# Print out the feature and importances 
[print('Variable: {:20} Importance: {}'.format(*pair)) for pair in feature_importances];



idx2 = np.where(IMP.mean(1) > 0)[0]
features2 = list(np.array(features)[idx2])
#rf.fit(train[features2], train.he_b008_high_cholesterol)
#np.corrcoef(train.he_b008_high_cholesterol == "Yes", train.he_bmi_derived)
#np.corrcoef(train.he_b008_high_cholesterol == "Yes", train.he_s192_sleep_hours)
#np.corrcoef(train.he_b008_high_cholesterol == "Yes", train.cigarette_cat)
#np.corrcoef(train.he_b008_high_cholesterol == "Yes", train.gender_cat)



rfc_list2 = np.zeros((3,0))
IMP2 = np.zeros((len(features2), k))

iii = 0
for train_index, test_index in kf_10.split(chol):
    print(iii)
    train, test = chol.iloc[train_index, :], chol.iloc[test_index, :]
    rf.fit(train[features2], train.he_b008_high_cholesterol)
    y_pred = rf.predict(test[features2])
    y_test = test.he_b008_high_cholesterol
    rfc_this = eval_cm(confusion_matrix(y_test, y_pred))
    rfc_list2 = np.concatenate((rfc_list, rfc_this), 1)
    IMP2[:, iii] = rf.feature_importances_
    iii = iii+1







# List of tuples with variable and importance
feature_importances2 = [(feature, round(importance, 5)) for feature, importance in zip(features2, IMP2.mean(1))]

# Sort the feature importances by most important first
feature_importances2 = sorted(feature_importances2, key = lambda x: x[1], reverse = True)

# Print out the feature and importances 
[print('Variable: {:20} Importance: {}'.format(*pair)) for pair in feature_importances2];





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


