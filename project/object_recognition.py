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
from sklearn.neural_network import MLPClassifier


clusters = 100
features = np.empty((0, 128))
siftPath = './SIFT/'

# find distribution of visual words over the labels 
# and then feed it to the classifier.
wordDist = np.empty((0, clusters))
categories = []

mbk = joblib.load('./models/kmeans_v1.pkl') 

for root, dirs, files in os.walk(siftPath):
    readCount = 0
    for name in files:
        #print(root, ':', dirs, ':', name)
        if name.startswith('.'):
            print("Ignoring file : ", name)
            continue
        try:
            category = root.split('/')[-1]
            fpath = os.path.join(root, name)
            print("Processing pickled file => ", fpath)
            feature = pickle.load(open(fpath, 'rb'))
            vlabels = mbk.predict(feature)
            counter = collections.Counter(vlabels)
            dist = [counter[i] for i in range(0, clusters)]
            wordDist = np.vstack((wordDist, dist))
            categories.append(category)
            print("-------")

            # read first n files in each folder
            readCount += 1
            if readCount == 100:
                break
        except Exception as e:
            print("Error: ", e)
            continue

# pdb.set_trace()

clf = RandomForestClassifier(n_estimators=25)
model = clf.fit(wordDist, categories)
joblib.dump(clf, './models/randomForest_v1.pkl')

# Neural net MLP classifier is not available in scikit learn - 0.17 yet
# It's available in 0.18-dev version, but it's unstable.
# clf = MLPClassifier(solver='lbfgs', alpha=1e-5, hidden_layer_sizes=(256, 256))
# joblib.dump(clf, './models/mlpclassifier_v1.pkl')

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

print("Accuracy : ", float(correct/total))
# # testing
# ff = pickle.load(open('./SIFT/artstudio/art_painting_studio_25_03_altavista.jpg.p', 'rb'))
# ff = pickle.load(open('./SIFT/airport_inside/airport_inside_0605.jpg.p', 'rb'))
# ll = mbk.predict(ff)
# vv = collections.Counter(ll)
# dist = [vv[i] for i in range(0, 100)]
# clf.predict(dist)