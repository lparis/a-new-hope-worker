#------------------------------------------------------------------------------------
# This example Dockerfile illustrates a method to install
# additional packages on top of NVIDIA's tensorflow container image.
#------------------------------------------------------------------------------------
FROM nvcr.io/nvidia/tensorflow:20.01-tf1-py3
#------------------------------------------------------------------------------------
# Expose vars for dashboard POST URL and number of batches to run on the benchmark
ENV DASHBOARD_FQDN=""
ENV BATCHES=""
#------------------------------------------------------------------------------------ 
# Copy bitfusion files
RUN mkdir -p /root/.bitfusion
COPY ./bitfusion/client.yaml /root/.bitfusion/client.yaml
COPY ./bitfusion/servers.conf /etc/bitfusion/servers.conf
RUN mkdir -p /etc/bitfusion/tls
COPY ./bitfusion/ca.crt /etc/bitfusion/tls/ca.crt 
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
    && rm -rf /var/lib/apt/lists/
#------------------------------------------------------------------------------------ 
# Needed to post results to dashboard
#------------------------------------------------------------------------------------  
RUN pip install requests
#------------------------------------------------------------------------------------
# Clone benchmark repo
#------------------------------------------------------------------------------------
RUN git clone https://github.com/vhojan/A-New-Hope.git
#------------------------------------------------------------------------------------
# End of Dockerfile
#------------------------------------------------------------------------------------
ENTRYPOINT [ "sh", "-c", "python A-New-Hope/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --data_format=NCHW --batch_size=64 --model=resnet50 --variable_update=replicated --local_parameter_device=gpu --num_batches=$BATCHES --nodistortions" ]