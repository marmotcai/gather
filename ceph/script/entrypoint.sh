#!/bin/bash

echo "start deploy..."

#######################################################################

# yum install -y ntp ntpdate ntp-doc 
# ntpdate time1.aliyun.com
# hwclock --systohc 
# systemctl enable ntpd.service 
# systemctl start ntpd.service

# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

cp ceph.repo /etc/yum.repos.d/ceph.repo

yum clean all
yum makecache fast

#######################################################################

mkdir ~/.ssh
cp config ~/.ssh/config

#######################################################################

useradd -d /home/cephuser -m cephuser 
echo "cephuser:112233" | chpasswd

echo "cephuser ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/cephuser 
chmod 0440 /etc/sudoers.d/cephuser 
sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers

echo "112233" | su - cephuser
echo "y" | ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
sh copy_ssh_id.sh

#######################################################################

# ssh root@ceph-admin 
# systemctl stop firewalld 
# systemctl disable firewalld

#######################################################################

while read ip host pwd
do
  host_list="${host_list} ${host}"

  ceph-deploy purge ${ip}
  ceph-deploy purgedata ${ip}

  ceph-deploy install ${ip}
done < hosts

ceph-deploy forgetkeys

echo ${host_list}

#######################################################################

cd ../
rm -f authorized_keys
rm -rf cluster
