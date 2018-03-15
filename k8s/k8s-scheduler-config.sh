#!/bin/sh



echo "-------> start config scheduler service"
systemctl stop kube-scheduler

cp k8s/master/kube-scheduler.service /usr/lib/systemd/system/kube-scheduler.service
cp k8s/master/scheduler /etc/kubernetes/scheduler

systemctl daemon-reload

systemctl enable kube-scheduler
systemctl start kube-scheduler
systemctl status kube-scheduler