#!/bin/sh


if ETCD_VER=="" ; then
    echo "ETCD_VER not define"
    exit 1
fi

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

# ------------------------
# stop first
systemctl stop etcd


echo "-------> config etcd"
sudo cp etcd/etcd.service /usr/lib/systemd/system/

sed -i "s#__V_ETCD_NAME__#$V_ETCD_NAME#g" /usr/lib/systemd/system/etcd.service
sed -i "s#__V_ETCD_CLUSTER_LIST__#$V_ETCD_CLUSTER_LIST#g" /usr/lib/systemd/system/etcd.service
sed -i "s#__CURR_NODE_IP__#$CURR_NODE_IP#g" /usr/lib/systemd/system/etcd.service
sed -i "s#__V_ETCD_LISTEN_CLIENT_URLS__#$V_ETCD_LISTEN_CLIENT_URLS#g" /usr/lib/systemd/system/etcd.service
sed -i "s#__V_ETCD_LISTEN_PEER_URLS__#$V_ETCD_LISTEN_PEER_URLS#g" /usr/lib/systemd/system/etcd.service
sed -i "s#__V_ETCD_ADVERTISE_PEER_URLS__#$V_ETCD_ADVERTISE_PEER_URLS#g" /usr/lib/systemd/system/etcd.service
sed -i "s#__V_ETCD_ADVERTISE_CLIENT_URLS__#$V_ETCD_ADVERTISE_CLIENT_URLS#g" /usr/lib/systemd/system/etcd.service

# 使用etcd的第一种启动模式: https://github.com/ianwoolf/myPages/blob/master/%E5%88%86%E5%B8%83%E5%BC%8F/etcd%E4%B8%A4%E7%A7%8D%E9%9B%86%E7%BE%A4%E6%A8%A1%E5%BC%8F%E5%92%8C%E5%90%AF%E5%8A%A8.md
if [ "$CURR_NODE_IP" == "$K8S_MASTER_IP" ]
then
    echo "current is master"
fi

echo "-------> start etcd"
sudo rm -rf /var/lib/etcd/*
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