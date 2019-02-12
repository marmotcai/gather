#!/bin/bash

echo "start deploy..."

WORK_DIR=/root

#######################################################################

if [ ! -d "${WORK_DIR}/.ssh" ]; then
  mkdir ${WORK_DIR}/.ssh
  cp config ${WORK_DIR}/.ssh/config
fi

if [ ! -f "${WORK_DIR}/.ssh/id_rsa" ]; then
  echo "y" | ssh-keygen -t rsa -P '' -f ${WORK_DIR}/.ssh/id_rsa
  sh copy_ssh_id.sh
fi

while read ip host pwd
do
  host_list="${host_list} ${host}"

  echo `ssh ${host} "yum install -y psmisc ntp"

  result=`ssh ${host} "yum list installed | grep ceph"`
  if [ -z "$result" ];then
    echo "(${host}) ceph not installed"
  else
    ceph-deploy purgedata ${host}
    ceph-deploy purge ${host}
  fi
  ceph-deploy install ${host}
  
done < hosts

# ceph-deploy forgetkeys

exit 0

######################################################################

# yum install -y ntp ntpdate ntp-doc 
# ntpdate time1.aliyun.com
# hwclock --systohc 
# systemctl enable ntpd.service 
# systemctl start ntpd.service

# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

#######################################################################

# useradd -d /home/cephuser -m cephuser 
# echo "cephuser:112233" | chpasswd

# echo "cephuser ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/cephuser 
# chmod 0440 /etc/sudoers.d/cephuser 
# sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers

# echo "112233" | su - cephuser

#######################################################################

# ssh root@ceph-admin 
# systemctl stop firewalld 
# systemctl disable firewalld

#######################################################################
 
ceph-deploy purgedata ${host_list}
ceph-deploy purge ${host_list}
ceph-deploy forgetkeys

ceph-deploy install ${host_list}

exit 0

#######################################################################

mkdir cluster
cd cluster
ceph-deploy new ${host_list}
echo "public_network = 192.168.1.0/24" >> ceph.conf
echo "osd_pool_default_size = 2" >> ceph.conf

ceph-deploy mon create-initial
ceph-deploy gatherkeys mon1

######################################################################

ceph-deploy disk list osd1 osd2

ceph-deploy disk zap osd1:/dev/sdb osd2:/dev/sdb
ceph-deploy osd prepare osd1:/dev/sdb osd2:/dev/sdb
ceph-deploy osd activate osd1:/dev/sdb1 osd2:/dev/sdb1

ceph-deploy disk list osd1 osd2

######################################################################

ceph-deploy admin ${host_list}
sudo chmod 644 /etc/ceph/ceph.client.admin.keyring

#####################################################################

#cd ../
#rm -f authorized_keys
#rm -rf cluster
