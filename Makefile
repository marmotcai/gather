
default: help

help:
		echo "use: make build-image name=xx tag=xx image=xx"
		echo "    e.g: make build-image name=ubuntu tag=base image=marmotcai/ubuntu-base"
		echo "         make build-image name=centos tag=base image=marmotcai/centos-base"
		echo "         make build-image name=ubuntu-java tag=java image=marmotcai/ubuntu-java"
		echo "         make build-image name=centos-java tag=java image=marmotcai/centos-java"
		echo "         make build-image name=android-sdk tag=android-sdk image=marmotcai/android-sdk"
		echo "         make build-image name=android-ndk tag=android-ndk image=marmotcai/android-ndk"
		echo "         make build-image name=nodejs tag=nodejs image=marmotcai/nodejs"
		echo "         make build-image name=cordova tag=cordova image=marmotcai/cordova"
		echo "         make build-image name=ionic tag=ionic image=marmotcai/ionic"
		echo "         make build-image name=ceph-deploy tag=ceph-deploy image=marmotcai/ceph-deploy"
		echo "         make build-image name=golang tag=golang-base image=marmotcai/golang"
		echo "         make build-image name=golang-arm tag=golang-base image=marmotcai/golang-arm"
		echo "         make build-image name=go-mediainfo tag=go-mediainfo image=marmotcai/go-mediainfo"
		echo "         make build-image name=s3cmd tag=s3cmd image=marmotcai/s3cmd"
		echo "         make build-image name=mysql tag=mysql image=marmotcai/mysql"
		echo "         make build-image name=redis tag=redis image=marmotcai/redis"
		echo "         make build-image name=nginx tag=nginx image=marmotcai/nginx"
		echo "use: make build projecturl"
		echo "    e.g: make build http://git.atoml.com/taoyang/hangu-epg.git"
		echo "use: make test image=xx"
		echo "use: make clean image=xx"

build-image:

	echo 'build image ('$(name)'-'$(tag)'>>'$(image)')'

	DOCKERFILE_PATH=""

	if [ "$(name)" = "ubuntu" ]; \
		then DOCKERFILE_PATH="./base/Dockerfile-ubuntu-base" make image; fi
	
	if [ "$(name)" = "centos" ]; \
		then DOCKERFILE_PATH="./base/Dockerfile-centos-base" make image; fi

	if [ "$(name)" = "ubuntu-java" ]; \
		then DOCKERFILE_PATH="./base/Dockerfile-ubuntu-java" make image; fi

	if [ "$(name)" = "centos-java" ]; \
		then DOCKERFILE_PATH="./base/Dockerfile-centos-java" make image; fi

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
		then DOCKERFILE_PATH="./ceph/Dockerfile-centos-ceph-deploy" make image; fi

	if [ "$(name)" = "golang" ]; \
		then DOCKERFILE_PATH="./golang/Dockerfile-centos-golang" make image; fi

	if [ "$(name)" = "golang-arm" ]; \
		then DOCKERFILE_PATH="./golang/Dockerfile-centos-golang-arm" make image; fi

	if [ "$(name)" = "go-mediainfo" ]; \
		then DOCKERFILE_PATH="./mediainfo/Dockerfile-golang-mediainfo" make image; fi

	if [ "$(name)" = "s3cmd" ]; \
		then DOCKERFILE_PATH="./s3cmd/Dockerfile-centos-s3cmd" make image; fi

	if [ "$(name)" = "mysql" ]; \
		then cd server; sh build.sh mysql; cd ..; exit 0; fi
	
	if [ "$(name)" = "redis" ]; \
		then cd server; sh build.sh redis; cd ..;  exit 0; fi
	
	if [ "$(name)" = "ftp" ]; \
		then cd server; sh build.sh ftp; cd ..;  exit 0; fi

	if [ "$(name)" = "nginx" ]; \
		then cd server; sh build.sh nginx; cd ..;  exit 0; fi
image:

	echo $(name) '-' $(tag) '>>' $(image)
	echo $(DOCKERFILE_PATH)

	# docker build --target $(tag) --build-arg CONFIGDIR=./config -t $(image) -f $(DOCKERFILE_PATH) .
	docker build --target $(tag) -t $(image) -f $(DOCKERFILE_PATH) .

test:
	
	echo 'test image ('$(image)')'

	if [ "$(image)" = "marmotcai/ceph-deploy" ]; \
		then docker run --rm -ti -v $(shell pwd)/ceph/script:/root/script $(image) /bin/bash; exit 0; fi
	        
	if [ "$(image)" = "marmotcai/go-mediainfo" ]; \
		then docker run --rm -ti -v $(shell pwd)/mediainfo/data:/root/go/src/data $(image) /bin/bash; exit 0; fi

	if [ "$(image)" = "marmotcai/mysql" ]; \
		then docker run --rm -ti $(image) /bin/bash; \
		#then docker run --rm -ti -v $(shell pwd)/server/data/mysql:/etc/mysql $(image) /bin/bash; \
	 exit 0; fi		
	
	if [ "$(image)" = "marmotcai/redis" ]; \
		then docker run --rm -ti -v $(shell pwd)/server/data/redis:/etc/redis $(image) /bin/bash; \
	exit 0; fi

	docker run --rm -ti $(image) /bin/bash


.PHONY: help build-image image test push
.SILENT:
