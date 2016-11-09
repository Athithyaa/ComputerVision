import cv2
import os
import numpy as np
import pdb
import pickle

from sklearn.cluster import KMeans

imgPath = './Images/'

min_pt = np.inf

clusters = 100

features = np.empty((0, 128))

# pdb.set_trace()

# create SIFT feature detector
sift = cv2.SIFT()

for root, dirs, files in os.walk(imgPath):
    for name in files:
        #print(root, ':', dirs, ':', name)
        if name.startswith('.'):
            print('ignoring file : ', name)
            continue
        try:
            fpath = os.path.join(root, name)
            print('reading ...', fpath)
            img = cv2.imread(fpath)
            print(img.shape)
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

            kp, desc = sift.detectAndCompute(gray, None)
            features = np.vstack((features, desc))

            print('-------')
        except Exception as e:
            continue

pickle.dump(features, open("features.p", "wb" ))

pdb.set_trace()
kmeans = KMeans(n_clusters=clusters)
model = kmeans.fit(features)
