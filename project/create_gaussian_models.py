import os
import numpy as np
from sklearn.externals import joblib
import cPickle as pickle
from sklearn import mixture

siftPath = './SURF/train/'
# pdb.set_trace()
mbk = joblib.load('./models/surf-kmeans_v1.pkl')
mbk.set_params(verbose=False)
features = np.empty((0, 128))

for root, dirs, files in os.walk(siftPath):
    for name in files:
        if name.startswith('.'):
            print("Ignoring file : ", name)
            continue
        try:
            fpath = os.path.join(root, name)
            print("Processing pickled file... ", fpath)
            feature = pickle.load(open(fpath, 'rb'))
            features = np.vstack((features, feature))
        except Exception as e:
            print("error: ", e)
            continue

cluster_points = {}
f_counter = 0
pred_labels = mbk.predict(features)

for p in pred_labels:
    if p in cluster_points:
        pts_list = cluster_points.get(p)
        pts_list.append(features[f_counter])
        cluster_points[p] = pts_list
    else:
        cluster_points[p] = [features[f_counter]]

    f_counter += 1

cluster_gmm = {}

for k in cluster_points.keys():
    cluster_gmm[k] = mixture.GaussianMixture(n_components=5, covariance_type='full', verbose=True).fit(cluster_points[k])

# store model in a pickle file so that we can use it later.
joblib.dump(cluster_gmm, './models/gmm_v1.pkl')






