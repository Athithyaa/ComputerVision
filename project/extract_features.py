"""Feature extractor

Extract the SIFT (Scale invarient feature transform) features from a set of given 
image and pickle the SIFT descriptors to the file.
"""
from __future__ import print_function

import cv2
import os
import numpy as np
import cPickle as pickle

import pdb

imgPath = './Images/test/'

siftFolder = './SURF/test/'
min_pt = np.inf

features = np.empty((0, 128))  # 64 for SURF and 128 for SIFT
folder = None

#pdb.set_trace()
# create SIFT feature detector
# sift = cv2.SIFT()

# compute dense SIFT
# dense = cv2.FeatureDetector_create("Dense")


hessianThreshold = 300 # a good value is between 300-500
surf = cv2.SURF(300)
surf.upright = True # don't compute orientation
surf.extended = True    # Extent to get 128-dim descriptors.

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
            # print(img.shape)
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            
            # Compute dense SIFT
            # kp = dense.detect(gray)
            # kp, desc = sift.compute(gray, kp)

            kp, desc = surf.detectAndCompute(gray, None)
            # print("len=", len(desc[0]))

            features = np.vstack((features, desc))
            with open(os.path.join(siftDir, name + '.p'), 'wb') as dumpFile:
                    pickle.dump(features, dumpFile)
            
            features = np.empty((0, 128))
            folder = currFolder
        except Exception as e:
            print("Error : ", e)
            continue