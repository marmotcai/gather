#!/bin/bash

git_url=${1}
app_name=${2}

if  [[ ${git_url} = '' ]]; then
  echo "use: build git_url appname"
  exit 0
fi

if  [[ ${app_name} = '' ]]; then
  echo "appname not set"
  app_name="yourapp"
fi

gopm get -g -v ${git_url}

cd $GOPATH/src/${git_url}

go build -o /root/output/${app_name}

exit 0;
