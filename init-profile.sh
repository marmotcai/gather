#!/bin/bash

userpath=~
envfile="$userpath/.bash_profile"
if [ ! -z "${2}" ];then
  envfile=${2}
fi

case ${1} in
    init)
      echo "write config to $envfile"

      if [ ! -f "$envfile" ]; then
        touch $envfile
      fi

      ######################################################################
      
      echo "#############################" >> $envfile

      WORK_DIR=$userpath
      WORKSPACE=$WORK_DIR/workspace

      echo "export WORK_DIR=$WORK_DIR" >> $envfile
      echo "export WORKSPACE=$WORKSPACE" >> $envfile

      echo "#############################\n" >> $envfile
      
      ######################################################################
      
      BOOTSTRAP_URL="https://dl.google.com/go/go1.4.3.linux-amd64.tar.gz"
      GOLANG_URL="https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz"

      echo "##### my golang profile #####" >> $envfile

      echo "export BOOTSTRAP_URL=\"$BOOTSTRAP_URL\"" >> $envfile
      echo "export GOLANG_URL=\"$BOOTSTRAP_URL\"" >> $envfile
      echo "export GOROOT_BOOTSTRAP_DIR=$WORK_DIR/bootstrap" >> $envfile
      echo "export GOROOT=$WORK_DIR/go" >> $envfile
      echo "export GOPATH=$WORK_DIR/mygo" >> $envfile
      echo "export GOBIN=$GOPATH/bin" >> $envfile
      echo "export PATH=$PATH:$GOROOT/bin:$GOBIN" >> $envfile
    
      echo "export GOARCH=amd64" >> $envfile
      echo "export GOOS=linux" >> $envfile
      echo "export CGO_ENABLE=0" >> $envfile

      echo "export GO111MODULE=on" >> $envfile

      echo "#############################\n" >> $envfile

      ######################################################################

      echo "##### my adnroid profile #####" >> $envfile

      echo "export ANDROID_HOME=$WORK_DIR/Android/sdk" >> $envfile

      echo "#############################\n" >> $envfile

      ######################################################################

      echo "##### my key profile #####" >> $envfile
      echo "export ACCESSKEY=LTAIOYPor6F0ddr0" >> $envfile
      echo "export SECRETKEY=zgKJdR8ChMaxdjCXv7vaKBZXxy6XS1" >> $envfile

      echo "export MINIO_ACCESS_KEY=4V1cweFJGTlhjM2hOUkVGM1RVUm9RV0l5U25GYVYwNHdURmhLTTA5WE9WcE5Wa1U5PNJI" >> $envfile
      echo "export MINIO_SECRET_KEY=4WVRGQ01GWklVak50VWpGamMyWmFZV014Y0ZWbFFUMDk=qEyE" >> $envfile
      
      echo "#############################\n" >> $envfile

      ######################################################################

      echo "##### my other profile #####" >> $envfile

      echo "alias ll='ls -l'" >> $envfile
      echo "alias vb='vim ~/.bash_profile && . ~/.bash_profile'" >> $envfile
      echo "alias gs='cd $GOPATH/src'" >> $envfile
      echo "alias ms='cd $WORK_DIR'" >> $envfile
      echo "alias ws='cd $WORKSPACE'" >> $envfile

      echo "#############################\n" >> $envfile

      ######################################################################

      echo "##### my cloud server profile #####" >> $envfile

      # 亚马逊
      echo "alias aws='ssh root@ec2-52-194-224-109.ap-northeast-1.compute.amazonaws.com'" >> $envfile

      # 阿里云 18607171301
      echo "alias atoml.com='ssh -p 3022 root@atoml.com'" >> $envfile
      echo "alias atomcloud.net='ssh -p 3022 root@atomcloud.net'" >> $envfile

      # *.home.atoml.com
      echo "alias home.ssh.host='ssh -p 3120 root@atoml.com'" >> $envfile
      echo "alias home.ssh.qts='ssh -p 3162 admin@atoml.com'" >> $envfile
      echo "alias home.ssh.dsm='ssh -p 3172 admin@atoml.com'" >> $envfile
      echo "alias home.ssh.ubuntu='ssh -p 3182 root@atoml.com'" >> $envfile

      # *.work.atoml.com
      echo "alias work.ssh.ubuntu='ssh -p 3232 root@atoml.com'" >> $envfile
      echo "alias work.ssh.lede='ssh -p 3233 root@atoml.com'" >> $envfile

      # 阿里云 伊莱维特
      echo "alias elevate='ssh root@39.98.199.40'" >> $envfile

      # 阿里云 海成
      echo "alias haictech.com='ssh root@haictech.com'" >> $envfile
      echo "alias admin.haictech.com='ssh root@admin.haictech.com'" >> $envfile

      # 阿里云 畅观
      echo "alias 01.cvideo.pro='ssh root@01.cvideo.pro'" >> $envfile
      echo "alias 02.cvideo.pro='ssh root@02.cvideo.pro'" >> $envfile

      echo "#############################\n" >> $envfile

      ######################################################################

    ;;
    
    .) 
      . $envfile
    ;;

    *)
      echo "use: sh init-profile.sh init ~/.bash_profile"
    ;;

esac

