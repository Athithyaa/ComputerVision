#clone the googLeNet inception v3 model
git clone -b r0.11 https://github.com/tensorflow/tensorflow.git

# https://research.googleblog.com/2016/03/train-your-own-image-classifier-with.html
# retrain the inception model with our dataset.
python tensorflow/tensorflow/examples/image_retraining/retrain.py \
--bottleneck_dir=./bottleneck/ \
--how_many_training_steps 500 \
--model_dir=./inception/ \
--output_graph=./bottleneck/graph.pb \
--output_labels=labels.txt \
--image_dir=../Images/train/

# generate tensorboard log from the retrained model
python create_tb_log.py

# run the tensorboard 
tensorboard --logdir /tmp/inception_v3_log

# Navigate to the url: http://0.0.0.0:6006/#graphs