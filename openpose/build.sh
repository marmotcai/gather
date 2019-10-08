#! /sbin/bash
# From Luo Xin
# Email: kingsleyluoxin@hotmail.com

sudo tee /etc/apt/sources.list <<EOF
deb http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF

sudo add-apt-repository ppa:graphics-drivers/ppa

wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get update
sudo apt-get install typora

sudo ubuntu-drivers autoinstall

sudo apt install vim exfat-fuse exfat-utils unrar  p7zip-full p7zip-rar rar unzip gnome-tweak-tool gnome-shell-extensions chrome-gnome-shell gtk2-engines-pixbuf libxml2-utils build-essential gcc-4.8 gcc-4.8-multilib g++-4.8 g++-4.8-multilib gcc-5 gcc-5-multilib g++-5 g++-5-multilib gcc-6 gcc-6-multilib g++-6 g++-6-multilib gcc-7 gcc-7-multilib g++-7 g++-7-multilib curl terminator -y

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 40 
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70

sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 40
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 50
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 60
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 70

sudo apt-get install -y --no-install-recommends gnupg2 curl ca-certificates

curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add -

echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list

echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

CUDA_VERSION=10.0.130
CUDA_PKG_VERSION=10-0=$CUDA_VERSION-1
NCCL_VERSION=2.3.5
CUDNN_VERSION=7.3.1.20

apt-get update
apt-get install -y --no-install-recommends cuda-cudart-$CUDA_PKG_VERSION cuda-compat-10-0=410.48-1

apt-get install -y --no-install-recommends cuda-libraries-$CUDA_PKG_VERSION cuda-nvtx-$CUDA_PKG_VERSION libnccl2=$NCCL_VERSION-2+cuda10.0

apt-mark hold libnccl2

apt-get install -y --no-install-recommends libcudnn7=$CUDNN_VERSION-1+cuda10.0

apt-mark hold libcudnn7

apt-get install -y --no-install-recommends cuda-libraries-dev-$CUDA_PKG_VERSION cuda-nvml-dev-$CUDA_PKG_VERSION cuda-minimal-build-$CUDA_PKG_VERSION cuda-command-line-tools-$CUDA_PKG_VERSION libnccl-dev=$NCCL_VERSION-2+cuda10.0

apt-get install -y --no-install-recommends libcudnn7=$CUDNN_VERSION-1+cuda10.0 libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0

apt-mark hold libcudnn7

apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

apt-get update

apt-get install -y docker-ce

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
apt-get install -y nvidia-docker2 nvidia-container-runtime

sudo pkill -SIGHUP dockerd
sudo groupadd docker
sudo gpasswd -a ${USER} docker


sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF

sudo pkill -SIGHUP dockerd

sudo add-apt-repository ppa:webupd8team/atom  
sudo apt update  
sudo apt install atom -y

sudo apt install typora -y

sudo apt install shadowsocks-libev proxychains -y

sudo tee /etc/shadowsocks-libev/config.json << EOF
{
    "server": "server",
    "server_port": 1234,
    "local_port": 1080,
    "password": "password",
    "method": "method"
}
EOF

sudo tee /etc/proxychains.conf << EOF
# proxychains.conf  VER 3.1
#
#        HTTP, SOCKS4, SOCKS5 tunneling proxifier with DNS.
#	

# The option below identifies how the ProxyList is treated.
# only one option should be uncommented at time,
# otherwise the last appearing option will be accepted
#
#dynamic_chain
#
# Dynamic - Each connection will be done via chained proxies
# all proxies chained in the order as they appear in the list
# at least one proxy must be online to play in chain
# (dead proxies are skipped)
# otherwise EINTR is returned to the app
#
strict_chain
#
# Strict - Each connection will be done via chained proxies
# all proxies chained in the order as they appear in the list
# all proxies must be online to play in chain
# otherwise EINTR is returned to the app
#
#random_chain
#
# Random - Each connection will be done via random proxy
# (or proxy chain, see  chain_len) from the list.
# this option is good to test your IDS :)

# Make sense only if random_chain
#chain_len = 2

# Quiet mode (no output from library)
#quiet_mode

# Proxy DNS requests - no leak for DNS data
proxy_dns 

# Some timeouts in milliseconds
tcp_read_time_out 15000
tcp_connect_time_out 8000

# ProxyList format
#       type  host  port [user pass]
#       (values separated by 'tab' or 'blank')
#
#
#        Examples:
#
#            	socks5	192.168.67.78	1080	lamer	secret
#		http	192.168.89.3	8080	justu	hidden
#	 	socks4	192.168.1.49	1080
#	        http	192.168.39.93	8080	
#		
#
#       proxy types: http, socks4, socks5
#        ( auth types supported: "basic"-http  "user/pass"-socks )
#
[ProxyList]
# add proxy here ...
# meanwile
# defaults set to "tor"
socks5 	127.0.0.1 1080
EOF
sudo tee /lib/systemd/system/shadowsocks-libev.service  << EOF
#  This file is part of shadowsocks-libev.
#
#  Shadowsocks-libev is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#
#  This file is default for Debian packaging. See also
#  /etc/default/shadowsocks-libev for environment variables.

[Unit]
Description=Shadowsocks-libev Default Server Service
Documentation=man:shadowsocks-libev(8)
After=network.target

[Service]
Type=simple
EnvironmentFile=/etc/default/shadowsocks-libev
User=nobody
Group=nogroup
LimitNOFILE=32768
ExecStart=/usr/bin/ss-local -c \$CONFFILE \$DAEMON_ARGS 

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo service shadowsocks-libev restart

sudo tee /usr/bin/proxychains << EOF
#!/bin/sh
echo "ProxyChains-3.1 (http://proxychains.sf.net)"                                        
if [ \$# = 0 ] ; then
        echo "  usage:"
        echo "          proxychains <prog> [args]"
        exit
fi
export LD_PRELOAD=$(find /usr/ -name libproxychains.so.3 -print)
exec "\$@"
EOF
