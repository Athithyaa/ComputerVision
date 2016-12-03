"""scene classifier

Load the inception model retained with our dataset using tensorflow.
And feed in the test images for testing the accuracy of ConvNets(CNN).
"""


from __future__ import print_function
import tensorflow as tf
from sklearn.externals import joblib
import cPickle as pickle
import cv2
import sys

import collections

import os
import numpy as np

mbk = joblib.load('../models/surf-kmeans_v1.pkl')
clf_1 = joblib.load('../models/surf-svm_v1.pkl')
gmm = joblib.load('../models/gmm_v1.pkl')
clf_2 = joblib.load('../models/surf-svm_v1.pkl')

def classify(image_path):
    if not os.path.exists(image_path):
        print("File doesn't exists!", image_path)
        return "Error in running tensorflow"
    # Read in the image_data
    image_data = tf.gfile.FastGFile(image_path, 'rb').read()

    # Loads label file, strips off carriage return
    label_lines = [line.rstrip() for line 
                       in tf.gfile.GFile("recognition/labels.txt")]

    # Unpersists graph from file
    with tf.gfile.FastGFile("recognition/bottleneck/graph.pb", 'rb') as f:
        graph_def = tf.GraphDef()
        graph_def.ParseFromString(f.read())
        _ = tf.import_graph_def(graph_def, name='')

    with tf.Session() as sess:
        # Feed the image_data as input to the graph and get first prediction
        softmax_tensor = sess.graph.get_tensor_by_name('final_result:0')
        
        predictions = sess.run(softmax_tensor, \
                 {'DecodeJpeg/contents:0': image_data})
        
        # Sort to show labels of first prediction in order of confidence
        top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]
        
        node_id = top_k[0]
        score = predictions[0][node_id]
        cat = label_lines[node_id].lower()
        print('%s [confidence=%.5f]' %(cat, score))

        return cat + ' (score=' + str(score) + ")"


def classify_bow(fpath):
    clusters = 3000
    surf = cv2.SURF(300)
    img = cv2.imread(fpath)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    kp, desc = surf.detectAndCompute(gray, None)
    vlabels = mbk.predict(desc)
    counter = collections.Counter(vlabels)
    dist = np.float64([counter[i] for i in range(0, clusters)])
    ndist = (dist-min(dist))/(max(dist)-min(dist))
    cat = clf_1.predict(ndist)[0].lower()
    return cat


def classify_bow_gmm(fpath):
    clusters = 3000
    surf = cv2.SURF(300)
    img = cv2.imread(fpath)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    kp, desc = surf.detectAndCompute(gray, None)
    counter = []
    for i in range(0, clusters):
        scores = gmm[i].score_samples(desc)
        counter.append(sum(scores))
    dist = np.float64([counter[i] for i in range(0, clusters)])
    ndist = (dist-min(dist))/(max(dist)-min(dist))
    cat = clf_2.predict(ndist)[0].lower()
    return cat

