"""scene classifier
Load the inception model retained with our dataset using tensorflow.
And feed in the test images for testing the accuracy of ConvNets(CNN).
"""
from __future__ import print_function

import tensorflow as tf
import sys

import collections

import os
import numpy as np

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
