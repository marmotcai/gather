FROM marmotcai/ubuntu-base AS crosstool

ARG CROSSTOOL_PREFIX="armv7-rpi2-linux-gnueabihf"

MAINTAINER marmotcai "marmotcai@163.com"

RUN echo ${CROSSTOOL_PREFIX}

ENV WORK_DIR /root

###############################################################

RUN apt update -y && apt upgrade -y

RUN apt install -y binutils unzip bison flex patch texinfo autoconf automake make gcc g++ m4 bzip2 libncurses5-dev libtool libtool-bin gperf help2man gawk xz-utils python3.5 python3.5-dev

RUN # rm /usr/bin/python
RUN ln -s /usr/bin/python3.5 /usr/bin/python
RUN python --version

###############################################################

ENV CROSSTOOL_URL "https://github.com/crosstool-ng/crosstool-ng/archive/crosstool-ng-1.24.0.tar.gz"
ENV CROSSTOOL_SRC_PATH ${WORK_DIR}/crosstool-ng

RUN wget -O ${WORK_DIR}/crosstool-ng.tar.gz ${CROSSTOOL_URL} && \
    tar -zxvf ${WORK_DIR}/crosstool-ng.tar.gz -C ${WORK_DIR} && \
    mv ${WORK_DIR}/crosstool-ng-crosstool-ng-1.24.0 ${CROSSTOOL_SRC_PATH} && \
    rm -f ${WORK_DIR}/crosstool-ng.tar.gz

WORKDIR ${CROSSTOOL_SRC_PATH}
RUN ./bootstrap && \
    ./configure --prefix=/usr/local/crosstool-ng && \
    make && \
    make install && \
    ln -s  /usr/local/crosstool-ng/bin/ct-ng /usr/local/bin/ct-ng

# ENV CROSSTOOL_PREFIX "armv6-rpi-linux-gnueabi"

RUN ct-ng list-samples && \
    cd ${CROSSTOOL_SRC_PATH} && \
    ct-ng ${CROSSTOOL_PREFIX}

RUN sed -i 's/# CT_EXPERIMENTAL is not set/CT_EXPERIMENTAL=y/g' .config
RUN sed -i '/CT_EXPERIMENTAL=y/a\CT_ALLOW_BUILD_AS_ROOT_SURE=y' .config
RUN sed -i '/CT_EXPERIMENTAL=y/a\CT_ALLOW_BUILD_AS_ROOT=y' .config

RUN ct-ng build

###############################################################
