#!/bin/bash
echo "${0} ${1} ${2} ${3}"
PASSWORD=123456
USERNAME=root
WORK_DIR=/${USERNAME}

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

function addIptables()
{
  host=$1
  port=$2
  ssh -tt ${host} << addiptables  
    # sudo iptables -L -n --line-numbers | grep ${port} | awk '{print $1}' | xargs iptables -D INPUT
    sudo iptables -D INPUT -p tcp --dport ${port} -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport ${port} -j ACCEPT
    iptables -nL --line-number | grep $port
    # sudo service iptables save
    exit
addiptables
}

function clean()
{
  rm -f ./ceph-deploy-ceph.log
  if [ ! -z "${1}" ];then
    USERNAME=${1}
    WORK_DIR=/home/${1}

    echo "clean the user files (${USERNAME})"
    userdel ${USERNAME}
    rm -f /etc/sudoers.d/${USERNAME}
  else
    echo "clean the root files (${USERNAME})"
    USERNAME=root
    WORK_DIR=/${USERNAME}
  fi
  rm -rf ${WORK_DIR}/.ssh
  rm -rf ${WORK_DIR}/cluster
}

function init()
{
  if [ ! -z "${1}" ];then
    USERNAME=${1}
    WORK_DIR=/home/${1}
  
    useradd -d ${WORK_DIR} -m ${USERNAME}
    echo "${PASSWORD}" | passwd --stdin ${USERNAME}

    echo "${USERNAME} ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${USERNAME} 
    chmod 0440 /etc/sudoers.d/${USERNAME}

    sudo sed -i 's/Defaults    requiretty/Defaults:${USERNAME}    !requiretty/' /etc/sudoers

    # echo ${PASSWORD} | && \
    # su - ${USERNAME}
  else
    USERNAME=root
    WORK_DIR=/root
  fi
  
  if [ ! -d "${WORK_DIR}/.ssh" ]; then
    echo "build .ssh config file & copy ssh id"
    mkdir ${WORK_DIR}/.ssh
    while read ip host pwd
    do
      echo "Host ${host}" >> ${WORK_DIR}/.ssh/config
      echo "  Hostname ${host}" >> ${WORK_DIR}/.ssh/config
      echo "  User ${USERNAME}" >> ${WORK_DIR}/.ssh/config
    done < hosts

    chmod 644 ${WORK_DIR}/.ssh/config
  fi

  if [ ! -f "${WORK_DIR}/.ssh/id_rsa" ]; then
    echo "y" | ssh-keygen -t rsa -P '' -f ${WORK_DIR}/.ssh/id_rsa
    sh copy_ssh_id.sh ${USERNAME}
  fi
  echo "init to ${WORK_DIR} finished"
}

function install()
{
  host=${1}
  echo "begin install to ${host}"

  addIptables ${host} 6789
  addIptables ${host} 6800
  addIptables ${host} 7300
  
  ssh -n ${host} "systemctl stop firewalld; systemctl disable firewalld"

  # fSSHInstall ${host} ntp
  # # fSSHInstall ${host} ceph
  # # fSSHInstall ${host} psmisc
  # # ssh -n ${host} "killall -9 yum"

  fInstalled ${host} ceph-release
  result=$?
  if [ $result -eq "1" ]; then
    result=`ssh -n ${host} "ceph --version"`
    echo ${result}
  else
    echo "ceph is not installed"
    ceph-deploy install ${host}
  fi
  echo "${host} is install finished"
}

function uninstall()
{
  host_list=""
  while read ip host pwd
  do
    host_list="${host_list} ${host}"
    # ssh -n ${host} "rm -rf /etc/ceph/*; rm -rf /var/lib/ceph/*"
  done < hosts

  if [ ! -z "${host_list}" ];then
    ceph-deploy purge ${host_list}
    ceph-deploy purgedata ${host_list}
    ceph-deploy forgetkeys
  fi
}

function deploy()
{
  host_list=""
  while read ip host pwd
  do
    host_list="${host_list} ${host}"
  done < hosts
 
  echo "ceph-deploy (${PWD}) to ${host_list}"

  mkdir $WORK_DIR/cluster
  cd $WORK_DIR/cluster

  ceph-deploy new ${host_list}
  echo "public_network = 192.168.1.0/24" >> ceph.conf
  echo "osd_pool_default_size = 2" >> ceph.conf
  
  ceph-deploy --overwrite-conf mon create-initial
  ceph-deploy --overwrite-conf gatherkeys mon1
  
  cd /root/script
}

#######################################################################

cmd=${1}
param1=${2}
case $cmd in 
    clean)
      clean ${param1}
    ;;

    init)
      init ${param1}
    ;;

    install)
      host_list=""
      while read ip host pwd
      do
        host_list="${host_list} ${host}"
        install ${host}
      done < hosts
      echo "install ceph (${PWD}) to ${host_list}"
      # ceph-deploy install ${host_list}
    ;;

    uninstall)
      uninstall
    ;;
    
    deploy)
      deploy
    ;;
esac

exit 0;

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
