#!/bin/sh



echo "-------> start config apiserver"

systemctl stop kube-apiserver

# ---------------kube-apiserver 启动参数说明-----------------------------
# client-ca-file: 指定CA根证书文件为/etc/kubernetes/ssl/ca.pem，内置CA公钥用于验证某证书是否是CA签发的证书
# tls-private-key-file: 指定ApiServer私钥文件为/etc/kubernetes/ssl/kubernetes-key.pem
# tls-cert-file：指定ApiServer证书文件为/etc/kubernetes/ssl/kubernetes.pem

cp k8s/master/kube-apiserver.service /usr/lib/systemd/system/kube-apiserver.service

sed -i "s/__CURR_NODE_IP__/$CURR_NODE_IP/g" /usr/lib/systemd/system/kube-apiserver.service
sed -i "s#__K8S_CLUSTER_IP_RANGE__#$K8S_CLUSTER_IP_RANGE#g" /usr/lib/systemd/system/kube-apiserver.service
sed -i "s#__ETCD_ENDPOINTS__#$ETCD_ENDPOINTS#g" /usr/lib/systemd/system/kube-apiserver.service


systemctl daemon-reload

systemctl enable kube-apiserver
systemctl start kube-apiserver
systemctl status kube-apiserver

# 如果启动失败查看详细信息
# journalctl -xe

# 验证apiserver
# curl https://127.0.0.1:6443/api/v1/nodes --cert /etc/kubernetes/dd_cs_client.crt --key /var/run/kubernetes/dd_cs_client.key --cacert /var/run/kubernetes/dd_ca.crt

