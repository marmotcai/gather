#!/bin/bash

cmd=${1}
case $cmd in 
    build)
      ctdir=${2}
      mkdir -p ${ctdir}
      cd ${ctdir}
      sudo hdiutil create -volname "crosstool-ng-vol" -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 20g crosstool-ng-vol.dmg
      sudo mkdir -p /Volumes/crosstool-ng-vol
      sudo hdiutil attach crosstool-ng-vol.dmg.sparseimage -mountpoint /Volumes/crosstool-ng-vol
    ;;

    *)
      echo "use: sh mac-hd.sh build dirname"
    ;;
esac

exit 0;
