#!/bin/bash

cmd=${1}
port=${2}
access_key=${3}
secret_key=${4}
case $cmd in 
    server)
       docker rm -f my-minio-server
       docker run -p $port:9000 --name my-minio-server \
                  -e "MINIO_ACCESS_KEY=$access_key" \
                  -e "MINIO_SECRET_KEY=$secret_key" \
                  minio/minio server /data
    ;;

    nas)
       docker rm -f my-minio-nas
       docker run -p $port:9000 --name my-minio-nas \
                  -e "MINIO_ACCESS_KEY=$access_key" \
                  -e "MINIO_SECRET_KEY=$secret_key" \
                  -v $PWD/nasvol:/container/vol \
                  minio/minio gateway nas /container/vol
    ;;

    build)
      docker build -t marmotcai/minio .
    ;;

    *)
      echo "use: sh build.sh build"
      echo "use: sh build.sh server port access_key secret_key"
      echo "use: sh build.sh nas port access_key secret_key"
    ;;

esac

