#!/bin/bash

cmd=${1}
case $cmd in 
    clean)

    ;;

    build-image) 
        echo 'build image ...'
        make build-image DOCKERNAME=${2} DOCKERTAG=${3} DOCKERIMAGENAME=${4}
    ;;

    build)
        echo 'make project'

        URL=${2}

        appname=${URL##*/}
        appname=${appname%%.*}
        appname=${appname%%-*}

        # if [ ! -f $configdir/$appname-key.keystore ]
        # then
        #     keytool -genkey -keystore $configdir/$appname-key.keystore -alias $appname -storepass ${appname}123456 -keypass ${appname}123456 -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=localhost, OU=localhost, O=localhost, L=SH, ST=SH, C=CN"
        # fi

        make make SOURCEADDR=${URL} APPNAME=${appname}
    ;;

    test)
        echo 'test image ...'
        docker run --rm -ti ${2} bash
    ;;

    *) 
        echo "use: build-image name tag imagename(Co.,/image)"
        echo "    e.g: sh make.sh build-image ubuntu base atoml/base"
        echo "         sh make.sh build-image java java atoml/java"
        echo "         sh make.sh build-image android android-sdk atoml/android-sdk"
        echo "         sh make.sh build-image android android-ndk atoml/android-ndk"
        echo "         sh make.sh build-image nodejs nodejs atoml/android-nodejs"
        echo "         sh make.sh build-image cordova cordova atoml/cordova"
        echo "         sh make.sh build-image ionic ionic atoml/ionic"
        echo "use: build project url"
        echo "    e.g: sh make.sh build http://git.atoml.com/taoyang/hangu-epg.git"
        echo "use: test imagename"
        echo "use: clean"
        exit 1;
    ;;
esac

exit 0;
