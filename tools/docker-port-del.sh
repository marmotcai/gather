#!/bin/bash

if [ $# -ne 1 ];then
    echo "The argument must be 1: xx host_port"
    exit;
else
  echo "begin..."
fi

host_port=${1}

num=$(iptables -t nat -nL DOCKER --line-number | grep dpt:${host_port} | awk '{print $1 }')

iptables_cmd='iptables -t nat -D DOCKER '${num}

echo ${iptables_cmd}

${iptables_cmd}

iptables -t nat -nL --line-number
