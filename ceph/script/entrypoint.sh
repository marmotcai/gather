#!/bin/bash
echo "${0} ${1} ${2} ${3}"
PASSWORD=123456
USERNAME=root
WORK_DIR=/${USERNAME}
SCRIPT_WORK_DIR=/root/script

#######################################################################

function fGetOSName()
{
  host=$1
  result=`ssh -n ${host} "cat /etc/os-release | awk 'NR==3' | cut -d '=' -f2" | sed 's/"//g'`
  echo $result
}

function fInstalled()
{
  host=${1}
  name=${2}
  echo ssh -n ${host} "yum list installed | grep ${name}"
  result=`ssh -n ${host} "yum list installed | grep ${name}"`
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
  ssh -tt root@${host} << addiptables  
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
  USERNAME=root
  WORK_DIR=/root

  if [ ! -z "${1}" ];then
    USERNAME=${1}
    WORK_DIR=/home/${1}

    echo "clean the user files (${USERNAME})"
    userdel ${USERNAME}
    rm -f /etc/sudoers.d/${USERNAME}
    rm -rf ${WORK_DIR}/.ssh
    rm -rf ${WORK_DIR}

    while read ip port host pwd param
    do
      ssh -tt root@${host} << deluser
        sudo userdel ${username}
        sudo rm -f /etc/sudoers.d/${USERNAME}
        sudo rm -rf ${WORK_DIR}
        exit
deluser
    done < hosts
  fi

  rm -rf ${WORK_DIR}/cluster

  rm -f ./*.log

  echo "clean the root files (${USERNAME})"
  rm -rf ${WORK_DIR}/.ssh
}

function addUser()
{
  host=${1}
  port=${2}
  username=${3}
  password=${4}
  workdir=/home/${username}

  echo "add user ${username} to ${host}"
  if  [[ ${username} = 'root' ]]; then
    echo "root user can't add to ${host}"
    exit
  fi
  
  osname="$(fGetOSName $host)"
  ssh -tt ${host} -p ${port} << adduser  
    echo "add user (${host} ${username} ${password})"
    
    sudo userdel ${username}
    sudo rm -f /etc/sudoers.d/${USERNAME}
    sudo rm -rf ${WORK_DIR}
    
    sudo useradd -d ${workdir} -m ${username}
    # echo "${password}" | sudo passwd --stdin ${username}
    echo ${username}:${password}|chpasswd
    
    if [[ $osname =~ 'centos' ]]; then
      echo "begin add ${username} to $osname sudoer"
      echo "${username} ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${username}
      sudo chmod 0440 /etc/sudoers.d/${username}
      sudo sed -i 's/Defaults    requiretty/Defaults:${username}    !requiretty/' /etc/sudoers
    fi

    if [[ $osname =~ 'ubuntu' ]]; then
      echo "begin add ${username} to $osname sudoer"
      sudo usermod -s /bin/bash ${username}
      sudo chmod u+w /etc/sudoers
      # sudo sed -i '/# User privilege specification/a ${username} ALL=(ALL:ALL) ALL' /etc/sudoers
      sudo sed -i '/# User privilege specification/a ${username} ALL=(ALL) NOPASSWD:ALL' /etc/sudoers
      sudo chmod u-w /etc/sudoers    
    fi

    exit
adduser
}

function init()
{
  USERNAME=root
  WORK_DIR=/root
  CONFIG_PATH=/root/.ssh/config

  rm -rf ${WORK_DIR}/.ssh; mkdir -p ${WORK_DIR}/.ssh
  if [ ! -f "${WORK_DIR}/.ssh/id_rsa" ]; then
    echo "y" | ssh-keygen -t rsa -P '' -f "${WORK_DIR}/.ssh/id_rsa"
    sh copy_ssh_id.sh
    
    # while read ip port host pwd param
    # do
      #delUser ${host} ${USERNAME} ${pwd}
    # done < hosts 
  fi

  if [ ! -z "${1}" ];then
    USERNAME=${1}
    WORK_DIR=/home/${1}
    # CONFIG_PATH=${WORK_DIR}/.ssh/config
    
    echo "add user ($USERNAME)"
    useradd -d ${WORK_DIR} -m ${USERNAME}
    echo "${PASSWORD}" | passwd --stdin ${USERNAME}

    echo "${USERNAME} ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${USERNAME}
    sudo chmod 0440 /etc/sudoers.d/${USERNAME}
    sudo sed -i 's/Defaults    requiretty/Defaults:${USERNAME}    !requiretty/' /etc/sudoers
    
    while read ip port host pwd param
    do
      addUser root@${ip} ${port} ${USERNAME} ${pwd}
    done < hosts    
    
    cp -r ${PWD}/* ${WORK_DIR}
    su - ${USERNAME} << copyid
      echo "y" | ssh-keygen -t rsa -P '' -f ${WORK_DIR}/.ssh/id_rsa
      cd ~/; sh copy_ssh_id.sh ${USERNAME}
copyid
  fi
  
  rm -f ${CONFIG_PATH}; touch ${CONFIG_PATH}
  while read ip port host pwd param; do
    osname="$(fGetOSName $host)"
    echo "Host ${host}" >> ${CONFIG_PATH}
    echo "  HostName ${host}" >> ${CONFIG_PATH}
    echo "  Port ${port}" >> ${CONFIG_PATH}
    echo "  User ${USERNAME}" >> ${CONFIG_PATH}
    # echo "  IdentifyFile" >> ${CONFIG_PATH}
    if [[ $osname =~ 'centos' ]]; then
      echo "init firewall to ${host} os=$osname"
      ssh -n root@${host} "systemctl stop firewalld; systemctl disable firewalld"
    fi
    if [[ $osname =~ 'ubuntu' ]]; then
      echo "init firewall to ${host} os=$osname"
      ssh -n root@${host} "sudo ufw disable; sudo ufw status"      
    fi
  done < hosts
  chmod 644 ${CONFIG_PATH}

  # while read ip port host pwd param
  # do
    # echo "init firewall to ${host}"
    # addIptables ${host} 6789
    # addIptables ${host} 6800
    # addIptables ${host} 7300
    # addIptables ${host} 7480
    # ssh -n root@${host} "systemctl stop firewalld; systemctl disable firewalld"
    # ssh -n root@${host} "sudo ufw disable; sudo ufw status"
     
    # fSSHInstall ${host} ntp
    # # fSSHInstall ${host} ceph
    # # fSSHInstall ${host} psmisc
    # # ssh -n ${host} "killall -9 yum"
  # done < hosts

  echo "init to ${WORK_DIR} finished" 
}

function install()
{
  host_list=""
  while read ip port host pwd param
  do
    host_list="${host_list} ${host}"

    echo "begin install to ${host}"

    fInstalled ${host} ceph-release
    result=$?
    if [ $result -eq "1" ]; then
      result=`ssh -n ${host} "ceph --version"`
      echo ${result}
    else
      echo "ceph is not installed"

      installstr=""
      if [[ $host =~ 'mon' ]]; then
        installstr="${installstr} --mon"
      fi

      if [[ $host =~ 'mgr' ]]; then
        installstr="${installstr} --mgr"
      fi

      if [[ $host =~ 'mds' ]]; then
        installstr="${installstr} --mds"
      fi

      if [[ $host =~ 'rgw' ]]; then
        installstr="${installstr} --rgw"
      fi

      if [[ $host =~ 'osd' ]]; then
        installstr="${installstr} --osd"
      fi

      echo "install ${host} (${installstr})"
      ceph-deploy install ${host} ${installstr}
      
      # yum clean all
      # rm -rf /etc/yum.repos.d/ceph*
      # repourl=http://mirrors.aliyun.com/ceph/rpm-jewel/el7/
      # gpgurl=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
      # ceph-deploy install ${host} ${installstr} --repo-url=$repourl --gpg-url=$gpgurl
    fi
    echo "${host} is install finished"
  done < hosts
  echo "install ceph (${PWD}) to ${host_list}"
  # ceph-deploy install ${host_list}
}

function uninstall()
{
  host_list=""
  while read ip port host pwd param
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
  CEPH_WORK_DIR=/`whoami`/cluster
  echo "begin deploy to ${CEPH_WORK_DIR}"
  
  host_list=""
  while read ip port host pwd param
  do
    host_list="${host_list} ${host}"
  done < hosts
 
  echo "ceph-deploy (${PWD}) to ${host_list}"

  mkdir $CEPH_WORK_DIR
  cd $CEPH_WORK_DIR

  ceph-deploy new ${host_list}
  echo "public_network = 192.168.1.0/24" >> ceph.conf
  echo "osd_pool_default_size = 2" >> ceph.conf
  
  ceph-deploy --overwrite-conf mon create-initial
  
  while read ip port host pwd param
  do
    if [[ $host =~ 'mon' ]]; then
      echo "deploy admin to ${host}"
      ceph-deploy --overwrite-conf gatherkeys ${host}
      ceph-deploy admin ${host}
    fi
    
    if [[ $host =~ 'rgw' ]]; then
      echo "deploy rgw to ${host}"
      ceph-deploy rgw create ${host}
    fi

    if [[ $host =~ 'osd' ]]; then
      echo "deploy osd to ${host}"
      dev=${param}
      if [ -z "${host}" ] || [ -z "${dev}" ]; then
        echo "missing the parameter"
      else
        ceph-deploy disk zap $host:$dev
        ceph-deploy osd prepare $host:$dev
        ceph-deploy osd activate $host:$dev1

        ceph-deploy disk list $host
      fi
    fi
  done < $SCRIPT_WORK_DIR/hosts
 
  cd $SCRIPT_WORK_DIR
}

#######################################################################

function initmon()
{
  host=${1}

  fSSHInstall ${host} s3cmd
}

function initosd()
{
  host=${1}
  dev=${2}
  CEPH_WORK_DIR=/`whoami`/cluster

  if [ -z "${host}" ] || [ -z "${dev}" ]; then
    echo "missing the parameter"
  else
    echo "init osd ($host,$dev)"
    cd $CEPH_WORK_DIR    
    ceph-deploy --ceph-conf=$CEPH_WORK_DIR/ceph.conf disk zap $host:$dev
    ceph-deploy --ceph-conf=$CEPH_WORK_DIR/ceph.conf osd prepare $host:$dev
    ceph-deploy --ceph-conf=$CEPH_WORK_DIR/ceph.conf osd activate $host:$dev1

    ceph-deploy disk list $host
    cd $SCRIPT_WORK_DIR
  fi
}

#######################################################################

cmd=${1}
param1=${2}
param2=${3}
case $cmd in 
    clean)
      clean ${param1}
    ;;

    init)
      init ${param1}
    ;;

    install)
      install
    ;;

    uninstall)
      uninstall
    ;;
    
    deploy)
      deploy
    ;;

    initosd)
      initosd ${param1} ${param2}
    ;;

    initnode)
      echo "begin init osd..."
      while read ip port host pwd param
      do
      #if [[ $host =~ 'mon' ]]; then
      #  initmon $host
      #else
      if [[ $host =~ 'osd' ]]; then
        initosd $host $param
      fi
      #fi
      done < hosts
    ;;

esac

exit 0;

#######################################################################

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
