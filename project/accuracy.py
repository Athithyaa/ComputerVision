"""Accuracy of the scene detection

Find the accuracy of a particular model for scene detection
"""
from __future__ import print_function

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

import itertools
import matplotlib.pyplot as plt

from sklearn.metrics import confusion_matrix


clusters = 1000
siftPath = './SURF/test/'

# find distribution of visual words over the labels 
# and then feed it to the classifier.
wordDist = np.empty((0, clusters))
categories = []

mbk = joblib.load('./models/surf-kmeans_v1.pkl') 
clf = joblib.load('./models/surf-svm_v1.pkl')

total = float()
correct = float()

trueLabels = []
predictLabels = []

# test the accuracy of the model
for root, dirs, files in os.walk(siftPath):
    for name in files:
        #print(root, ':', dirs, ':', name)
        if name.startswith('.'):
            print("Ignoring file : ", name)
            continue
        try:
            total += 1
            category = root.split('/')[-1].lower()
            trueLabels.append(category)
            fpath = os.path.join(root, name)
            print("Processing pickled file... ", fpath)
            feature = pickle.load(open(fpath, 'rb'))
            vlabels = mbk.predict(feature)
            counter = collections.Counter(vlabels)
            dist = np.float64([counter[i] for i in range(0, clusters)])

            # normalize visual word distribution histogram so that 
            # image size doesn't effect bag of words model. 
            ndist = (dist-min(dist))/(max(dist)-min(dist))

            cat = clf.predict(ndist)[0].lower()
            predictLabels.append(cat)

            if cat == category:
                correct += 1
            print("Actual: ", category, " Prediction: ", cat, "Running accuracy = ", correct/total)
        except Exception as e:
            print("Error: ", e)
            continue

print("correct: ", correct, "Total: ", total)
print("Accuracy : ", correct/total)

cnf_matrix = confusion_matrix(trueLabels, predictLabels)
class_names = list(set(trueLabels))

with open('cnf_mat.pkl', 'wb') as out:
    pickle.dump(cnf_matrix, out)

with open('classes.pkl', 'wb') as out:
    pickle.dump(class_names, out)