#!/bin/bash

if [ $# -ne 3 ];then
    echo "The argument must be 3: xx docker_name host_port docker_port"
    exit;
else
  echo "begin..."
fi

docker_name=${1}
host_port=${2}
docker_port=${3}

./docker-port-del.sh ${host_port}

docker_ip=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' ${docker_name})

iptables_cmd1='iptables -A DOCKER ! -i docker0 -o docker0 -p tcp --dport '${docker_port}' -d '${docker_ip}' -j ACCEPT'
iptables_cmd2='iptables -t nat -A DOCKER -p tcp --dport '${host_port}' -j DNAT --to-destination '${docker_ip}':'${docker_port}''

#echo ${iptables_cmd1}
#echo ${iptables_cmd2}

${iptables_cmd1} & ${iptables_cmd2}

iptables -t nat -nL --line-number | grep dpt:${host_port} 
