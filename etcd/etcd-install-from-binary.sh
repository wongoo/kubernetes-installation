#!/bin/sh



export ETCD_VER=v3.3.2

if hash etcd 2>/dev/null; then
    echo "etcd exists"
else
    echo "-------> install etcd"
    if [ -f etcd-${ETCD_VER}-linux-amd64.tar.gz ]
    then
        echo "etcd-${ETCD_VER}-linux-amd64.tar.gz exists"
    else
        wget https://github.com/coreos/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz
    fi
    tar -xvf etcd-${ETCD_VER}-linux-amd64.tar.gz
    sudo mv etcd-${ETCD_VER}-linux-amd64/etcd* /usr/local/bin

fi

systemctl stop etcd

echo "-------> config etcd"
sudo cp etcd/etcd.service /usr/lib/systemd/system/

sed -i "s/__ETCD_NAME__/$ETCD_NAME/g" /usr/lib/systemd/system/etcd.service
sed -i "s/__CURR_NODE_IP__/$CURR_NODE_IP/g" /usr/lib/systemd/system/etcd.service
sed -i "s#__ETCD_ENDPOINTS__#$ETCD_ENDPOINTS#g" /usr/lib/systemd/system/etcd.service
sed -i "s#__ETCD_ADVERTISE_PEER_URLS__#$ETCD_ADVERTISE_PEER_URLS#g" /usr/lib/systemd/system/etcd.service
sed -i "s/__ETCD_PEER_URLS__/$ETCD_PEER_URLS/g" /usr/lib/systemd/system/etcd.service
sed -i "s/__ETCD_ADVERTISE_CLIENT_URLS__/$ETCD_ADVERTISE_CLIENT_URLS/g" /usr/lib/systemd/system/etcd.service

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