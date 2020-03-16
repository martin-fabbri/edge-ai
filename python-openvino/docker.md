## Clone repository

```commandline
git clone https://github.com/martin-fabbri/edge-ai.git
cd edge-ai/python-openvino
```

## Build docker image

```commandline
docker build -t jupytervino .
```

## Run container

Windows command line (cmd)
```commandline
docker run -p 8899:8888 %cd%:/home/ubuntu jupytervino
```

Windows PowerShell
```commandline
docker run -p 8899:8888 ${PWD}:/home/ubuntu jupytervino
```

Linux/Mac
```commandline
docker run -p 8899:8888 $(pwd):/home/ubuntu jupytervino
```

## Access Jupyter

```
http://localhost:8899/
```
Passcode: ```openvino```

