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
        docker rm -f my-mysql
        docker run -p 3306:3306 --name my-mysql -v $PWD/data/mysql/conf:/etc/mysql/conf.d -v $PWD/data/mysql/logs:/logs -v $PWD/data/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=112233 -d mysql:5.7
      fi

      if [[ $param =~ 'redis' ]]; then
        docker rm -f my-redis
        docker run -p 6379:6379 --name my-redis -v $PWD/data/redis:/data -d --restart=always redis redis-server --appendonly yes --requirepass "112233"
      fi;

      if [[ $param =~ 'postgresql' ]]; then
        docker rm -f my-postgresql
        docker run --name my-postgresql -e POSTGRES_PASSWORD=112233 -p 5432:5432 -v $PWD/data/pgdata:/var/lib/postgresql/data -d postgres:9.6
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

      if [[ $param =~ 'iscsi' ]]; then
        docker run -d -it \
                   --name my-iscsi \
                   --net=host \
                   -v $PWD/data/iscsi/targets:/iscsi/targets \
                   dreamcat4/iscsi
      fi


      if [[ $param =~ 'pxe' ]]; then
        docker run -d --name=my-pxe \
                   --net=host \
                   -v $PWD/data/pxe:/pxe \
                   dreamcat4/pxe
      fi

      if [[ $param =~ 'crosstools' ]]; then
        docker run -d \
                   --name my-crosstools \
                   -v $PWD/data/crosstools:/root/data \
                   marmotcai/opencv-cross 
      fi

      if [[ $param =~ 'plex' ]]; then
        docker rm -f my-plex
        docker run -d \
                   --name my-plex \
                   -p 32400:32400/tcp \
                   -p 3005:3005/tcp \
                   -p 8324:8324/tcp \
                   -p 32469:32469/tcp \
                   -p 1900:1900/udp \
                   -p 32410:32410/udp \
                   -p 32412:32412/udp \
                   -p 32413:32413/udp \
                   -p 32414:32414/udp \
                   -e TZ="" \
                   -e PLEX_CLAIM="" \
                   -e ADVERTISE_IP="http://test.lan.tcyhtv.cn:32400/" \
                   -h my-plex \
                   -v $PWD/data/plex:/config \
                   -v $PWD/data/plex:/transcode \
                   -v $PWD/data/plex:/data \
                   plexinc/pms-docker
      fi

      if [[ $param =~ 'jupyter' ]]; then
        docker run -d \
                   --name my-jupyter \
                   -p 8888:8888 \
                   jupyter/datascience-notebook
      fi


      if [[ $param =~ 'tensorflow' ]]; then
	docker rm -f my-tensorflow
        docker run --name my-tensorflow -it -d -v $PWD/data/tensorflow:/home/jovyan/work/data -p 8888:8888 marmotcai/tensorflow
        docker exec my-tensorflow chown jovyan.users /home/jovyan/work/data -R 
	# docker run --name my-tensorflow -it -d -v $PWD/data/tensorflow:/tf -p 8888:8888 lspvic/tensorboard-notebook
	# docker run --name my-tensorflow -it -d -v $PWD/data/tensorflow:/tf -p 8888:8888 tensorflow/tensorflow:latest-py3-jupyter
        # docker run --name my-tensorflow -it -d -p 8888:8888 -v $PWD/data/tensorflow:/root/data tensorflow/tensorflow
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
    echo "use: sh build.sh run postgresql"
    echo "use: sh build.sh run ftp"
    echo "use: sh build.sh run minio"
    echo "use: sh build.sh run nginx"
    echo "use: sh build.sh run jumpserver"
    echo "use: sh build.sh run dnsmasq"
    echo "use: sh build.sh run iscsi"
    echo "use: sh build.sh run pxe"
    echo "use: sh build.sh run crosstools"
    echo "use: sh build.sh run plex"
    echo "use: sh build.sh run jupyter"
    echo "use: sh build.sh run tensorflow"
    echo "---"
    echo "use: sh build.sh test imagesname"

exit 0;

