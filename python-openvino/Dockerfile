# base
FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

# init
WORKDIR /home/ubuntu/
USER root
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    cpio \
    sudo \
    git \
    zip \
    unzip \
    curl \
    xterm \
    vim \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*

# intel python
#Set Variables
ARG TEMP_PATH=/tmp/miniconda
ARG MINICONDA_URL=https://repo.continuum.io/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh
ARG INTEL_PYTHON=intelpython3_core=2019.4

#Install commands
RUN apt-get update && \
    apt-get install -y bzip2 ca-certificates

#Install miniconda3
RUN mkdir -p ${TEMP_PATH} && cd ${TEMP_PATH} && \
    wget -nv  ${MINICONDA_URL} -O miniconda.sh && \
    /bin/bash miniconda.sh -b -p /opt/conda

RUN rm -rf ${TEMP_PATH}
ENV PATH /opt/conda/bin:$PATH

# Install Intel Python 3 core Package
ENV ACCEPT_INTEL_PYTHON_EULA=yes
RUN conda create -n idp python==3.6.8 -y
RUN conda config --add channels intel \
    && conda install -y -q ${INTEL_PYTHON} python=3.6.8 \
    && conda install networkx \
    && conda install defusedxml \
    && conda install tensorflow=1.15 \
    && conda clean --all \
    && pip install jupyter \
    && pip install networkx \
    && pip install defusedxml \
    && pip install tensorflow==1.15 \
    && apt-get update -qqq \
    && apt-get install -y -q g++ \
    && apt-get autoremove

SHELL ["/bin/bash", "-c"]

# install packages
RUN source activate idp \
    && conda install numpy -c intel --no-update-deps \
    && conda install jupyter \
    && conda install matplotlib \
    && conda install tensorflow=1.15 \
    && conda install networkx \
    && conda install defusedxml \
    && jupyter notebook --generate-config \
    && ipython kernel install --user --name=idp --display-name=idp

# openvino
# ARG DOWNLOAD_LINK=http://registrationcenter-download.intel.com/akdlm/irc_nas/15944/l_openvino_toolkit_p_2019.3.334_online.tgz
ARG DOWNLOAD_LINK=http://registrationcenter-download.intel.com/akdlm/irc_nas/16345/l_openvino_toolkit_p_2020.1.023.tgz
ARG INSTALL_DIR=/opt/intel/openvino
ARG TEMP_DIR=/tmp/openvino_installer

RUN mkdir -p $TEMP_DIR && \
    cd $TEMP_DIR && \
    wget -c $DOWNLOAD_LINK && \
    tar xf l_openvino_toolkit*.tgz && \
    ls && \
    cd l_openvino_toolkit_p_2020.1.023 && \
    source activate idp && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh -s silent.cfg && \
    rm -rf $TEMP_DIR

# build Inference Engine samples
RUN source activate idp \
    && $INSTALL_DIR/install_dependencies/install_openvino_dependencies.sh \
    && $INSTALL_DIR/deployment_tools/model_optimizer/install_prerequisites/install_prerequisites.sh tf

RUN echo "alias openvino='source /opt/intel/openvino/bin/setupvars.sh'" >> ~/.bashrc


# CMAKE
RUN apt-get update
RUN sudo apt remove cmake -y
ARG DOWNLOAD_LINK=https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2-Linux-x86_64.sh
ARG TEMP_DIR=/home/ubuntu/cmake_installer/cmake-3.16.2-Linux-x86_64/

RUN mkdir -p $TEMP_DIR && cd $TEMP_DIR \
    && wget $DOWNLOAD_LINK \
    && chmod +x cmake-*-Linux-x86_64.sh \
    && sudo bash cmake-*-Linux-x86_64.sh --skip-license \
    && cd .. \
    && sudo mv cmake-*-Linux-x86_64 /opt \
    && sudo ln -s /opt/cmake-3.16.2-Linux-x86_64/bin/* /usr/bin

# export PATH=TEMP_DIR/bin:$PATH

# env path
RUN echo LC_ALL=C.UTF-8  >> ~/.bashrc
RUN echo LANG=C.UTF-8  >> ~/.bashrc

# pyvino
RUN echo source activate idp >> ~/.bashrc
ENV PYTHONPATH /home/ubuntu/src_dir/pyvino/pyvino/model/human_pose_estimation/human_3d_pose_estimator/pose_extractor/build/:$PYTHONPATH
RUN echo openvino >> ~/.bashrc


# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

COPY start_notebook.sh /home/ubuntu/
RUN chmod +x /home/ubuntu/start_notebook.sh

CMD ["/bin/bash", "start_notebook.sh"]