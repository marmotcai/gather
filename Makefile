
default: help

help:
		echo "use: build-image name=xx tag=xx image=xx"
		echo "    e.g: make build-image name=ubuntu tag=base image=marmotcai/base"
		echo "         make build-image name=java tag=java image=marmotcai/java"
		echo "         make build-image name=android-sdk tag=android-sdk image=marmotcai/android-sdk"
		echo "         make build-image name=android-ndk tag=android-ndk image=marmotcai/android-ndk"
		echo "         make build-image name=nodejs tag=nodejs image=marmotcai/nodejs"
		echo "         make build-image name=cordova tag=cordova image=marmotcai/cordova"
		echo "         make build-image name=ionic tag=ionic image=marmotcai/ionic"
		echo "use: build project url"
		echo "    e.g: sh make.sh build http://git.atoml.com/taoyang/hangu-epg.git"
		echo "use: test imagename"
		echo "use: clean"

build-image:

	echo 'build image ('$(name)'-'$(tag)'>>'$(image)')'

	DOCKERFILE_PATH=""

	if [ "$(name)" = "ubuntu" ]; \
		then DOCKERFILE_PATH="./base/Dockerfile-ubuntu-base" make image; fi

	if [ "$(name)" = "java" ]; \
		then DOCKERFILE_PATH="./base/Dockerfile-java" make image; fi

	if [ "$(name)" = "android-sdk" ]; \
		then DOCKERFILE_PATH="./android/Dockerfile-sdk" make image; fi

	if [ "$(name)" = "android-ndk" ]; \
		then DOCKERFILE_PATH="./android/Dockerfile-ndk" make image; fi

	if [ "$(name)" = "nodejs" ]; \
		then DOCKERFILE_PATH="./cordova/Dockerfile-cordova" make image; fi

	if [ "$(name)" = "cordova" ]; \
		then DOCKERFILE_PATH="./cordova/Dockerfile-cordova" make image; fi

	if [ "$(name)" = "ionic" ]; \
		then DOCKERFILE_PATH="./cordova/Dockerfile-ionic" make image; fi						

image:

	echo $(name) '-' $(tag) '>>' $(image)
	echo $(DOCKERFILE_PATH)

	docker build --target $(tag) --build-arg CONFIGDIR=./config -t $(image) -f $(DOCKERFILE_PATH) .

make:

	# docker run --rm -ti -v $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/script:/opt/script marmotcai/cordova /bin/bash

push:

.PHONY: help build-image image make push
.SILENT:
