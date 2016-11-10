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

# find distribution of visual words over the labels 
# and then feed it to the classifier.
wordDist = np.empty((0, clusters))
categories = []

mbk = joblib.load('kmeans_v1.pkl') 

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

pdb.set_trace()

clf = GaussianNB()
model = clf.fit(wordDist, categories)

joblib.dump(clf, 'gnb_v1.pkl')

pp = pickle.load(open('./SIFT/airport_inside/airport_inside_0605.jpg.p', 'rb'))