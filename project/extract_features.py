"""Feature extractor

Extract the SIFT (Scale invarient feature transform) features from a set of given 
image and pickle the SIFT descriptors to the file.
"""

import cv2
import os
import numpy as np
import cPickle as pickle

import pdb

imgPath = './Images/'

siftFolder = './SIFT/'
min_pt = np.inf

features = np.empty((0, 128))
folder = None

#pdb.set_trace()
sift = cv2.SIFT()

for root, dirs, files in os.walk(imgPath):
    for name in files:
        #print(root, ':', dirs, ':', name)
        if name.startswith('.'):
            print('ignoring file : ', name)
            continue
        try:
            currFolder = root.split('/')[-1]
            if not folder:
                folder = currFolder;

            siftDir = os.path.join(siftFolder, currFolder);
            if not os.path.exists(siftDir):
                os.makedirs(siftDir)

            fpath = os.path.join(root, name)
            print('Processing image file ...', fpath)
            img = cv2.imread(fpath)
            print(img.shape)
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

            kp, desc = sift.detectAndCompute(gray, None)
            
            features = np.vstack((features, desc))
            with open(os.path.join(siftDir, name + '.p'), 'wb') as dumpFile:
                    pickle.dump(features, dumpFile)
            
            features = np.empty((0, 128))
            folder = currFolder

            print('-------')
        except Exception as e:
            continue