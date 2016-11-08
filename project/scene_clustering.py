import cv2
import os
import numpy as np
import pdb

from sklearn.svm import SVC

imgPath = './Images/'

min_pt = np.inf

features = np.empty((0, 128*50))
target = []

#pdb.set_trace()

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

            sift = cv2.SIFT()
            kp, desc = sift.detectAndCompute(gray, None)
            
            desc = desc[:50]
            ravel = desc.ravel()
            
            features = np.vstack((features, ravel))
            target.append(root.split('/')[-1])
            
            lpt = len(kp)
            if lpt < min_pt:
                min_pt = lpt
            
            print('lpt: ', lpt, 'min_pt:', min_pt)
            print('-------')
        except Exception as e:
            continue

pdb.set_trace()
target = np.array(target)
clf = SVC()
clf.fit(features, target) 