# TensorFlow "A new hope" Demo application

First, pull a version of the NGC container you would like to use. I have used the app with TensorFlow 1.15 and 20.01 build:

sudo docker run --gpus all --shm-size=1g  --ulimit memlock=-1 --ulimit stack=67108864 -it -p 8888:8888 -v /home/[USER]/data/mnist:/data/mnist nvcr.io/nvidia/tensorflow:20.01-tf1-py3

Now, import the requests module from within the NGC container:
pip install requests

Now, clone the repo:
git clone https://github.com/vhojan/A-New-Hope.git

After cloning the git repo, run the following command to start the app:

python A-New-Hope/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --data_format=NCHW --batch_size=64 --model=resnet50 --variable_update=replicated --local_parameter_device=gpu --num_batches=100 --nodistortions

Some comments:
- Increasing --num_batches will also increase the duration of the benchmark. The current value of 100 is purely there to shorten the run time. For the actualy demo, I would recommend a value of 10000.
