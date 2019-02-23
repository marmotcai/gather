#!/bin/bash

USERNAME=root
WORK_DIR=/root

if [ ! -z "${1}" ];then
  USERNAME=${1}

  if [ ${USERNAME} = "root" ];then
    WORK_DIR=/root
  else
    WORK_DIR=/home/${1}
  fi
fi

echo "copy ssh ${USERNAME}(${WORK_DIR}) id to hosts"

keysfile=${WORK_DIR}/.ssh/authorized_keys
rm -f ${keysfile}; touch ${keysfile}

if  [[ ${USERNAME} = 'root' ]]; then
  sed -i '/StrictHostKeyChecking/s/^#//; /StrictHostKeyChecking/s/ask/no/' /etc/ssh/ssh_config
  sed -i "/#UseDNS/ s/^#//; /UseDNS/ s/yes/no/" /etc/ssh/sshd_config
fi

cat hosts | while read ip port host pwd param; do
  echo "copy ssh id to $ip:$port"
  sshpass -p $pwd ssh-copy-id -i ${WORK_DIR}/.ssh/id_rsa.pub -f ${USERNAME}@$ip -p $port 2>/dev/null
  
  if [[ ${USERNAME} = 'root' ]]; then
    ssh -nq -p $port $ip "hostnamectl set-hostname $host"
    ssh -nq -p $port $ip "echo -e 'y\n' | ssh-keygen -q -f /root/.ssh/id_rsa -t rsa -N ''"
    echo "===== Copy id_rsa.pub of $ip ====="
    scp -P $port $ip:/root/.ssh/id_rsa.pub ./$host-id_rsa.pub
    cat ./$host-id_rsa.pub >> ${keysfile}
    
    echo $ip $host >> /etc/hosts
  else
    sshpass -p $pwd ssh-copy-id -i ${WORK_DIR}/.ssh/id_rsa.pub -f root@$ip -p $port 2>/dev/null
    sudo sshpass -p $pwd ssh-copy-id -i /root/.ssh/id_rsa.pub -f ${USERNAME}@$ip -p $port 2>/dev/null
  fi
done
exit 0
if  [[ ${USERNAME} = 'root' ]]; then
  cat /root/.ssh/id_rsa.pub >> ${keysfile}
  cat hosts | while read ip port host pwd param; do
    rm -f ./$host-id_rsa.pub
    echo "===== Copy authorized_keys to $ip ====="
    scp ${keysfile} -P $port $ip:/root/.ssh/
    scp /etc/hosts -P $port $ip:/etc/
    scp /etc/ssh/ssh_config -P $port $ip:/etc/ssh/ssh_config
    scp /etc/ssh/sshd_config -P $port $ip:/etc/ssh/sshd_config
    ssh -nq -p $port $ip "systemctl restart sshd"
  done
fi

