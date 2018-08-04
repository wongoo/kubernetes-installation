#!/bin/sh



echo "-------> start config scheduler service"
systemctl stop kube-scheduler

cp k8s/master/kube-scheduler.service /usr/lib/systemd/system/kube-scheduler.service

sed -i "s#__K8S_MASTER_URL__#$K8S_MASTER_URL#g" /usr/lib/systemd/system/kube-scheduler.service

systemctl daemon-reload

systemctl enable kube-scheduler
systemctl start kube-scheduler
systemctl status kube-scheduler