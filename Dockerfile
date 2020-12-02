#------------------------------------------------------------------------------------
# IMPORTANT:
# We are adding dlbs code to make use of the benchmark scripts that is
# available with dlbs
# Have adapted tensorflow benchmark code to run under dlbs benchmark scripts
# This example Dockerfile illustrates a method to install
# additional packages on top of NVIDIA's tensorflow container image. #
# To use this Dockerfile, use the `docker build` command.
# See https://docs.docker.com/engine/reference/builder/
# for more information. 
#------------------------------------------------------------------------------------
FROM nvcr.io/nvidia/tensorflow:20.01-tf1-py3
ENV DASHBOARD_FQDN=""
ENV BATCHES=""
# Copy bitfusion client related files 
#------------------------------------------------------------------------------------ 
# Copy bitfusion files
#RUN mkdir -p /root/.bitfusion
#COPY ./bitfusion-files/client.yaml /root/.bitfusion/client.yaml
#COPY ./bitfusion-files/servers.conf /etc/bitfusion/servers.conf
#RUN mkdir -p /etc/bitfusion/tls
#COPY ./bitfusion-files/ca.crt /etc/bitfusion/tls/ca.crt
#COPY ./bitfusion-files/nvidia-smi /workspace/bitfusion/batch-scripts/nvidia-smi 
#------------------------------------------------------------------------------------ 
# Update package list
# Install Bitfusion. Use deb file for Ubuntu16.04
# Install open-vm-tools 
#------------------------------------------------------------------------------------ 
# Set initial working directory
#RUN mkdir -p /workspace/bitfusion/batch-scripts
#WORKDIR /workspace/bitfusion
# Copy Release version of bitfusion client
#COPY ./bitfusion-files/bitfusion-client-ubuntu1604_2.0.0v12nstaging-876_amd64.deb . RUN apt-get update \
#    && apt-get install -y ./bitfusion-client-ubuntu1604_2.0.0v12nstaging- 876_amd64.deb \
#    && apt-get install -y open-vm-tools \ && \
#    rm -rf /var/lib/apt/lists/
#------------------------------------------------------------------------------------ 
# This is for DLB cookbook - experimenter.py needs python 2.7
# So installing it too 
#------------------------------------------------------------------------------------  
RUN pip install requests
#------------------------------------------------------------------------------------
# Copy dlbs dir
# Then copy latest tensorflow benchmark code - otherwise we get errors like:
# " ImportError: cannot import name 'nccl'"
#------------------------------------------------------------------------------------
#RUN mkdir -p /workspace/dlbs
#WORKDIR /workspace/dlbs
#COPY ./dlbs /workspace/dlbs
#WORKDIR /workspace/dlbs/python
RUN git clone https://github.com/vhojan/A-New-Hope.git
#RUN mv tf_cnn_benchmarks/ 1tf_cnn_benchmarks
#RUN cp -R benchmarks/scripts/tf_cnn_benchmarks/ .
#WORKDIR /workspace/dlbs
#------------------------------------------------------------------------------------
# End of Dockerfile
#------------------------------------------------------------------------------------
ENTRYPOINT [ "sh", "-c", "python A-New-Hope/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --data_format=NCHW --batch_size=64 --model=resnet50 --variable_update=replicated --local_parameter_device=gpu --num_batches=$BATCHES --nodistortions" ]