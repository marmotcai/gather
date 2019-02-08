
default: help

help:
		echo "use: build-image name=xx tag=xx image=xx"
		echo "    e.g: make build-image name=ubuntu tag=base image=marmotcai/ubuntu-base"
		echo "         make build-image name=centos tag=base image=marmotcai/centos-base"
		echo "         make build-image name=java tag=java image=marmotcai/java"
		echo "         make build-image name=android-sdk tag=android-sdk image=marmotcai/android-sdk"
		echo "         make build-image name=android-ndk tag=android-ndk image=marmotcai/android-ndk"
		echo "         make build-image name=nodejs tag=nodejs image=marmotcai/nodejs"
		echo "         make build-image name=cordova tag=cordova image=marmotcai/cordova"
		echo "         make build-image name=ionic tag=ionic image=marmotcai/ionic"
		echo "         make build-image name=ceph-deploy tag=ceph-deploy image=marmotcai/ceph-deploy"
		echo "use: build project url"
		echo "    e.g: sh make.sh build http://git.atoml.com/taoyang/hangu-epg.git"
		echo "use: test image=xx"
		echo "use: clean"

build-image:

	echo 'build image ('$(name)'-'$(tag)'>>'$(image)')'

	DOCKERFILE_PATH=""

	if [ "$(name)" = "ubuntu" ]; \
		then DOCKERFILE_PATH="./base/Dockerfile-ubuntu-base" make image; fi
	
	if [ "$(name)" = "centos" ]; \
		then DOCKERFILE_PATH="./base/Dockerfile-centos-base" make image; fi

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
	
	if [ "$(name)" = "ceph-deploy" ]; \
		then DOCKERFILE_PATH="./ceph/Dockerfile-ceph-deploy" make image; fi						

image:

	echo $(name) '-' $(tag) '>>' $(image)
	echo $(DOCKERFILE_PATH)

	# docker build --target $(tag) --build-arg CONFIGDIR=./config -t $(image) -f $(DOCKERFILE_PATH) .
	docker build --target $(tag) -t $(image) -f $(DOCKERFILE_PATH) .

test:
	# docker run --rm -ti $(image) /bin/bash
	docker run --rm -ti -v $(shell pwd)/ceph/script:/root/script $(image) /bin/bash	
	
push:

.PHONY: help build-image image test push
.SILENT:
