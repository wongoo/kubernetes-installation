#!/bin/sh

echo "-------> start controller-manager service"
systemctl stop kube-controller-manager

cp k8s/master/kube-controller-manager.service /usr/lib/systemd/system/kube-controller-manager.service

cp k8s/master/controller-manager /etc/kubernetes/controller-manager
sed -i "s#000.000.000.000/00#$KUBE_IP_RANGE#g" /etc/kubernetes/controller-manager

systemctl daemon-reload

systemctl enable kube-controller-manager
systemctl start kube-controller-manager
systemctl status kube-controller-manager
