import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import GPy
from sklearn.cluster import KMeans



os.chdir("/ddn/gs1/home/dawr2/water/")
water = pd.read_feather("./input/temp_outputs/water.feather")

np.random.seed(42)
train_idx = np.random.binomial(1, 0.7, water.shape[0])
water_train = water.loc[train_idx==1]
water_test  = water.loc[train_idx==0]


kmeans1 = KMeans(n_clusters=100, n_init="auto").fit(water_train[["Lon", "Lat"]])
cl1 = kmeans1.predict(water_train[["Lon", "Lat"]])

kmeans2 = KMeans(n_clusters=200, n_init="auto").fit(water_train[["Lon", "Lat"]])
cl2 = kmeans2.predict(water_train[["Lon", "Lat"]])

kmeans3 = KMeans(n_clusters=300, n_init="auto").fit(water_train[["Lon", "Lat"]])
cl3 = kmeans3.predict(water_train[["Lon", "Lat"]])

kmeans4 = KMeans(n_clusters=400, n_init="auto").fit(water_train[["Lon", "Lat"]])
cl4 = kmeans4.predict(water_train[["Lon", "Lat"]])

kmeans5 = KMeans(n_clusters=500, n_init="auto").fit(water_train[["Lon", "Lat"]])
cl5 = kmeans5.predict(water_train[["Lon", "Lat"]])



plt.scatter(water_train.loc[cl1 <= 10, "Lon"], 
            water_train.loc[cl1 <= 10, "Lat"],
            c=cl1[cl1 <= 10])
plt.savefig("output/clusters_500.pdf")
plt.close()

plt.scatter(water_train.loc[cl1 == 1, "Lon"],
            water_train.loc[cl1 == 1, "Lat"],
            c=water_train.loc[cl1 == 1, "Temperature"],
            s=0.5)
plt.colorbar()
plt.savefig("output/temperatures.pdf")
plt.close()



np.save("input/temp_outputs/cl1.npy", cl1)
np.save("input/temp_outputs/cl2.npy", cl2)
np.save("input/temp_outputs/cl3.npy", cl3)
np.save("input/temp_outputs/cl4.npy", cl4)
np.save("input/temp_outputs/cl5.npy", cl5)
np.save("input/temp_outputs/train_idx.npy", train_idx)



