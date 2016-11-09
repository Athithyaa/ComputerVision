import cv2
import cPickle as pickle
import collections

import os
import numpy as np
import pdb

from sklearn.externals import joblib
from sklearn.svm import SVC
from sklearn.cluster import MiniBatchKMeans, KMeans

clusters = 100
features = np.empty((0, 128))
siftPath = './SIFT/'
# pdb.set_trace()

# create SIFT feature detector
sift = cv2.SIFT()

for root, dirs, files in os.walk(siftPath):
    readCount = 0
    for name in files:
        #print(root, ':', dirs, ':', name)
        if name.startswith('.'):
            print('ignoring file : ', name)
            continue
        try:
            fpath = os.path.join(root, name)
            print('Processing pickled file ...', fpath)
            feature = pickle.load(open(fpath, 'rb'))
            features = np.vstack((features, feature))
            print('-------')

            # read first n files in each folder
            readCount += 1
            if readCount == 100:
                break
        except Exception as e:
            continue

# kmeans
# kmeans = KMeans(n_clusters=clusters)
# clf = kmeans.fit(features)

# # release the memory for feature points after model is predicted
# del features

#clf = joblib.load('kmeans_v1.pkl') 

# mini batch kmeans is faster
mbk = MiniBatchKMeans(init='k-means++', n_clusters=clusters, batch_size=10000, max_no_improvement=20, verbose=0)
clf = mbk.fit(features)

# dump the model
joblib.dump(clf, 'kmeans_v1.pkl')

# find distribution of visual words over the labels 
# and then feed it to the classifier.
wordDist = np.empty((0, clusters))
categories = []

for root, dirs, files in os.walk(siftPath):
    readCount = 0
    for name in files:
        #print(root, ':', dirs, ':', name)
        if name.startswith('.'):
            print('ignoring file : ', name)
            continue
        try:
            category = root.split('/')[-1]
            fpath = os.path.join(root, name)
            print('Processing pickled file ...', fpath)
            feature = pickle.load(open(fpath, 'rb'))
            vlabels = clf.predict(feature)
            count = collections.Counter(vlabels)
            dist = [x[i] for i in range(0, clusters)]
            wordDist = np.vstack((wordDist, dist))
            categories.append(category)
            print('-------')

            # read first n files in each folder
            readCount += 1
            if readCount == 100:
                break
        except Exception as e:
            continue

pdb.set_trace()

clf = SVC()
model = clf.fit(wordDist, categories)
















