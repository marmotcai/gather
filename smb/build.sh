#!/bin/sh

docker rm -f my-smb

docker run -ti -d \
               --name my-smb \
               --publish 445:445 \
               --publish 137:137 \
               --publish 138:138 \
               --publish 139:139 \
               --volume ${1:-`pwd`}:/share \
               --env workgroup=${2:-workgroup} \
               marmotcai/smb
