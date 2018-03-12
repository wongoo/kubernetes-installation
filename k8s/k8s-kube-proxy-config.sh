#!/bin/sh

echo "-------> start config kube-proxy"

cp k8s/node/kube-proxy.service /usr/lib/systemd/system/kube-proxy.service
cp k8s/node/proxy.conf /etc/kubernetes/proxy.conf
sed -i "s/111.111.111.111/$CURR_NODE_IP/g" /etc/kubernetes/proxy.conf

yum install -y conntrack-tools

systemctl daemon-reload

systemctl enable kube-proxy
systemctl start kube-proxy
systemctl status kube-proxy
