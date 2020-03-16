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

```commandline
docker run -p 8899:8888 jupytervino
```

## Access Jupyter

```
http://localhost:8899/
```

