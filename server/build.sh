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
      
      exit 0
    ;;

esac
    echo "use: sh build.sh build mysql"
    echo "use: sh build.sh build redis"
    echo "use: sh build.sh build ftp"
    echo "---"
    echo "use: sh build.sh run mysql"
    echo "use: sh build.sh run redis"
    echo "use: sh build.sh run ftp"
exit 0;

