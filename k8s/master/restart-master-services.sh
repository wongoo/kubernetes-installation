#!/bin/sh

systemctl restart etcd
systemctl restart flanneld
systemctl restart kube-apiserver
systemctl restart kube-controller-manager
systemctl restart kube-scheduler
systemctl restart kubelet
systemctl restart kube-proxy

# 如果启动失败查看详细信息
# journalctl -xef