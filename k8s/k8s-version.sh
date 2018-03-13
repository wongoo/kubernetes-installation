#!/bin/sh

if [ "$INSTALL_K8S_VERSION" == "" ]
then
    export INSTALL_K8S_VERSION=v1.9.3
fi

echo "INSTALL_K8S_VERSION=$INSTALL_K8S_VERSION"
