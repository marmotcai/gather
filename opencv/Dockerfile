FROM marmotcai/crosstool AS opencv

MAINTAINER marmotcai "marmotcai@163.com"

ARG CROSSTOOL_PREFIX="armv7-rpi2-linux-gnueabihf"

ENV WORK_DIR /root

###############################################################

ENV PATH $PATH:${WORK_DIR}/cmake-3.14.5-Linux-x86_64/bin
ENV CMAKE_URL "https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5-Linux-x86_64.tar.gz"

RUN wget -O ${WORK_DIR}/cmake.tar.gz ${CMAKE_URL} && \
    tar -zxvf ${WORK_DIR}/cmake.tar.gz -C ${WORK_DIR} && \
    rm -f ${WORK_DIR}/cmake.tar.gz

###############################################################

ENV OPENCV_URL "https://github.com/opencv/opencv/archive/4.1.0.tar.gz"
ENV OPENCV_CONTRIB_URL "https://github.com/opencv/opencv_contrib/archive/4.1.0.tar.gz"

RUN wget -O ${WORK_DIR}/opencv.tar.gz ${OPENCV_URL} && \
    wget -O ${WORK_DIR}/opencv_contrib.tar.gz ${OPENCV_CONTRIB_URL}

ENV OPENCV_DIR=$WORK_DIR/opencv

RUN mkdir -p ${OPENCV_DIR}

RUN tar -zxvf ${WORK_DIR}/opencv.tar.gz -C ${OPENCV_DIR} && \
    rm -f ${WORK_DIR}/opencv.tar.gz
    
RUN tar -zxvf ${WORK_DIR}/opencv_contrib.tar.gz -C ${OPENCV_DIR} && \
    rm -f ${WORK_DIR}/opencv_contrib.tar.gz

RUN echo ${CROSSTOOL_PREFIX}

RUN wget -O ${CROSSTOOL_SRC_PATH}/cross_toolchain.cmake https://raw.githubusercontent.com/marmotcai/gather/master/opencv/cross_toolchain.cmake
RUN sed -i '1 i\set(PREFIX '"${CROSSTOOL_PREFIX}"')' ${CROSSTOOL_SRC_PATH}/cross_toolchain.cmake

RUN mkdir -p ${OPENCV_DIR}/build && \
     cmake ${OPENCV_DIR}/opencv-4.1.0/ -B ${OPENCV_DIR}/build -D CMAKE_TOOLCHAIN_FILE=${CROSSTOOL_SRC_PATH}/cross_toolchain.cmake
#    cmake -DOPENCV_EXTRA_MODULES_PATH=${OPENCV_DIR}/opencv_contrib-4.1.0/modules ${OPENCV_DIR}/opencv-4.1.0/ -B ${OPENCV_DIR}/build -D CMAKE_TOOLCHAIN_FILE=${CROSSTOOL_SRC_PATH}/cross_toolchain.cmake

WORKDIR ${OPENCV_DIR}/build

RUN make && make install

# CMD /usr/sbin/sshd -D
