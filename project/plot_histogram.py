"""plot histogram

Plot the histogram for visual words distribution
"""
import os

import matplotlib.pyplot as plt
import numpy as np

import cPickle as pickle
import collections

import pdb

from sklearn.externals import joblib 

def plot_hist(labels, bins, filename):
    hist, bins = np.histogram(labels, bins=bins)
    width = 0.7 * (bins[1] - bins[0])
    center = (bins[:-1] + bins[1:]) / 2
    plt.bar(center, hist, align='center', width=width)
    plt.savefig(os.path.join('output', 'hist', filename))

def main(featPath, clusters):
    mbk = joblib.load('./models/surf-kmeans_v1.pkl')

    # plot one histogram per category
    last_cat = None
    for root, dirs, files in os.walk(featPath):
        for name in files:
            #print(root, ':', dirs, ':', name)
            if name.startswith('.'):
                print("Ignoring file : ", name)
                continue
            try:
                category = root.split('/')[-1]

                # ignore if this category's hist is already created
                if category == last_cat:
                    break
                last_cat = category
                fpath = os.path.join(root, name)
                print("Processing pickled file... ", fpath)
                feature = pickle.load(open(fpath, 'rb'))
                vlabels = mbk.predict(feature)
                plot_hist(labels=vlabels, bins=clusters, filename=category + '.png')
            except Exception as e:
                print("Error: ", e)
                continue

if __name__ == '__main__':
    main(featPath='./SURF/train/', clusters=3000)