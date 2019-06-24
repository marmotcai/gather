#!/bin/bash

if [ -z "${1}" ];then
    echo "use: sh mac-mount.sh mount crosstool_name image_size"
    echo "use: sh mac-mount.sh umount crosstool_name"
    echo "use: sh mac-mount.sh build crosstool_name"
    exit 0
fi
cmd=${1}

if [ -z "${2}" ];then
    echo "use: sh mac-mount.sh unmount crosstool_name"
    exit 0
fi
crosstool_name=${2}

case $cmd in 
    mount)
      image_size=20g
      if [ ! -z "${3}" ];then
        image_size=${3}
      fi

      mkdir -p ${crosstool_name}
      cd ${crosstool_name}

      sudo hdiutil create -volname ${crosstool_name} -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size ${image_size} ${crosstool_name}.dmg
      sudo mkdir -p /Volumes/${crosstool_name}
      sudo hdiutil attach ${crosstool_name}.dmg.sparseimage -mountpoint /Volumes/${crosstool_name}
    ;;

    umount)
      hdiutil detach /Volumes/${crosstool_name}
    ;;

    build)
      rm -rf /Volumes/${crosstool_name}/build

      mkdir -p /Volumes/${crosstool_name}/build 
      mkdir -p /Volumes/${crosstool_name}/src 
      mkdir -p /Volumes/${crosstool_name}/x-tools/${crosstool_name}
 
      cd /Volumes/${crosstool_name}/build
      ct-ng ${crosstool_name}

      # brew install gnu-sed
      gsed -i 's/# CT_EXPERIMENTAL is not set/CT_EXPERIMENTAL=y/g' "/Volumes/${crosstool_name}/build/.config"
      gsed -i '/CT_EXPERIMENTAL=y/a\CT_ALLOW_BUILD_AS_ROOT_SURE=y' "/Volumes/${crosstool_name}/build/.config"
      gsed -i '/CT_EXPERIMENTAL=y/a\CT_ALLOW_BUILD_AS_ROOT=y' "/Volumes/${crosstool_name}/build/.config"
      
      gsed -i 's/${HOME}/\/Volumes\/'${crosstool_name}'/g' "/Volumes/${crosstool_name}/build/.config"

      ct-ng build
    ;;      
    
    *)
      echo "use: sh mac-mount.sh mount crosstool_name image_size"
      echo "use: sh mac-mount.sh umount crosstool_name"
      echo "use: sh mac-mount.sh build crosstool_name"
    ;;
esac

exit 0;
