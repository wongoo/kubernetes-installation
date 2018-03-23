#!/bin/sh



echo "-------> start config kube-proxy"

systemctl stop kube-proxy

cp k8s/node/kube-proxy.service /usr/lib/systemd/system/kube-proxy.service

sed -i "s/__CURR_NODE_IP__/$CURR_NODE_IP/g" /usr/lib/systemd/system/kube-proxy.service
sed -i "s#__K8S_CLUSTER_IP_RANGE__#$K8S_CLUSTER_IP_RANGE#g" /usr/lib/systemd/system/kube-proxy.service
sed -i "s#__K8S_MASTER_URL__#$K8S_MASTER_URL#g" /usr/lib/systemd/system/kube-proxy.service

yum install -y conntrack-tools

systemctl daemon-reload

systemctl enable kube-proxy
systemctl start kube-proxy
systemctl status kube-proxy
