#------------------------------------------------------------------------------------
# This example Dockerfile illustrates a method to install
# additional packages on top of NVIDIA's tensorflow container image.
#------------------------------------------------------------------------------------
FROM nvcr.io/nvidia/tensorflow:20.01-tf1-py3
#------------------------------------------------------------------------------------
# Expose vars for dashboard POST URL
ENV DASHBOARD_FQDN=""
# File to run
ENV FILE="./A-New-Hope/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py"
# Expose vars for TF params
ENV BATCHES="200"
ENV BATCH_SIZE="64"
ENV DATA_FORMAT="NCHW"
ENV NUM_WARMUPS="20"
ENV MODEL_LIST="resnet50"
ENV OTHER_PARAMS="--variable_update=replicated --local_parameter_device=gpu  --nodistortions"
# Expose Bitfusion env vars
# The number of shared GPUs to use
ENV NUM_GPUS="1"
# Proportion of GPU memory to be requested
ENV PARTIAL_GPU="0.5"
# e.g: --server_list 172.16.31.247:56001
ENV BF_VARS=""
#------------------------------------------------------------------------------------ 
# Copy bitfusion files
RUN mkdir -p /root/.bitfusion
COPY ./bitfusion/client.yaml /root/.bitfusion/client.yaml
COPY ./bitfusion/servers.conf /etc/bitfusion/servers.conf
RUN mkdir -p /etc/bitfusion/tls
COPY ./bitfusion/ca.crt /etc/bitfusion/tls/ca.crt 
RUN chmod 600 /etc/bitfusion/tls/ca.crt && chmod 600 /root/.bitfusion/client.yaml
#------------------------------------------------------------------------------------ 
# Update package list
# Install Bitfusion. Use deb file for Ubuntu18.04
# Install open-vm-tools 
#------------------------------------------------------------------------------------ 
# Set initial working directory
RUN mkdir -p /workspace/bitfusion/batch-scripts
WORKDIR /workspace/bitfusion
# Copy Release version of bitfusion client
RUN wget https://packages.vmware.com/bitfusion/ubuntu/18.04/bitfusion-client-ubuntu1804_2.5.0-10_amd64.deb \
    && apt-get update \
    && apt-get install -y ./bitfusion-client-ubuntu1804_2.5.0-10_amd64.deb \
    && apt-get install -y open-vm-tools \
    && apt-get install --no-install-recommends -y nvidia-driver-418 \
    && rm -rf /var/lib/apt/lists/
#------------------------------------------------------------------------------------ 
# Needed to post results to dashboard
#------------------------------------------------------------------------------------  
RUN pip install requests prometheus_client nvsmi
#------------------------------------------------------------------------------------
# Clone benchmark repo
#------------------------------------------------------------------------------------
RUN git clone https://github.com/vhojan/A-New-Hope.git
#------------------------------------------------------------------------------------
# End of Dockerfile
#------------------------------------------------------------------------------------
EXPOSE 8080
ENTRYPOINT [ "sh", "-c", "bitfusion run -n $NUM_GPUS -p $PARTIAL_GPU $BF_VARS -- python $FILE --data_format=$DATA_FORMAT --batch_size=$BATCH_SIZE --model=$MODEL_LIST --num_batches=$BATCHES $OTHERPARAMS" ]