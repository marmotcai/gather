
#!/bin/bash

rm -f ./authorized_keys; touch ./authorized_keys
sed -i '/StrictHostKeyChecking/s/^#//; /StrictHostKeyChecking/s/ask/no/' /etc/ssh/ssh_config
sed -i "/#UseDNS/ s/^#//; /UseDNS/ s/yes/no/" /etc/ssh/sshd_config

cat hosts | while read ip host pwd; do
  sshpass -p  ssh-copy-id -f  2>/dev/null
  ssh -nq  "hostnamectl set-hostname "
  ssh -nq  "echo -e 'y\n' | ssh-keygen -q -f ~/.ssh/id_rsa -t rsa -N ''"
  echo "===== Copy id_rsa.pub of  ====="
  scp :/root/.ssh/id_rsa.pub ./-id_rsa.pub
  cat ./-id_rsa.pub >> ./authorized_keys
  echo   >> /etc/hosts
done

cat ~/.ssh/id_rsa.pub >> ./authorized_keys
cat hosts | while read ip host pwd; do
  rm -f ./-id_rsa.pub
  echo "===== Copy authorized_keys to  ====="
  scp ./authorized_keys :/root/.ssh/
  scp /etc/hosts :/etc/
  scp /etc/ssh/ssh_config :/etc/ssh/ssh_config
  scp /etc/ssh/sshd_config :/etc/ssh/sshd_config
  ssh -nq  "systemctl restart sshd"
done

