#!/bin/bash

git add .
curtime=`date "+%Y-%m-%d:%H:%M:%S"`
git commit -m "auto commit ${curtime}"
git push

