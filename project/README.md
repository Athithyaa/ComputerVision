## Scene recoginition

* **Bag of words(BoW)**: Extract the features (keypoints and descriptors) from the image using SIFT or SURF. Each descriptor describes a blob of the image (4x4 pixels). Assume these descriptors are independent and cluster them using KMeans or MiniBatchKMeans(faster than regular kmeans). Construct a visual word histogram for each train images and cluster label, feed this to the support vector machine(SVM with linear kernel) to model the classifier. Normalize the visual word histogram to eliminate the impact of varying image sizes and other parameters. Also SVM performs well when the input is normalized (per scikit learn website). 

|Method | Accuracy |
|-------|----------|
|Bag of Visual words using SIFT(F<sub>0</sub>) | ~39% |
|F<sub>0</sub> + Normalization of histogram  | ~41.2%    |
|Bag of visual words using SURF (descriptors of 64 dimension with orientation)|~44%|
|Bag of visual words using SURF (descriptors of 128 dim without orientation) + Normalization | ~56.3% |

### confusion matrix for BoW with SURF(128 dimensions) with normalization of histogram
![confusion_matrix](https://github.com/Sunhick/ComputerVision/blob/master/project/output/confusion_matrix.png)


* **CNN**: Convolutional neural networks(CNN) can be used to recognize the scene. Not much support is available in scikit learn for deep learning or CNN. We can use tensorflow or TF-flow, a abstraction lirbary on top of tensorflow.
