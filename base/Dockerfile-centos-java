FROM marmotcai/centos-base AS java

MAINTAINER marmotcai "marmotcai@163.com"

ARG PROXY=""

# RUN if [ ${PROXY} = "" ]; then \
ENV ALL_PROXY sock5://${PROXY}
# ;fi
    
RUN yum update -y && yum -y install java-1.8.0-openjdk.x86_64
RUN java -version

