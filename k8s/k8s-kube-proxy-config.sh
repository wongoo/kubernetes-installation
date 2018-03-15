#!/bin/sh



echo "-------> start config kube-proxy"

systemctl stop kube-proxy

cp k8s/node/kube-proxy.service /usr/lib/systemd/system/kube-proxy.service
cp k8s/node/proxy /etc/kubernetes/proxy
sed -i "s/111.111.111.111/$CURR_NODE_IP/g" /etc/kubernetes/proxy
sed -i "s#000.000.000.000/00#$KUBE_IP_RANGE#g" /etc/kubernetes/proxy

yum install -y conntrack-tools

systemctl daemon-reload

systemctl enable kube-proxy
systemctl start kube-proxy
systemctl status kube-proxy
