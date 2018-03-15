#!/bin/sh

systemctl restart etcd
systemctl restart kubelet
systemctl restart kube-proxy

