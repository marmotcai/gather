#!/bin/bash

yum install -y gcc gcc-c++ wget

sed -i '$a\export WORK_DIR=/root' /etc/profile
sed -i '$a\export GOROOT_BOOTSTRAP=/root/bootstrap/go' /etc/profile
sed -i '$a\export GOROOT=/root/go' /etc/profile
sed -i '$a\export GOPATH=/root/mygo' /etc/profile
sed -i '$a\export GOBIN=/root/mygo/bin' /etc/profile
sed -i '$a\export PATH=$PATH:/root/go/bin:/root/mygo/bin' /etc/profile
source /etc/profile

BOOTSTRAP_URL="https://dl.google.com/go/go1.4.3.linux-amd64.tar.gz"
GOLANG_URL="https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz"

wget -O ${WORK_DIR}/bootstrap.tar.gz ${BOOTSTRAP_URL}
wget -O ${WORK_DIR}/go.tar.gz ${GOLANG_URL}

mkdir -p ${GOROOT_BOOTSTRAP_DIR}
tar -zxvf ${WORK_DIR}/bootstrap.tar.gz -C /root/bootstrap
rm -f ${WORK_DIR}/bootstrap.tar.gz

cd ${GOROOT_BOOTSTRAP_DIR}/go/src/
./make.bash

RUN mkdir -p ${GOROOT}
tar -zxvf ${WORK_DIR}/go.tar.gz -C ${WORK_DIR}
rm -f ${WORK_DIR}/go.tar.gz

cd $GOROOT/src/
./make.bash

go get -u -v github.com/golang/dep/cmd/dep
go get -u -v github.com/gpmgo/gopm
go get -u -v github.com/kardianos/govendor
go get -u -v github.com/tools/godep

#wget -O $GOBIN/goenv https://raw.githubusercontent.com/marmotcai/gather/master/golang/goenv.sh
#chmod +x $GOBIN/goenv
#goenv init

