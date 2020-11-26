# TensorFlow "A new hope" Demo application

[scripts/tf_cnn_benchmarks](https://github.com/tensorflow/benchmarks/tree/master/scripts/tf_cnn_benchmarks) (no longer maintained): The TensorFlow CNN benchmarks contain TensorFlow 1 benchmarks for several convolutional neural networks.

First, pull a version of the NGC container you would like to use. I have used the app with TensorFlow 1.15 and 20.01 build:

sudo docker run --gpus all --shm-size=1g  --ulimit memlock=-1 --ulimit stack=67108864 -it -p 8888:8888 -v /home/[USER]/data/mnist:/data/mnist nvcr.io/nvidia/tensorflow:20.01-tf1-py3

After cloning the git repo, run the following command from within the container:

python benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --data_format=NCHW --batch_size=64 --model=resnet50 --variable_update=replicated --local_parameter_device=gpu --num_batches=100 --nodistortions
