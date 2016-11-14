import lasagne
import theano
import theano.tensor as T
import numpy as np
import cv2
import os

from lasagne.nonlinearities import leaky_rectify, softmax


def batch_gen(X, y, N):
    while True:
        idx = np.random.choice(len(y), N)
        yield X[idx].astype('float32'), y[idx].astype('int32')


X_sym = T.matrix()
y_sym = T.ivector()

network = lasagne.layers.InputLayer((None, 3 * 256 * 256))
network = lasagne.layers.ReshapeLayer(network, (-1, 3, 256, 256))
network = lasagne.layers.Conv2DLayer(network, num_filters=3, filter_size=3, pad=1)
l_out = lasagne.layers.DenseLayer(network, num_units=15, nonlinearity=lasagne.nonlinearities.softmax)
output = lasagne.layers.get_output(l_out, X_sym)
pred = output.argmax(-1)
loss = T.mean(lasagne.objectives.categorical_crossentropy(output, y_sym))
acc = T.mean(T.eq(pred, y_sym))
params = lasagne.layers.get_all_params(l_out)
grad = T.grad(loss, params)
updates = lasagne.updates.adam(grad, params, learning_rate=0.005)
f_train = theano.function([X_sym, y_sym], [loss, acc], updates=updates)
f_val = theano.function([X_sym, y_sym], [loss, acc])
f_predict = theano.function([X_sym], pred)
imgPath = './Resize/train/'

X = []
y = []
label_dict = dict(bedroom=0, Coast=1, Forest=2, Highway=3, industrial=4, Insidecity=5, kitchen=6, livingroom=7,
                  Mountain=8, Office=9, OpenCountry=10, store=11, Street=12, Suburb=13, TallBuilding=14)

for root, dirs, files in os.walk(imgPath):
    for name in files:
        if name.startswith('.'):
            print('ignoring file : ', name)
            continue
        try:
            fpath = os.path.join(root, name)
            split_root = root.split("/")
            imgData = cv2.imread(fpath)
            imgData = imgData.reshape(1, 3 * 256 * 256).astype('float32')
            print('Shape of imgData ...', imgData.shape)
            X.append(imgData[0])
            y.append(label_dict[split_root[3]])

        except Exception as e:
            print("Error : ", e)
            continue

train_batch = batch_gen(np.array(X), np.array(y), 100)

for epoch in range(10):
    loss = 0
    X_train, y_train = next(train_batch)
    loss = f_train(X_train, y_train)
    print loss
