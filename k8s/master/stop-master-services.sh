#!/bin/sh

systemctl stop kube-proxy
systemctl stop kubelet
systemctl stop kube-scheduler
systemctl stop kube-controller-manager
systemctl stop kube-apiserver
systemctl stop flanneld
systemctl stop etcd

