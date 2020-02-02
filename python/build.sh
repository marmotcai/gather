#!/bin/bash

# docker build --target python-base -t marmotcai/python-base -f ./Dockerfile .
# docker rm -f my-python-base
# docker run -p 1722:22 -p 1788:8888 -v $PWD/data:/root/data --name my-python-base -d marmotcai/python-base 

docker build --target python-jupyter-notebook -t marmotcai/python-jupyter-notebook -f ./Dockerfile .
docker rm -f my-python-jupyter-notebook
docker run -p 1722:22 -p 1788:8888 -v $PWD/data:/root/data --name my-python-jupyter-notebook -d marmotcai/python-jupyter-notebook 

