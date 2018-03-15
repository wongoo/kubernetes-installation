#!/bin/sh



yum install etcd -y
systemctl stop etcd

sed -i 's#ETCD_LISTEN_CLIENT_URLS="http://localhost:2379"#ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379,http://0.0.0.0:4001"#g' /etc/etcd/etcd.conf
sed -i 's#ETCD_NAME="default"#ETCD_NAME="master"#g' /etc/etcd/etcd.conf

REPLACE_STR=s#ETCD_ADVERTISE_CLIENT_URLS=\"http://localhost:2379\"#ETCD_ADVERTISE_CLIENT_URLS=\"http://$KUBE_MASTER_IP:2379,http://$KUBE_MASTER_IP:4001\"#g
sed -i $REPLACE_STR /etc/etcd/etcd.conf

systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd

etcdctl set developer wongoo
etcdctl get developer

echo "-------> check etcd"
etcdctl -C http://${KUBE_MASTER_IP}:4001 cluster-health
etcdctl -C http://${KUBE_MASTER_IP}:2379 cluster-health

