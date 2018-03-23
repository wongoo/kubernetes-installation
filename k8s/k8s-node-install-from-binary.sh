#!/bin/sh

k8s/k8s-repo-install.sh
k8s/k8s-docker-config.sh
k8s/k8s-centos7-config.sh

setenforce 0

if [ -f /usr/local/bin/kube-proxy ] && [ -f /usr/local/bin/kubelet ]
then
    echo "kube-proxy and kubelet exists"
else
    wget https://dl.k8s.io/${K8S_VER}/kubernetes-server-linux-amd64.tar.gz
    tar -xzvf kubernetes-server-linux-amd64.tar.gz
    cp -r kubernetes-server-linux-amd64/server/bin/{kube-proxy,kubelet} /usr/local/bin/
    chmod a+x /usr/local/bin/kube*
fi

#-----------------分发 kubeconfig 文件-----------------
# 复制到各个node
# cp bootstrap.kubeconfig kube-proxy.kubeconfig /etc/kubernetes/

k8s/k8s-kubelet-config.sh
k8s/k8s-kube-proxy-config.sh

kubectl get componentstatuses
