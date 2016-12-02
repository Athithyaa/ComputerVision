## Image clasification using residual neural networks

* Install caffe dependencies for python
* git clone the caffe repository
* Make a copy of Makefile and edit values like change path of python_lib, python_includes
* Make all, make test, make runtest, make pycaffe and make distribution

## Train the model
* Run ResNet_Generator.py to create the deep neural net architecture. You can configure number of layers
```sh
$ python ResNet_Generator.py solver.prototxt train_val.prototxt
```

*  Create a train.txt and test.txt files, that contain the data in the following manner: 
```
/path/to/folder/image1.jpg 0
/path/to/folder/image2.jpg 3
/path/to/folder/image3.jpg 1
/path/to/folder/image4.jpg 2
/path/to/folder/image5.jpg 1
...
...
/path/to/folder/imageN.jpg N-1
```

* Convert the images into lmdb format as,
```sh
$ GLOG_logtostderr=1 /path/to/caffe/build/tools/convert_imageset --resize_height=256 --resize_width=256 --shuffle / /path/to/train.txt /path/to/train_lmdb

```

* Once the lmdb format is available, we can compute the mean of the images as, 
```sh
$ /path/to/caffe/build/tools/compute_image_mean /path/to/train_lmdb /path/to/mean_image.binaryproto
```

* Modify the train_val.prototxt file to refer to mean_image.binaryproto. Now train the model as,
```sh
$ /full/path/to/caffe/build/tools/caffe train --solver /full/path/to/my_solver.prototxt
```

### Credits:
** ResNet_Generator.py:** Generate the residule learning network. We used this file to build the neural network architecture, rather than trying to code it by hand.

Author: Yemin Shi
Email: shiyemin@pku.edu.cn
MSRA Paper: http://arxiv.org/pdf/1512.03385v1.pdf
