#!/bin/bash
source /opt/intel/openvino/bin/setupvars.sh 
jupyter notebook --port=8888 --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token="openvino"

