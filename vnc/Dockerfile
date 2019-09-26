FROM marmotcai/ubuntu-base AS vnc

MAINTAINER marmotcai "marmotcai@163.com"

RUN apt-get update && \
    apt-get install -y vnc4server net-tools && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN vnc4server

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
