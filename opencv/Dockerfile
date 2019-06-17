FROM marmotcai/centos-base AS SDE

MAINTAINER marmotcai "marmotcai@163.com"

###############################################################

RUN yum install -y gperf bison flex texinfo help2man gcc gcc-c++ make kernel-devel expat-devel patch ncurses-devel automake bzip2 unzip file libtool

###############################################################

ENV WORK_DIR /root
ENV PATH $PATH:${WORK_DIR}/cmake-3.14.5-Linux-x86_64/bin

###############################################################

ENV CMAKE_URL "https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5-Linux-x86_64.tar.gz"

RUN wget -O ${WORK_DIR}/cmake.tar.gz ${CMAKE_URL} && \
    tar -zxvf ${WORK_DIR}/cmake.tar.gz -C ${WORK_DIR} && \
    rm -f ${WORK_DIR}/cmake.tar.gz

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

RUN ct-ng list-samples && \
    cd ${CROSSTOOL_SRC_PATH} && \
    ct-ng armv8-rpi3-linux-gnueabihf
#     ct-ng armv6-rpi-linux-gnueabi
#     ct-ng arm-unknown-linux-gnueabi
#     ct-ng x86_64-centos7-linux-gnu
# RUN wget -O ${CROSSTOOL_SRC_PATH}/.config https://raw.githubusercontent.com/marmotcai/gather/master/opencv/crosstool-ng.config

RUN sed -i 's/# CT_EXPERIMENTAL is not set/CT_EXPERIMENTAL=y/g' .config
RUN sed -i '/CT_EXPERIMENTAL=y/a\CT_ALLOW_BUILD_AS_ROOT_SURE=y' .config
RUN sed -i '/CT_EXPERIMENTAL=y/a\CT_ALLOW_BUILD_AS_ROOT=y' .config

RUN ct-ng build

###############################################################

FROM SDE AS opencv-base

MAINTAINER marmotcai "marmotcai@163.com"

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

RUN echo ”set(PREFIX x86_64-centos7-linux-gnu)“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”set(X_TOOLS /root/x-tools/${PREFIX})“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”set(CMAKE_SYSTEM_NAME Linux)“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”set(CMAKE_SYSTEM_PROCESSOR arm)“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”SET(CMAKE_C_COMPILER ${X_TOOLS}/bin/${PREFIX}-gcc)“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”SET(CMAKE_CXX_COMPILER ${X_TOOLS}/bin/${PREFIX}-g++)“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”SET(CMAKE_FIND_ROOT_PATH ${X_TOOLS})“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake
RUN echo ”“ >> ${OPENCV_DIR}/arm_cross_toolchain.cmake

RUN mkdir -p ${OPENCV_DIR}/build && \
    cmake -DOPENCV_EXTRA_MODULES_PATH=${OPENCV_DIR}/opencv_contrib-4.1.0/modules ${OPENCV_DIR}/opencv-4.1.0/ -B ${OPENCV_DIR}/build -D CMAKE_TOOLCHAIN_FILE=${OPENCV_DIR}/arm_cross_toolchain.cmake

WORKDIR ${WORK_DIR}


CMD /usr/sbin/sshd -D
