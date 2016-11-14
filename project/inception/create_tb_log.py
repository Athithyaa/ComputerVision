"""create tb log

Create tensorboard logs out of the inception model
"""
import os
import os.path
import tensorflow as tf
from tensorflow.python.platform import gfile

INCEPTION_LOG_DIR = './inception_v3_log'

if not os.path.exists(INCEPTION_LOG_DIR):
    os.makedirs(INCEPTION_LOG_DIR)
with tf.Session() as sess:
    model_filename = './bottleneck/graph.pb'
    with gfile.FastGFile(model_filename, 'rb') as f:
        graph_def = tf.GraphDef()
        graph_def.ParseFromString(f.read())
        _ = tf.import_graph_def(graph_def, name='')
    writer = tf.train.SummaryWriter(INCEPTION_LOG_DIR, graph_def)
    writer.close()