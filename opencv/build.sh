#!/bin/bash

if [ -z "${1}" ];then
    echo "use: sh build.sh opencv_path"
    exit 0
fi

export OPENCV_DIR=${1}/opencv-4.1.0
export OPENCV_CONTRID_DIR=${1}/opencv_contrib-4.1.0/modules
export OPENCV_BUILD_DIR=${1}/build

if [ ! -d ${OPENCV_DIR} ]; then
    echo "can't find opencv: " ${OPENCV_DIR}
    exit 0
fi

if [ ! -d ${OPENCV_CONTRID_DIR} ]; then
    echo "can't find opencv_contrib: " ${OPENCV_CONTRID_DIR}
    exit 0
fi

if [ ! -d ${OPENCV_BUILD_DIR} ]; then
    mkdir -p ${OPENCV_BUILD_DIR}
fi

echo "-- opencv path: " ${OPENCV_DIR}
echo "-- opencv_contrib path: " ${OPENCV_CONTRID_DIR}
echo "-- opencv build path: " ${OPENCV_BUILD_DIR} 

cmake ${OPENCV_DIR} -DOPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRID_DIR} -DBUILD_EXAMPLES=ON -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_SHARED_LIBS=OFF

exit 0;
