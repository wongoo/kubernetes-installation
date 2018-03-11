export ETCD_VERSION=v3.3.2

if hash etcd 2>/dev/null; then
    echo "etcd exists"
else
    echo "-------> install etcd"
    wget https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz
    tar -xvf etcd-${ETCD_VERSION}-linux-amd64.tar.gz
    sudo mv etcd-${ETCD_VERSION}-linux-amd64/etcd* /usr/local/bin
fi


echo "-------> config etcd"
sudo mv etcd/etcd.service /usr/lib/systemd/system/
sed -i "s/172.20.0.113/$INSTALL_PARAM_MASTER_IP/g" /usr/lib/systemd/system/etcd.service

sudo mv etcd/etcd.conf /etc/etcd/etcd.conf
sed -i "s#infra1=https://172.20.0.113:2380#$INSTALL_PARAM_ETCD_CLUSTER_LIST#g" /etc/etcd/etcd.conf

echo "-------> start etcd"
systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd

echo "-------> check etcd"
etcdctl \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  cluster-health