#!/bin/bash
#file:docker_install.sh
 
function docker_install()
{
  echo "检查Docker......"
  docker -v
  if [ $? -eq  0 ]; then
    echo "检查到Docker已安装!"
  else
    echo "安装docker环境..."
    curl -fsSL https://get.daocloud.io/docker | sh
    echo "安装docker环境...安装完成!"
    systemctl start docker
    systemctl enable docker
    docker info
  fi
  # 创建公用网络==bridge模式
  #docker network create share_network
}
# 执行函数
docker_install
