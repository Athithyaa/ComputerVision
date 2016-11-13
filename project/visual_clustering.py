"""Visual word clustering

Given a set of visual words (SIFT descriptor points of 128 dimension), cluster 
them using K-means. MiniBatchKmeans is much faster than regular kmeans in scikit learn.
"""
from __future__ import print_function

import cv2
import cPickle as pickle
import collections

import os
import numpy as np
import pdb

from math import sqrt

from sklearn.externals import joblib
from sklearn.svm import SVC
from sklearn.cluster import MiniBatchKMeans, KMeans
from sklearn.naive_bayes import GaussianNB
from sklearn.lda import LDA
from sklearn import mixture
from sklearn import decomposition

import warnings

clusters = 1000
features = np.empty((0, 128))
siftPath = './SURF/train/'
# pdb.set_trace()

imgCount = 0

for root, dirs, files in os.walk(siftPath):
    readCount = 0
    for name in files:
        #print(root, ':', dirs, ':', name)
        if name.startswith('.'):
            print("Ignoring file : ", name)
            continue
        try:
            imgCount += 1
            fpath = os.path.join(root, name)
            print("Processing pickled file... ", fpath)
            feature = pickle.load(open(fpath, 'rb'))
            features = np.vstack((features, feature))
        except Exception as e:
            print("error: ", e)
            continue

# clusters = int(sqrt(len(features)))
print("Image count = ", imgCount, "Number of datapoints = ", len(features), "clusters = ", clusters)

# kmeans
# kmeans = KMeans(n_clusters=clusters)
# clf = kmeans.fit(features)

#clf = joblib.load('kmeans_v1.pkl') 

# mini batch kmeans is faster
mbk = MiniBatchKMeans(init='k-means++', n_clusters=clusters, batch_size=10000, max_no_improvement=200, verbose=True)
with warnings.catch_warnings():
    warnings.simplefilter("ignore", category=DeprecationWarning)
    mbk.fit(features)

# pdb.set_trace()
# pca = decomposition.PCA(n_components=3)
# pca.fit(features)
# features = pca.transform(features)
# gmm = mixture.GMM(n_components=clusters, verbose=True)
# gmm.fit(features)

# release the memory for feature points after model is predicted
del features


# dump the model
joblib.dump(mbk, './models/surf-kmeans_v1.pkl')