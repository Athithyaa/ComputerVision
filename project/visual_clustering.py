import cv2
import cPickle as pickle
import collections

import os
import numpy as np
import pdb

from sklearn.externals import joblib
from sklearn.svm import SVC
from sklearn.cluster import MiniBatchKMeans, KMeans
from sklearn.naive_bayes import GaussianNB

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
            print("Ignoring file : ", name)
            continue
        try:
            fpath = os.path.join(root, name)
            print("Processing pickled file ...", fpath)
            feature = pickle.load(open(fpath, 'rb'))
            features = np.vstack((features, feature))
            print("-------")

            # read first n files in each folder
            readCount += 1
            if readCount == 100:
                break
        except Exception as e:
            continue

# kmeans
# kmeans = KMeans(n_clusters=clusters)
# clf = kmeans.fit(features)

#clf = joblib.load('kmeans_v1.pkl') 

# mini batch kmeans is faster
mbk = MiniBatchKMeans(init='k-means++', n_clusters=clusters, batch_size=10000, max_no_improvement=20, verbose=0)
mbk.fit(features)

# release the memory for feature points after model is predicted
del features


# dump the model
joblib.dump(mbk, './models/kmeans_v1.pkl')