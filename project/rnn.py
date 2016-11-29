""" Recurrent neural networks

Build an object recognition neural network using Recurrent neuron layers
"""
from __future__ import print_function

import os
import pdb

import tensorflow as tf
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer

imgDir = './Resize/train/'

# Parameters
learning_rate = 0.001
training_iters = 5
batch_size = 1
display_step = 10

# Network Parameters
n_input = 256 # input from image (256*256)
n_steps = 28 # timesteps
n_hidden = 128 # hidden layer num of features
n_classes = 10 # 10 image categories

# tf Graph input
x = tf.placeholder("float", [None, n_steps, n_input])
istate = tf.placeholder("float", [None, 2*n_hidden]) #state & cell => 2x n_hidden
y = tf.placeholder("float", [None, n_classes])

# Define weights
weights = {
    'hidden': tf.Variable(tf.random_normal([n_input, n_hidden])), # Hidden layer weights
    'out': tf.Variable(tf.random_normal([n_hidden, n_classes]))
}
biases = {
    'hidden': tf.Variable(tf.random_normal([n_hidden])),
    'out': tf.Variable(tf.random_normal([n_classes]))
}

def RNN(_X, _istate, _weights, _biases):
    # input shape: (batch_size, n_steps, n_input)
    _X = tf.transpose(_X, [1, 0, 2])  # permute n_steps and batch_size
    # Reshape to prepare input to hidden activation
    _X = tf.reshape(_X, [-1, n_input]) # (n_steps*batch_size, n_input)
    # Linear activation
    _X = tf.matmul(_X, _weights['hidden']) + _biases['hidden']
    # Define a lstm cell with tensorflow
    lstm_cell = tf.nn.rnn_cell.BasicLSTMCell(n_hidden, forget_bias=1.0, state_is_tuple=False)
    # Split data because rnn cell needs a list of inputs for the RNN inner loop
    _X = tf.split(0, n_steps, _X) # n_steps * (batch_size, n_hidden)
    # Get lstm cell output
    outputs, states = tf.nn.rnn(lstm_cell, _X, initial_state=_istate)
    # Linear activation
    # Get inner loop last output
    return tf.matmul(outputs[-1], _weights['out']) + _biases['out']

pred = RNN(x, istate, weights, biases)

# Define loss and optimizer
cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(pred, y)) # Softmax loss
optimizer = tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(cost) # Adam Optimizer

# Evaluate model
correct_pred = tf.equal(tf.argmax(pred,1), tf.argmax(y,1))
accuracy = tf.reduce_mean(tf.cast(correct_pred, tf.float32))

# Initializing the variables
init = tf.initialize_all_variables()

vocab = ['bedroom', 'highway', 'kitchen', 'office', 'street', 'coast', 'industrial', \
        'livingRoom', 'opencountry', 'suburb', 'forest', 'insidecity', 'mountain', 'store', 'tallbuilding']

vect = CountVectorizer()
vect.fit(vocab)

# Launch the graph
with tf.Session() as sess:
    sess.run(init)
    step = 1
    for root, dirs, files in os.walk(imgDir):
        for name in files:
            if name.startswith('.'):
                print('ignoring file : ', name)
                continue
            try:
                category = root.split('/')[-1].lower()
                image_label = vect.transform([category]).toarray()[0]

                fpath = os.path.join(root, name)
                print('Processing image file ...', fpath)
                pdb.set_trace()
                image_data = tf.gfile.FastGFile(fpath, 'rb').read()

                sess.run(optimizer, feed_dict={x: image_data, y: image_label, istate: np.zeros((batch_size, 2*n_hidden))})
                
                # Calculate batch accuracy
                acc = sess.run(accuracy, feed_dict={x: image_data, y: image_label, istate: np.zeros((batch_size, 2*n_hidden))})
                
                # Calculate batch loss
                loss = sess.run(cost, feed_dict={x: image_data, y: image_label, istate: np.zeros((batch_size, 2*n_hidden))})
                print("Iter " + str(step*batch_size) + ", Minibatch Loss= " + "{:.6f}".format(loss) + \
                    ", Training Accuracy= " + "{:.5f}".format(acc))
            except Exception as e:
                print("Error: ", e)
                continue