#!/bin/sh

echo "-------> start controller-manager service"

cp k8s/master/kube-controller-manager.service /usr/lib/systemd/system/kube-controller-manager.service
cp k8s/master/controller-manager.conf /etc/kubernetes/controller-manager.conf

systemctl daemon-reload

systemctl enable kube-controller-manager
systemctl start kube-controller-manager
systemctl status kube-controller-manager
