#!/bin/sh



export ETCD_VERSION=v3.3.2

if hash etcd 2>/dev/null; then
    echo "etcd exists"
else
    echo "-------> install etcd"
    if [ -f etcd-${ETCD_VERSION}-linux-amd64.tar.gz ]
    then
        echo "etcd-${ETCD_VERSION}-linux-amd64.tar.gz exists"
    else
        wget https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz
    fi
    tar -xvf etcd-${ETCD_VERSION}-linux-amd64.tar.gz
    sudo mv etcd-${ETCD_VERSION}-linux-amd64/etcd* /usr/local/bin

fi

systemctl stop etcd

echo "-------> config etcd"
sudo cp etcd/etcd.service /usr/lib/systemd/system/
sed -i "s/123.123.123.123/$KUBE_MASTER_IP/g" /usr/lib/systemd/system/etcd.service
sed -i "s/111.111.111.111/$CURR_NODE_IP/g" /usr/lib/systemd/system/etcd.service

sudo mkdir /etc/etcd
sudo cp etcd/etcd.conf /etc/etcd/etcd.conf
sed -i "s#https://123.123.123.123:2380#$ETCD_ENDPOINTS#g" /etc/etcd/etcd.conf
sed -i "s#123.123.123.123#$KUBE_MASTER_IP#g" /etc/etcd/etcd.conf
sed -i "s/111.111.111.111/$CURR_NODE_IP/g" /etc/etcd/etcd.conf

echo "-------> start etcd"
sudo mkdir /var/lib/etcd/

systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd
#=================================================

echo "-------> check etcd"
etcdctl \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  cluster-health