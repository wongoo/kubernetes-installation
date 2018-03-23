#!/bin/sh



yum install etcd -y
systemctl stop etcd

systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd

etcdctl set developer wongoo
etcdctl get developer

echo "-------> check etcd"
etcdctl -C http://${K8S_MASTER_IP}:4001 cluster-health
etcdctl -C http://${K8S_MASTER_IP}:2379 cluster-health

