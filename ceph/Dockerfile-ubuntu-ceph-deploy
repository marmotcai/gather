FROM marmotcai/ubuntu-base AS ceph-deploy
MAINTAINER marmotcai "marmotcai@163.com"

RUN apt-get update && apt-get install -y vim sshpass ceph-deploy --no-install-recommends
RUN rm -rf /var/lib/apt/lists/* && apt-get clean

RUN ceph-deploy --version

ENV WORK_DIR=/root
WORKDIR $WORK_DIR

# ADD ceph/script/entrypoint.sh .
# ENTRYPOINT ["entrypoint.sh"]
