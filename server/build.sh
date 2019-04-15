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
        docker run -p 36379:6379 --name my-redis -v $PWD/data/redis:/data -d redis redis-server  # --appendonly yes
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
        docker run -p 80:80 --name my-webserver -v $PWD/data/nginx:/data -d marmotcai/nginx
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
    echo "---"
    echo "use: sh build.sh test imagesname"

exit 0;

