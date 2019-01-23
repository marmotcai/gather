
default: help

help:

build-image:

	if [ "$(DOCKERNAME)" = "ubuntu" ]; \
		then DOCKERFILE_PATH="./Dockerfile/Dockerfile-ubuntu-base" make image; fi

	if [ "$(DOCKERNAME)" = "java" ]; \
		then DOCKERFILE_PATH="./Dockerfile/Dockerfile-java" make image; fi

	if [ "$(DOCKERNAME)" = "android" ]; \
		then DOCKERFILE_PATH="./Dockerfile/Dockerfile-android" make image; fi

	if [ "$(DOCKERNAME)" = "nodejs" ]; \
		then DOCKERFILE_PATH="./Dockerfile/Dockerfile-nodejs" make image; fi

	if [ "$(DOCKERNAME)" = "cordova" ]; \
		then DOCKERFILE_PATH="./Dockerfile/Dockerfile-cordova-ionic" make image; fi

	if [ "$(DOCKERNAME)" = "ionic" ]; \
		then DOCKERFILE_PATH="./Dockerfile/Dockerfile-cordova-ionic" make image; fi						

image:

	echo $(DOCKERNAME) '-' $(DOCKERTAG) '>>' $(DOCKERIMAGENAME)
	echo $(DOCKERFILE_PATH)

	docker build --target $(DOCKERTAG) -t $(DOCKERIMAGENAME) -f $(DOCKERFILE_PATH) .

make:

	echo $(SOURCEADDR) '(' $(APPNAME) ')'

	docker build --target default --build-arg SOURCEADDR=$(SOURCEADDR) --build-arg APPNAME=$(APPNAME) -t atoml/project -f ./Dockerfile/Dockerfile-project .
	docker run --rm -ti atoml/project bash

push:

.PHONY: help image make push
.SILENT:
