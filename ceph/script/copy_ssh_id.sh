#!/bin/bash

rm -f ./authorized_keys; touch ./authorized_keys
sed -i '/StrictHostKeyChecking/s/^#//; /StrictHostKeyChecking/s/ask/no/' /etc/ssh/ssh_config
sed -i "/#UseDNS/ s/^#//; /UseDNS/ s/yes/no/" /etc/ssh/sshd_config

cat hosts | while read ip host pwd; do
  sshpass -p $pwd ssh-copy-id -f $ip 2>/dev/null
  # ssh -nq $ip "hostnamectl set-hostname $host"
  # ssh -nq $ip "echo -e 'y\n' | ssh-keygen -q -f ~/.ssh/id_rsa -t rsa -N ''"
  # echo "===== Copy id_rsa.pub of $ip ====="
  # scp $ip:/root/.ssh/id_rsa.pub ./$host-id_rsa.pub
  # cat ./$host-id_rsa.pub >> ./authorized_keys
  echo $ip $host >> /etc/hosts
done

# cat ~/.ssh/id_rsa.pub >> ./authorized_keys
# cat hosts | while read ip host pwd; do
#  rm -f ./$host-id_rsa.pub
#  echo "===== Copy authorized_keys to $ip ====="
#  scp ./authorized_keys $ip:/root/.ssh/
#  scp /etc/hosts $ip:/etc/
#  scp /etc/ssh/ssh_config $ip:/etc/ssh/ssh_config
#  scp /etc/ssh/sshd_config $ip:/etc/ssh/sshd_config
#  ssh -nq $ip "systemctl restart sshd"
# done

