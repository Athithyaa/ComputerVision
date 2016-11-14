## Scene recoginition

* **Bag of words(BoW)**: Extract the features (keypoints and descriptors) from the image using SIFT or SURF. Each descriptor describes a blob of the image (4x4 pixels). Assume these descriptors are independent and cluster them using KMeans or MiniBatchKMeans(faster than regular kmeans). Construct a visual word histogram for each train images and cluster label, feed this to the support vector machine(SVM with linear kernel) to model the classifier. Normalize the visual word histogram to eliminate the impact of varying image sizes and other parameters. Also SVM performs well when the input is normalized (per scikit learn website). 

|Method | Accuracy |
|-------|----------|
|F<sub>0</sub>:Bag of Visual words using SIFT | ~39% |
|F<sub>0</sub> + Normalization of histogram  | ~41.2%    |
|Bag of visual words using SURF (descriptors of 64 dimension with orientation)|~44%|
|F<sub>1</sub>: Bag of visual words using SURF (descriptors of 128 dim without orientation) + Normalization | ~56.3% |
|F<sub>1</sub> + 1000 clusters | ~58% |
|F<sub>1</sub> + 2000 clusters| ~62.8% |
|F<sub>1</sub> + 3000 clusters| ~63.08% |
|ConvNets with inception tensorflow| ~89.4% |

### confusion matrix for BoW with SURF(128 dimensions) with normalization of histogram
* With 400 clusters
![confusion_matrix](https://github.com/Sunhick/ComputerVision/blob/master/project/output/confusion_matrix.png)

* With 1000 clusters
![confusion_matrix_1000](https://github.com/Sunhick/ComputerVision/blob/master/project/output/confusion_matrix_1000.png)

* With 2000 clusters
![confusion_matrix_1000](https://github.com/Sunhick/ComputerVision/blob/master/project/output/confusion_matrix_2000.png)

* **CNN**: Convolutional neural networks(CNN) can be used to recognize the scene. Not much support is available in scikit learn for deep learning or CNN. We can use tensorflow or TF-flow, a abstraction lirbary on top of tensorflow.

* With ConvNets using Tensorflow
![cnn](https://github.com/Sunhick/ComputerVision/blob/master/project/output/cnn_inception.png)
