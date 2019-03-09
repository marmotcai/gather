#!/bin/bash

cmd=${1}
case $cmd in 
    commit)
      git add .
      curtime=`date "+%Y-%m-%d:%H:%M:%S"`
      git commit -m "auto commit ${curtime}"
    ;;

    push)
      git push
    ;;

    *)
      echo "use: sh git.sh commit"
      echo "use: sh git.sh push"
    ;;
esac

exit 0;
