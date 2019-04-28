#!/bin/bash

profile="/etc/profile"

echo "set arch to ${1}"
case ${1} in
    init)
      sed -i '$a export GOARCH=amd64' $profile
      sed -i '$a export GOOS=linux' $profile
      sed -i '$a export CGO_ENABLE=0' $profile
    ;;

    arm)
      sed -i '/^export GOARCH=/cexport GOARCH=arm' $profile
      sed -i '/^export GOOS=/cexport GOOS=linux' $profile
      sed -i '/^export CGO_ENABLE/cexport CGO_ENABLE=0' $profile
    ;;

    *)
      sed -i '/^export GOARCH=/cexport GOARCH=amd64' $profile
      sed -i '/^export GOOS=/cexport GOOS=linux' $profile
      sed -i '/^export CGO_ENABLE/cexport CGO_ENABLE=0' $profile
    ;;

  esac

. /etc/profile
