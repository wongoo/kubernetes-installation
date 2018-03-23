#!/bin/sh

echo "-------> start controller-manager service"
systemctl stop kube-controller-manager

cp k8s/master/kube-controller-manager.service /usr/lib/systemd/system/kube-controller-manager.service

sed -i "s#__K8S_CLUSTER_IP_RANGE__#$K8S_CLUSTER_IP_RANGE#g" /usr/lib/systemd/system/kube-controller-manager.service

systemctl daemon-reload

systemctl enable kube-controller-manager
systemctl start kube-controller-manager
systemctl status kube-controller-manager
