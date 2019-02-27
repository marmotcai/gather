#!/bin/bash

function poweron()
{ 
  VM_NAME=${1}

  #无GUI开机
  vboxmanage startvm ${VM_NAME} --type=headless
}

function poweroff()
{
  VM_NAME=${1}
  
  #关机
  vboxmanage controlvm ${VM_NAME} poweroff
}

function del()
{
  VM_NAME=${1}
  
  #完全删除虚拟机
  vboxmanage unregistervm --delete ${VM_NAME}
}

function createdisk
{
  DISK=${1}
  DISK_SIZE=${2}

  #新建一个虚拟硬盘
  vboxmanage createmedium disk --filename ${DISK} --size ${DISK_SIZE}
  # vboxmanage list hddbackends 
}

function deldisk
{
  DISK=${1}
  vboxmanage closemedium ${DISK} --delete
}

function clone()
{
  SOURCE_DISK=${1}
  TAGET_DISK=${2}
  vboxmanage clonevdi ${SOURCE_DISK} ${TAGET_DISK}
}

function addrawdisk
{ 
  VM_NAME=${1}
  SOURCE_DISK=${2}
  VMDK_FILE=${3}
  
  vboxmanage internalcommands createrawvmdk -filename ${VMDK_FILE} -rawdisk ${SOURCE_DISK}
  vboxmanage storageattach ${VM_NAME} --storagectl "SATA Controller" --port 1 --device 0 --type hdd --medium ${VMDK_FILE}
}

function build()
{
  VM_NAME=${1}
  VRDE_PORT=${2}
  MEMORY_SIZE=${3}
  DISK_FILE=${4}
  ISO_FILE=${5}

  #新建一个虚拟硬盘
  # vboxmanage createmedium disk --filename ${DISK} --size ${DISK_SIZE}

  #新建VirtualBox虚拟机文件（系统类型必须严格按照这个写，否则可能不能安装64位系统）
  vboxmanage createvm --name ${VM_NAME} --ostype "Linux26_64" --register

  #新建SATA磁盘控制器并将上一步新建的磁盘绑定到虚拟机文件
  vboxmanage storagectl ${VM_NAME} --name "SATA Controller" --add sata --controller IntelAHCI
  if [ ! -z "${DISK_FILE}" ];then
    vboxmanage storageattach ${VM_NAME} --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium ${DISK_FILE}
  fi
  # vboxmanage internalcommands createrawvmdk -filename sdb1.vmdk -rawdisk /dev/sdb1
  # vboxmanage storageattach ${VM_NAME} --storagectl "SATA Controller" --port 1 --device 0 --type hdd --medium sdb1.vmdk

  #下载镜像
  #ISO_NAME=CentOS-7-x86_64-DVD-1810.iso
  #ISO_URL=http://mirrors.cn99.com/centos/7.6.1810/isos/x86_64/${ISO_NAME}
  #wget ${ISO_URL}
  #ISO_PATH=${ISO_NAME}

  #新建IDE控制器，设置它为dvd，并绑定ios文件到该dvd，--medium为系统安装文件的iso路径
  vboxmanage storagectl ${VM_NAME} --name "IDE Controller" --add ide
  if [ ! -z "${ISO_FILE}" ];then
    vboxmanage storageattach ${VM_NAME} --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "${ISO_FLIE}"
  fi

  #设置内存(1G)，显存
  vboxmanage modifyvm ${VM_NAME} --memory ${MEMORY_SIZE} --vram 128 --hwvirtex on

  #设置网络方式
  vboxmanage modifyvm ${VM_NAME} --nic1 bridged --bridgeadapter1 eno1

  #设置IO
  vboxmanage modifyvm ${VM_NAME} --ioapic on

  #设置启动项
  vboxmanage modifyvm ${VM_NAME} --boot1 disk --boot2 dvd --boot3 none --boot4 none

  #打开VRDE功能
  vboxmanage modifyvm ${VM_NAME} --vrde on

  #修改端口
  vboxmanage modifyvm ${VM_NAME} --vrdeport ${VRDE_PORT} --vrdeaddress 0.0.0.0

  #无GUI开机
  poweron ${VM_NAME}  

  #查看系统信息
  #vboxmanage showvminfo ${VM_NAME}
}

function install()
{
  sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" >> /etc/apt/sources.list.d/virtualbox.list'
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add

  sudo apt -y update
  sudo apt -y install virtualbox-5.2 --allow-unauthenticated
  vboxmanage --version

  wget http://download.virtualbox.org/virtualbox/5.2.2/Oracle_VM_VirtualBox_Extension_Pack-5.2.2-119230.vbox-extpack
  vboxmanage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-5.2.2-119230.vbox-extpack
  vboxmanage list extpacks

  vboxmanage setproperty vrdeextpack "Oracle VM VirtualBox Extension Pack"
  rm -f Oracle_VM_VirtualBox_Extension_Pack-5.2.2-119230.vbox-extpack
}

function uninstall()
{
  vboxmanage extpack uninstall --force "Oracle VM VirtualBox Extension Pack" 
  vboxmanage extpack cleanup
  sudo apt remove -y virtualbox-5.2
  rm -f /etc/apt/sources.list.d/virtualbox.list
}

cmd=${1}
param1=${2}
param2=${3}
param3=${4}
param4=${5}
param5=${6}
param6=${7}

case $cmd in
    build)
      build ${param1} ${param2} ${param3} ${param4} ${param5}
    ;;

    buildok)
      VM_NAME=${param1}
      #安装完成后弹出系统安装镜像
      vboxmanage storageattach ${VM_NAME} --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium none
    ;;

    del)
      poweroff ${param1}
      del ${param1}
    ;;

    poweron)
      poweron ${param1}
    ;;

    poweroff)
      poweroff ${param1}
    ;;

    list)
      #查看所有虚拟机
      echo "all vms:"
      vboxmanage list vms

      #查看运行中的虚拟机
      echo "running vms:"
      vboxmanage list runningvms
    ;;

    createdisk)
      #新建一个虚拟硬盘
      createdisk ${param1} ${param2}
    ;;
    deldisk)
      #删除一个虚拟硬盘
      deldisk ${param1}
    ;;

    clone)
      clone ${param1} ${param2}
    ;;

    addrawdisk)
      addrawdisk ${param1} ${param2} ${param3}
    ;;

    install)
      install
    ;;

    uninstall)
      uninstall
    ;;

    *) 
        echo "use: sh build.sh build vm_name vrde_port memory_size disk_file (iso_file)"
        echo "     e.g: sh build.sh build centos-01 3301 4096 centos-02-disk0.vdi CentOS-7-x86_64-DVD-1810.iso"
        echo "     e.g: sh build.sh build centos-01 3301 4096 centos-02-disk0.vdi"
        echo "use: sh build.sh buildok vm_name"
        echo "use: sh build.sh del vm_name"
        echo "use: sh build.sh poweron vm_name"
        echo "use: sh build.sh poweroff vm_name"
        echo "use: sh build.sh list vm_name"
        echo "use: sh build.sh createdisk disk_file disk_size"
        echo "use: sh build.sh deldisk disk_file"
        echo "use: sh build.sh clone source_file target_file"
        echo "use: sh build.sh addrawdisk vm_name source_disk vmdk_file"
        echo "use: sh build.sh install"
        echo "use: sh build.sh uninstall"
        exit 1;
    ;;
    
esac

exit 0;




