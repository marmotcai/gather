#!/bin/bash


docker build --target python-builder -t marmotcai/python-app -f ./Dockerfile .

docker rm -f my-stock
docker run -p 80:7788 --name my-stock -d marmotcai/python-app
