#!/bin/sh

systemctl restart etcd
systemctl restart kube-apiserver
systemctl restart kube-controller-manager
systemctl restart kube-scheduler
systemctl restart kubelet
systemctl restart kube-proxy

