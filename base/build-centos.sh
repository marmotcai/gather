#!/bin/bash

imagename=${1}
hostname=${imagename}
sshport=${2}

if [ -z "${imagename}" ];then
  echo "use : sh build-centos.sh image-name ssh-port"
  exit 0
fi

if [ -z "${sshport}" ];then
  sshport="22"
fi


result=`docker ps -a | grep -w -i "${sshport}->22"`
if [ ! -z "${result}" ];then
  id=`echo ${result} | grep -w -i "${imagename}" | awk '{print $1}'`
  if [ ! -z "${id}" ];then
    echo "find container (id=${id}) and remove it.."
    # docker ps -a | grep -w "${id}" | awk '{print $1}' | xargs docker rm -f
    docker rm -f ${id}
  else
    result=`echo ${result} | awk '{printf $1}'`
    echo "${sshport} port is use as ${result}"
    exit 0
  fi  
fi
docker run -d --privileged -p ${sshport}:22 --name=${imagename} --hostname=${hostname} marmotcai/centos-base
echo "ssh -p ${sshport} root@localhost"
