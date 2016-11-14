"""scene classifier

Load the inception model retained with our dataset using tensorflow.
And feed in the test images for testing the accuracy of ConvNets(CNN).
"""
from __future__ import print_function

import tensorflow as tf
import sys

import cPickle as pickle
import collections

import os
import numpy as np
import pdb

from sklearn.metrics import confusion_matrix

imgDir = '../Images/test/'

# change this as you see fit
# image_path = imgDir

# Read in the image_data
# image_data = tf.gfile.FastGFile(image_path, 'rb').read()

# Loads label file, strips off carriage return
label_lines = [line.rstrip() for line 
                   in tf.gfile.GFile("labels.txt")]

# Unpersists graph from file
with tf.gfile.FastGFile("bottleneck/graph.pb", 'rb') as f:
    graph_def = tf.GraphDef()
    graph_def.ParseFromString(f.read())
    _ = tf.import_graph_def(graph_def, name='')

total = float()
correct = float()

trueLabels = []
predictLabels = []

with tf.Session() as sess:
    for root, dirs, files in os.walk(imgDir):
        for name in files:
            #print(root, ':', dirs, ':', name)
            if name.startswith('.'):
                print('ignoring file : ', name)
                continue
            try:
                total += 1
                category = root.split('/')[-1].lower()
                trueLabels.append(category)
                fpath = os.path.join(root, name)
                print("Processing pickled file... ", fpath)

                image_data = tf.gfile.FastGFile(fpath, 'rb').read()
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
                # for node_id in top_k:
                #     human_string = label_lines[node_id]
                #     score = predictions[0][node_id]
                #     print('%s (score = %.5f)' % (human_string, score))
                predictLabels.append(cat)
                if cat == category:
                    correct += 1
                print("Actual: ", category, " Prediction: ", cat, "Running accuracy = ", correct/total)
            except Exception as e:
                print("Error: ", e)
                continue

print("correct: ", correct, "Total: ", total)
print("Accuracy : ", correct/total)

# pdb.set_trace()

cnf_matrix = confusion_matrix(trueLabels, predictLabels)
class_names = list(set(trueLabels))

with open('../cnf_mat.pkl', 'wb') as out:
    pickle.dump(cnf_matrix, out)

with open('../classes.pkl', 'wb') as out:
    pickle.dump(class_names, out)