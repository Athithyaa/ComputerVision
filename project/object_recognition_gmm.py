""" Object recognition 

Given a array of SIFT features, run clustering and extract the cluster label
and then construct a visual word distribution for the image and classify it using 
supervised learning model. 
"""
from __future__ import print_function

import cv2
import cPickle as pickle
import collections

import os
import numpy as np
import pdb

from sklearn.externals import joblib
from sklearn import svm
from sklearn.ensemble import RandomForestClassifier
from sklearn.cluster import MiniBatchKMeans, KMeans
from sklearn.naive_bayes import GaussianNB
from sklearn.multiclass import OneVsRestClassifier
# from sklearn.neural_network import MLPClassifier


clusters = 3000
features = np.empty((0, 128))
siftPath = './SURF/train/'

# find distribution of visual words over the labels 
# and then feed it to the classifier.
wordDist = np.empty((0, clusters))
categories = []

gmm = joblib.load('./models/gmm_v1.pkl')

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
            print("Processing pickled file... ", fpath)
            feature = pickle.load(open(fpath, 'rb'))
            counter = []

            for i in range(0, clusters):
                scores = gmm[i].score_samples(feature)
                filt_scores = filter(lambda ele: ele if ele > 0 else 0, scores)
                counter.append(sum(filt_scores))

            dist = np.float64([counter[i] for i in range(0, clusters)])
            # normalize visual word distribution histogram so that 
            # image size doesn't effect bag of words model. 
            ndist = (dist - min(dist))/(max(dist)-min(dist))
            wordDist = np.vstack((wordDist, dist))
            categories.append(category)
        except Exception as e:
            print("Error: ", e)
            continue

# pdb.set_trace()
# clf = svm.SVC()
clf = svm.SVC(kernel='linear', verbose=True)    # linear svm kernel gives 56% accuracy
# clf = svm.LinearSVC(verbose=True)
# clf = OneVsRestClassifier(svm.SVC(kernel='linear', verbose=True))
#clf = RandomForestClassifier(n_estimators=25)
model = clf.fit(wordDist, categories)
del wordDist, categories

joblib.dump(clf, './models/surf-svm_v1.pkl')

# Neural net MLP classifier is not available in scikit learn - 0.17 yet
# It's available in 0.18-dev version, but it's unstable.
# clf = MLPClassifier(solver='lbfgs', alpha=1e-5, hidden_layer_sizes=(256, 256))
# joblib.dump(clf, './models/mlpclassifier_v1.pkl')