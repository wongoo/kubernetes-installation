#!/bin/sh

export CNI_URL=https://github.com/containernetworking/plugins/releases/download

mkdir -p /opt/cni/bin && cd /opt/cni/bin

wget -qO- --show-progress "${CNI_URL}/v0.7.1/cni-plugins-amd64-v0.7.1.tgz" | tar -zx

