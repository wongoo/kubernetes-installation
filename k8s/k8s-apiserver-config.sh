#!/bin/sh

echo "-------> start config apiserver"

cp k8s/master/kube-apiserver.service /usr/lib/systemd/system/kube-apiserver.service
cp k8s/master/apiserver.conf /etc/kubernetes/apiserver.conf
sed -i "s/111.111.111.111/$CURR_NODE_IP/g" /etc/kubernetes/apiserver.conf

systemctl daemon-reload

systemctl enable kube-apiserver
systemctl start kube-apiserver
systemctl status kube-apiserver

