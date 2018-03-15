#!/bin/sh



echo "-------> start config apiserver"

systemctl stop kube-apiserver

cp k8s/master/kube-apiserver.service /usr/lib/systemd/system/kube-apiserver.service
cp k8s/master/apiserver /etc/kubernetes/apiserver
sed -i "s/111.111.111.111/$CURR_NODE_IP/g" /etc/kubernetes/apiserver
sed -i "s#000.000.000.000/00#$KUBE_IP_RANGE#g" /etc/kubernetes/apiserver

systemctl daemon-reload

systemctl enable kube-apiserver
systemctl start kube-apiserver
systemctl status kube-apiserver

# 如果启动失败查看详细信息
# journalctl -xe