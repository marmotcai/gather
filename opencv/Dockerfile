FROM marmotcai/crosstool AS opencv

MAINTAINER marmotcai "marmotcai@163.com"

ARG CROSSTOOL_PREFIX="arm-unknown-linux-uclibcgnueabi"

ENV WORK_DIR /root

###############################################################

ENV PATH $PATH:${WORK_DIR}/cmake-3.14.5-Linux-x86_64/bin
ENV CMAKE_URL "https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5-Linux-x86_64.tar.gz"

RUN wget -O ${WORK_DIR}/cmake.tar.gz ${CMAKE_URL} && \
    tar -zxvf ${WORK_DIR}/cmake.tar.gz -C ${WORK_DIR} && \
    rm -f ${WORK_DIR}/cmake.tar.gz

###############################################################

ENV OPENCV2_URL "https://github.com/opencv/opencv/archive/2.4.13.6.tar.gz"

RUN wget -O ${WORK_DIR}/opencv.tar.gz ${OPENCV2_URL}

ENV OPENCV2_DIR=$WORK_DIR/opencv2

RUN mkdir -p ${OPENCV2_DIR}

RUN tar -zxvf ${WORK_DIR}/opencv.tar.gz -C ${OPENCV2_DIR} && \
    rm -f ${WORK_DIR}/opencv.tar.gz
    
###############################################################

ENV OPENCV3_URL "https://github.com/opencv/opencv/archive/3.4.6.tar.gz"
ENV OPENCV3_CONTRIB_URL "https://github.com/opencv/opencv_contrib/archive/3.4.6.tar.gz"

RUN wget -O ${WORK_DIR}/opencv.tar.gz ${OPENCV3_URL} && \
    wget -O ${WORK_DIR}/opencv_contrib.tar.gz ${OPENCV3_CONTRIB_URL}

ENV OPENCV3_DIR=$WORK_DIR/opencv3

RUN mkdir -p ${OPENCV3_DIR}

RUN tar -zxvf ${WORK_DIR}/opencv.tar.gz -C ${OPENCV3_DIR} && \
    rm -f ${WORK_DIR}/opencv.tar.gz
    
RUN tar -zxvf ${WORK_DIR}/opencv_contrib.tar.gz -C ${OPENCV3_DIR} && \
    rm -f ${WORK_DIR}/opencv_contrib.tar.gz

###############################################################

ENV OPENCV4_URL "https://github.com/opencv/opencv/archive/4.1.0.tar.gz"
ENV OPENCV4_CONTRIB_URL "https://github.com/opencv/opencv_contrib/archive/4.1.0.tar.gz"

RUN wget -O ${WORK_DIR}/opencv.tar.gz ${OPENCV4_URL} && \
    wget -O ${WORK_DIR}/opencv_contrib.tar.gz ${OPENCV4_CONTRIB_URL}

ENV OPENCV4_DIR=$WORK_DIR/opencv4

RUN mkdir -p ${OPENCV4_DIR}

RUN tar -zxvf ${WORK_DIR}/opencv.tar.gz -C ${OPENCV4_DIR} && \
    rm -f ${WORK_DIR}/opencv.tar.gz
    
RUN tar -zxvf ${WORK_DIR}/opencv_contrib.tar.gz -C ${OPENCV4_DIR} && \
    rm -f ${WORK_DIR}/opencv_contrib.tar.gz

###############################################################

RUN echo ${CROSSTOOL_PREFIX}

RUN wget -O ${CROSSTOOL_SRC_PATH}/cross_toolchain.cmake https://raw.githubusercontent.com/marmotcai/gather/master/opencv/cross_toolchain.cmake
RUN sed -i '1 i\set(PREFIX '"${CROSSTOOL_PREFIX}"')' ${CROSSTOOL_SRC_PATH}/cross_toolchain.cmake

WORKDIR ${OPENCV_DIR}/build

#RUN mkdir -p ${OPENCV_DIR}/build && \
#    cmake -DOPENCV_EXTRA_MODULES_PATH=${OPENCV_DIR}/opencv_contrib-4.1.0/modules ${OPENCV_DIR}/opencv-4.1.0/ -B ${OPENCV_DIR}/build \
#    -DCMAKE_TOOLCHAIN_FILE=${CROSSTOOL_SRC_PATH}/cross_toolchain.cmake -DBUILD_EXAMPLES=ON
# -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_SHARED_LIBS=OFF -DBUILD_SHARED_LIBS=NO
#   cmake ${OPENCV_DIR}/opencv-4.1.0/ -B ${OPENCV_DIR}/build -D CMAKE_TOOLCHAIN_FILE=${CROSSTOOL_SRC_PATH}/cross_toolchain.cmake -DCMAKE_OSX_ARCHITECTURES=x86_64

# RUN make -j5 && make install

# CMD /usr/sbin/sshd -D
