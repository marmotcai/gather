#!/bin/bash

docker rm -f my-s3cmd
docker run -d --name my-s3cmd  marmotcai/s3cmd
