#!/bin/sh

systemctl stop kube-proxy
systemctl stop kubelet
systemctl stop etcd

