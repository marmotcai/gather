FROM marmotcai/centos-base AS opencv-base

MAINTAINER marmotcai "marmotcai@163.com"

RUN yum install -y gcc gcc-c++ cmake

ENV WORK_DIR /root
WORKDIR ${WORK_DIR}

ENV OPENCV_URL "https://github.com/opencv/opencv/archive/4.1.0.tar.gz"
ENV OPENCV_CONTRIB_URL "https://github.com/opencv/opencv_contrib/archive/4.1.0.tar.gz"

RUN wget -O ${WORK_DIR}/opencv.tar.gz ${OPENCV_URL} && \
    wget -O ${WORK_DIR}/opencv_contrib.tar.gz ${OPENCV_CONTRIB_URL}

ENV OPENCV_DIR=$WORK_DIR/opencv
ENV OPENCV_CONTRIB_DIR=$WORK_DIR/opencv_contrib

RUN mkdir -p ${OPENCV_DIR} && \
    tar -zxvf ${WORK_DIR}/opencv.tar.gz -C ${OPENCV_DIR} && \
    rm -f ${WORK_DIR}/opencv.tar.gz

RUN mkdir -p ${OPENCV_CONTRIB_DIR} && \
    tar -zxvf ${WORK_DIR}/opencv_contrib.tar.gz -C ${OPENCV_CONTRIB_DIR} && \
    rm -f ${WORK_DIR}/opencv_contrib.tar.gz


WORKDIR ${OPENCV_DIR}

