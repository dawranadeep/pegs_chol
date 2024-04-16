import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import GPy
from sklearn.cluster import KMeans
import multiprocessing as mp



np.random.seed(42)
os.chdir("/ddn/gs1/home/dawr2/water/")
water = pd.read_feather("./input/temp_outputs/water.feather")
cl1 = np.load("input/temp_outputs/cl1.npy")
cl2 = np.load("input/temp_outputs/cl2.npy")
cl3 = np.load("input/temp_outputs/cl3.npy")
cl4 = np.load("input/temp_outputs/cl4.npy")
cl5 = np.load("input/temp_outputs/cl5.npy")
train_idx = np.load("input/temp_outputs/train_idx.npy")


water = np.array(water)


def fit_cl_GP_1(cl_idx):
    water_train = water[train_idx==1, :]
    water_test  = water[train_idx==0, :]
    sub_idx = np.random.choice(np.where(cl1 == cl_idx)[0], 100)
    #k = GPy.kern.RBF(input_dim=2)
    m = GPy.models.SparseGPRegression(
        X = water_train[cl1 == cl_idx, 0:2],
        Y = water_train[cl1 == cl_idx, 2:3],
        num_inducing=100)
    m.optimize("bfgs")
    #m.plot()
    Yhat_train = m.predict(np.array(water_train[:, 0:2]))[0]
    Yhat_test  = m.predict(np.array( water_test[:, 0:2]))[0]
    return Yhat_train, Yhat_test


Yhat_train, Yhat_test = fit_cl_GP_1(1)



with mp.Pool(10) as pool:
    res = pool.map(fit_cl_GP_1, range(4))


#idx = np.random.choice(water.shape[0], 10000)
idx = cl1 <= 3
vm = np.min([np.min(Yhat[0][idx]), np.min(water.loc[idx, "Temperature"])])
vM = np.max([np.max(Yhat[0][idx]), np.max(water.loc[idx, "Temperature"])])


fig, ax = plt.subplots(nrows=1, ncols=2)
im = ax[0].scatter(water.loc[idx, "Lon"], water.loc[idx, "Lat"], s=0.1, c=water.loc[idx, "Temperature"], vmin=vm, vmax=vM)
im = ax[1].scatter(water.loc[idx, "Lon"], water.loc[idx, "Lat"], s=0.1, c=Yhat[0][idx], vmin=vm, vmax=vM)
fig.subplots_adjust(right=0.8)
cbar_ax = fig.add_axes([0.85, 0.15, 0.05, 0.7])
fig.colorbar(im, cax=cbar_ax)
plt.show()

