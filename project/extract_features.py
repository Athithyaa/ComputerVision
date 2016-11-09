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

            fpath = os.path.join(root, name)
            print('Processing file ...', fpath)
            img = cv2.imread(fpath)
            print(img.shape)
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

            kp, desc = sift.detectAndCompute(gray, None)
            
            if currFolder != folder:
                with open(os.path.join(siftFolder, folder + '.p', 'wb')) as dumpFile:
                    pickle.dump(features, dumpFile)
                features = np.empty((0, 128))
                folder = currFolder

            features = np.vstack((features, desc))

            print('-------')
        except Exception as e:
            continue
