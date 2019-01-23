
default: help

help:
		echo "use: build-image name=xx tag=xx image=xx"
		echo "    e.g: make build-image name=ubuntu tag=base image=atoml/base"
		echo "         make build-image name=java tag=java image=atoml/java"
		echo "         make build-image name=nodejs tag=nodejs image=atoml/nodejs"
		echo "         make build-image name=android tag=android-sdk image=atoml/android-sdk"
		echo "         make build-image name=android tag=android-ndk image=atoml/android-ndk"
		echo "         make build-image name=cordova tag=cordova image=atoml/cordova"
		echo "         make build-image name=ionic tag=ionic image=atoml/ionic"
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

	if [ "$(name)" = "nodejs" ]; \
		then DOCKERFILE_PATH="./base/Dockerfile-nodejs" make image; fi

	if [ "$(name)" = "android" ]; \
		then DOCKERFILE_PATH="./android/Dockerfile-android" make image; fi

	if [ "$(name)" = "cordova" ]; \
		then DOCKERFILE_PATH="./Dockerfile/Dockerfile-cordova-ionic" make image; fi

	if [ "$(name)" = "ionic" ]; \
		then DOCKERFILE_PATH="./Dockerfile/Dockerfile-cordova-ionic" make image; fi						

image:

	echo $(name) '-' $(tag) '>>' $(image)
	echo $(DOCKERFILE_PATH)

	docker build --target $(tag) --build-arg CONFIGDIR=./config -t $(image) -f $(DOCKERFILE_PATH) .

make:

	echo $(SOURCEADDR) '(' $(APPNAME) ')'

	docker build --target default --build-arg SOURCEADDR=$(SOURCEADDR) --build-arg APPNAME=$(APPNAME) -t atoml/project -f ./Dockerfile/Dockerfile-project .
	docker run --rm -ti atoml/project bash

push:

.PHONY: help image make push
.SILENT:
