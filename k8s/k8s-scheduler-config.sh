#!/bin/sh

echo "-------> start config scheduler service"

cp k8s/master/kube-scheduler.service /usr/lib/systemd/system/kube-scheduler.service
cp k8s/master/scheduler.conf /etc/kubernetes/scheduler.conf

systemctl daemon-reload

systemctl enable kube-scheduler
systemctl start kube-scheduler
systemctl status kube-scheduler