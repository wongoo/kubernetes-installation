#!/bin/sh

k8s/k8s-centos7-config.sh

if [ -f /usr/local/bin/kubectl ] && [ -f /usr/local/bin/kube-apiserver ]
then
    echo "kubectl and kube-apiserver exists"
else
    if [ -f kubernetes-server-linux-amd64.tar.gz ]
    then
        echo "use exists kubernetes-server-linux-amd64.tar.gz"
    else
        echo "-------> start download k8s binary"
        wget https://storage.googleapis.com/kubernetes-release/release/${K8S_VER}/kubernetes-server-linux-amd64.tar.gz
    fi

    echo "-------> install k8s binary"
    tar -xzvf kubernetes-server-linux-amd64.tar.gz
    cp -r kubernetes/server/bin/{kube-apiserver,kube-controller-manager,kube-scheduler,kubectl,kube-proxy,kubelet} /usr/local/bin/
    chmod a+x /usr/local/bin/kube*
fi

k8s/k8s-kubelet-bootstrapping-kubeconfig.sh
k8s/k8s-kube-proxy-kubeconfig.sh
k8s/k8s-kubectl-kubeconfig.sh

k8s/k8s-docker-config.sh

#-----------------分发 kubeconfig 文件-----------------
# 复制到各个node
# cp bootstrap.kubeconfig kube-proxy.kubeconfig /etc/kubernetes/

k8s/k8s-apiserver-config.sh
k8s/k8s-controller-manager-config.sh
k8s/k8s-scheduler-config.sh

kubectl get componentstatuses

k8s/k8s-docker-images-for-pod.sh
k8s/k8s-kubelet-config.sh
k8s/k8s-kube-proxy-config.sh

kubectl get componentstatuses

