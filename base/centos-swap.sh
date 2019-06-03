#!/bin/bash

cmd=${1}
param=${2}
case $cmd in
	on)
      count=${param}
      if [ -z "${count}" ];then
      	count=2
      fi

      echo "dd if=/dev/zero of=/home/swap bs=1G count=$count"

	  #dd if=/dev/zero of=/home/swap bs=1G count=$count

	  #mkswap /home/swap

	  #swapon /home/swap

	  #sed -i '$a\/home/swap swap swap default 0 0' /etc/fstab
	;;


	off)
	  sed -i '/swap/d' /etc/fstab

	  swapoff /home/swap

	  rm -rf /home/swap


	;;

    *)
      echo "use: sh swapon-centos.sh on xx"
      echo "use: sh swapon-centos.sh off xx"
    ;;
esac

exit 0;