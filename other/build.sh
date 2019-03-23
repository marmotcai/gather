#!/bin/bash

docker build -t marmotcai/minio .

docker rm -f my-minio
docker run -p 9000:9000 marmotcai/minio server /data
# docker run -d -v $PWD/data:/data -p 9000:9000 --name my-minio marmotcai/minio
