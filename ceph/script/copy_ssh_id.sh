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

sed -i '/StrictHostKeyChecking/s/^#//; /StrictHostKeyChecking/s/ask/no/' /etc/ssh/ssh_config
sed -i "/#UseDNS/ s/^#//; /UseDNS/ s/yes/no/" /etc/ssh/sshd_config

cat hosts | while read ip host pwd param; do
  sshpass -p $pwd ssh-copy-id -i ${WORK_DIR}/.ssh/id_rsa.pub -f ${USERNAME}@$ip 2>/dev/null
  ssh -nq ${USERNAME}@$ip "hostnamectl set-hostname $host"
  ssh -nq ${USERNAME}@$ip "echo -e 'y\n' | ssh-keygen -q -f ~/.ssh/id_rsa -t rsa -N ''"
  echo "===== Copy id_rsa.pub of $ip ====="
  scp ${USERNAME}@$ip:${WORK_DIR}/.ssh/id_rsa.pub ./$host-id_rsa.pub
  cat ./$host-id_rsa.pub >> ${keysfile}
  echo $ip $host >> /etc/hosts
done

cat ~/.ssh/id_rsa.pub >> ${keysfile}
cat hosts | while read ip host pwd dev; do
  rm -f ./$host-id_rsa.pub
  echo "===== Copy authorized_keys to $ip ====="
  scp ${keysfile} ${USERNAME}@$ip:${WORK_DIR}/.ssh/
  scp /etc/hosts ${USERNAME}@$ip:/etc/
  scp /etc/ssh/ssh_config ${USERNAME}@$ip:/etc/ssh/ssh_config
  scp /etc/ssh/sshd_config ${USERNAME}@$ip:/etc/ssh/sshd_config
  ssh -nq ${USERNAME}@$ip "systemctl restart sshd"
done

