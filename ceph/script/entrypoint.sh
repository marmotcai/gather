#!/bin/bash

echo "start deploy..."

WORK_DIR=/root

#######################################################################

function fInstalled()
{
  result=`ssh -n ${1} "yum list installed | grep ${2}"`
  # echo $result;

  if [ -z "$result" ];then
    return 0
  else
    return 1
  fi
}

function fSSHInstall()
{
  fInstalled $1 $2
  result=$?
  if [ $result -eq "1" ]; then
    echo "${2} is installed on ${1}"
  else
    echo "install ${2} to ${1}"
    result=`ssh -n $1 "yum install -y $2"`
  fi
}

#######################################################################

if [ ! -d "${WORK_DIR}/.ssh" ]; then
  mkdir ${WORK_DIR}/.ssh
  cp config ${WORK_DIR}/.ssh/config
  chmod 644 ${WORL_DIR}/.ssh/config
fi

if [ ! -f "${WORK_DIR}/.ssh/id_rsa" ]; then
  echo "y" | ssh-keygen -t rsa -P '' -f ${WORK_DIR}/.ssh/id_rsa
  sh copy_ssh_id.sh
fi

#######################################################################

while read ip host pwd
do
  host_list="${host_list} ${host}"
  echo "begin install to ${host}"

  fSSHInstall ${host} ntp
  fSSHInstall ${host} psmisc
  # # fSSHInstall ${host} ceph
  
  ssh -n ${host} "killall -9 yum"
  
  fInstalled ${host} ceph
  result=$?
  if [ $result -eq "1" ]; then
    result=`ssh -n ${host} "ceph --version"`
    echo ${result}
  else
    echo "ceph is not installed"

    # ceph-deploy purgedata ${host}
    # ceph-deploy purge ${host}
    # ceph-deploy install ${host}
  fi
  ceph-deploy purgedata ${host}
  echo "${host} is install finished"  
done < hosts

# ceph-deploy forgetkeys
# ceph-deploy install ${host_list}

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

echo "begin initial ${host_list}"

mkdir $WORK_DIR/cluster
cd $WORK_DIR/cluster

ceph-deploy new ${host_list}
echo "public_network = 192.168.1.0/24" >> ceph.conf
echo "osd_pool_default_size = 2" >> ceph.conf

ceph-deploy --overwrite-conf mon create-initial
ceph-deploy gatherkeys mon1

######################################################################
exit 0
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
