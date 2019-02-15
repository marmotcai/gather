#!/bin/bash

<<<<<<< HEAD
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

rm -f ./authorized_keys; touch ./authorized_keys
=======
keysfile=/root/.ssh/authorized_keys

rm -f ${keysfile}; touch ${keysfile}
>>>>>>> 229c9c30218852750b5208c4faa8a5c7bca0073f
sed -i '/StrictHostKeyChecking/s/^#//; /StrictHostKeyChecking/s/ask/no/' /etc/ssh/ssh_config
sed -i "/#UseDNS/ s/^#//; /UseDNS/ s/yes/no/" /etc/ssh/sshd_config

cat hosts | while read ip host pwd; do
  sshpass -p $pwd ssh-copy-id -i ${WORK_DIR}/.ssh/id_rsa.pub -f ${USERNAME}@$ip 2>/dev/null
  ssh -nq ${USERNAME}@$ip "hostnamectl set-hostname $host"
  ssh -nq ${USERNAME}@$ip "echo -e 'y\n' | ssh-keygen -q -f ~/.ssh/id_rsa -t rsa -N ''"
  echo "===== Copy id_rsa.pub of $ip ====="
<<<<<<< HEAD
  scp ${USERNAME}@$ip:${WORK_DIR}/.ssh/id_rsa.pub ./$host-id_rsa.pub
  cat ./$host-id_rsa.pub >> ./authorized_keys
=======
  scp $ip:/root/.ssh/id_rsa.pub ./$host-id_rsa.pub
  cat ./$host-id_rsa.pub >> ${keysfile}
>>>>>>> 229c9c30218852750b5208c4faa8a5c7bca0073f
  echo $ip $host >> /etc/hosts
done

cat ~/.ssh/id_rsa.pub >> ${keysfile}
cat hosts | while read ip host pwd; do
  rm -f ./$host-id_rsa.pub
  echo "===== Copy authorized_keys to $ip ====="
<<<<<<< HEAD
  scp ./authorized_keys ${USERNAME}@$ip:${WORK_DIR}/.ssh/
  scp /etc/hosts ${USERNAME}@$ip:/etc/
  scp /etc/ssh/ssh_config ${USERNAME}@$ip:/etc/ssh/ssh_config
  scp /etc/ssh/sshd_config ${USERNAME}@$ip:/etc/ssh/sshd_config
  ssh -nq ${USERNAME}@$ip "systemctl restart sshd"
=======
  scp ${keysfile} $ip:/root/.ssh/
  scp /etc/hosts $ip:/etc/
  scp /etc/ssh/ssh_config $ip:/etc/ssh/ssh_config
  scp /etc/ssh/sshd_config $ip:/etc/ssh/sshd_config
  ssh -nq $ip "systemctl restart sshd"
>>>>>>> 229c9c30218852750b5208c4faa8a5c7bca0073f
done

