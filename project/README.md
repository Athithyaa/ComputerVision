## Computer Vision project

### Scene recoginition:

1. Technique: Extract the features (keypoints and descriptors) from the image using SIFT or SURF. Each descriptor describes a blob of the image (4x4 pixels). Assume these descriptors are independent and cluster them using KMeans or MiniBatchKMeans(faster than regular kmeans). Construct a visual word histogram for each train images and cluster label, feed this to the support vector machine(SVM with linear kernel) to model the classifier. Normalize the visual word histogram to eliminate the impact of varying image sizes and other parameters. Also SVM performs well when the input is normalized (per scikit learn website). 

Method | Accuracy |
-------|----------|
Bag of Visual words using SIFT(F<sub>0</sub>) | ~39% |
F<sub>0</sub> + Normalization   | ~41.2%    |
Bag of visual words using SURF + Normalization | ~56.3% |


