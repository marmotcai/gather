#!/bin/bash

cmd=${1}
param=${2}

case $cmd in 
    build)
      if [[ $param =~ 'mysql' ]]; then
        docker build -t marmotcai/mysql -f ./Dockerfile-mysql .
      fi

      if [[ $param =~ 'redis' ]]; then
        docker build -t marmotcai/redis -f ./Dockerfile-redis .
      fi;

      if [[ $param =~ 'ftp' ]]; then
        docker build -t marmotcai/ftp -f ./Dockerfile-ftp .
      fi;

      if [[ $param =~ 'nginx' ]]; then
        docker build -t marmotcai/nginx -f ./Dockerfile-nginx .
      fi;
      
      exit 0
    ;;

    run)
      if [[ $param =~ 'mysql' ]]; then
        docker run -p 33306:3306 --name my-mysql -v $PWD/data/mysql/conf:/etc/mysql/conf.d -v $PWD/data/mysql/logs:/logs -v $PWD/data/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=cg112233 -d mysql:5.7
      fi

      if [[ $param =~ 'redis' ]]; then
        docker rm -f my-redis
        docker run -p 36379:6379 --name my-redis -v $PWD/data/redis:/data -d --restart=always redis redis-server --appendonly yes # --requirepass "cg112233"
      fi;

      if [[ $param =~ 'ftp' ]]; then
        docker run -d -v $PWD/data/vsftpd:/home/vsftpd -p 20:20 -p 21:21 -p 21100-21110:21100-21110 -e FTP_USER=cg -e FTP_PASS=cg112233 --name my-vsftpd fauria/vsftpd
      fi;

      if [[ $param =~ 'minio' ]]; then
	docker run -p 9000:9000 \
                   --name my-minio \
                   -e "MINIO_ACCESS_KEY=4V1cweFJGTlhjM2hOUkVGM1RVUm9RV0l5U25GYVYwNHdURmhLTTA5WE9WcE5Wa1U5PNJI" \
                   -e "MINIO_SECRET_KEY=4WVRGQ01GWklVak50VWpGamMyWmFZV014Y0ZWbFFUMDk=qEyE" \
                   -v $PWD/data/minio/data:/data \
                   -v $PWD/data/minio/config:/root/.minio \
                   -d minio/minio server /data
      fi;

      if [[ $param =~ 'nginx' ]]; then
        docker rm -f my-nginx
        docker run -p 80:80 --name my-nginx -v $PWD/data/nginx:/data -d marmotcai/nginx
      fi

      if [[ $param =~ 'jumpserver' ]]; then
        if [ "$SECRET_KEY" = "" ]; then SECRET_KEY=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 50`; echo "SECRET_KEY=$SECRET_KEY" >> ~/.bashrc; echo $SECRET_KEY; else echo $SECRET_KEY; fi
        if [ "$BOOTSTRAP_TOKEN" = "" ]; then BOOTSTRAP_TOKEN=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 16`; echo "BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN" >> ~/.bashrc; echo $BOOTSTRAP_TOKEN; else echo $BOOTSTRAP_TOKEN; fi

        docker rm -f my-jumpserver
        docker run --name my-jumpserver -d -p 3080:80 -p 3022:2222 \
                   -e SECRET_KEY=$SECRET_KEY \
                   -e BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN \
                   -e DB_HOST=192.168.2.6 \
                   -e DB_PORT=33306 \
                   -e DB_USER=root \
                   -e DB_PASSWORD=cg112233 \
                   -e DB_NAME=jumpserver \
                   -e REDIS_HOST=192.168.2.6 \
                   -e REDIS_PORT=36379 \
                   -e REDIS_PASSWORD= \
                   jumpserver/jms_all:latest
      fi

      if [[ $param =~ 'dnsmasq' ]]; then
        docker run -d \
                   --name my-dnsmasq \
                   -p 53:53/udp \
                   -p 5380:8080 \
                   -v $PWD/data/dnsmasq/dnsmasq.conf:/etc/dnsmasq.conf \
                   --log-opt "max-size=100m" \
                   -e "HTTP_USER=admin" \
                   -e "HTTP_PASS=cg112233" \
                   --restart always \
                   jpillora/dnsmasq
      fi

      if [[ $param =~ 'crosstools' ]]; then
        docker run -d \
                   --name my-crosstools \
                   -v $PWD/data/crosstools:/root/data \
                   marmotcai/opencv-cross 
      fi

      if [[ $param =~ 'tensorflow' ]]; then
	docker run --name my-tensorflow -it -d -p 8888:8888 -v $PWD/data/tensorflow:/root/data tensorflow/tensorflow
      fi

      exit 0
    ;;

    test)
      docker run --rm -ti $param /bin/bash

      exit 0
    ;;

esac
    echo "use: sh build.sh build mysql"
    echo "use: sh build.sh build redis"
    echo "use: sh build.sh build ftp"
    echo "use: sh build.sh build nginx"
    echo "---"
    echo "use: sh build.sh run mysql"
    echo "use: sh build.sh run redis"
    echo "use: sh build.sh run ftp"
    echo "use: sh build.sh run minio"
    echo "use: sh build.sh run nginx"
    echo "use: sh build.sh run jumpserver"
    echo "use: sh build.sh run dnsmasq"
    echo "use: sh build.sh run crosstools"
    echo "use: sh build.sh run tensorflow"
    echo "---"
    echo "use: sh build.sh test imagesname"

exit 0;

