import cv2
import cPickle as pickle
import collections

import os
import numpy as np
import pdb

from sklearn.externals import joblib
from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.cluster import MiniBatchKMeans, KMeans
from sklearn.naive_bayes import GaussianNB


clusters = 100
features = np.empty((0, 128))
siftPath = './SIFT/'

# find distribution of visual words over the labels 
# and then feed it to the classifier.
wordDist = np.empty((0, clusters))
categories = []

mbk = joblib.load('kmeans_v1.pkl') 
clf = joblib.load('randomForest_v1.pkl')

total = float()
correct = float()

# test the accuracy of the model
for root, dirs, files in os.walk(siftPath):
    for name in files:
        #print(root, ':', dirs, ':', name)
        if name.startswith('.'):
            print("Ignoring file : ", name)
            continue
        try:
            total += 1
            category = root.split('/')[-1]
            fpath = os.path.join(root, name)
            print("Processing pickled file => ", fpath)
            feature = pickle.load(open(fpath, 'rb'))
            vlabels = mbk.predict(feature)
            counter = collections.Counter(vlabels)
            dist = [counter[i] for i in range(0, clusters)]
            cat = clf.predict(dist)
            if cat == category:
                correct += 1
            print("True: ", category, " Predict: ", cat)
        except Exception as e:
            print("Error: ", e)
            continue

print("correct: ", correct, "Total: ", total)
print("Accuracy : ", correct/total)
print("Adjusted accuracy : ", (correct-200)/(total-200))

