#!/bin/sh

export KUBE_URL="https://storage.googleapis.com/kubernetes-release/release/${K8S_VER}/bin/linux/amd64"

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

    wget "${KUBE_URL}/kubectl" -O /usr/local/bin/kubectl
    wget "${KUBE_URL}/kubelet" -O /usr/local/bin/kubelet
    wget "${KUBE_URL}/kube-apiserver" -O /usr/local/bin/kube-apiserver
    wget "${KUBE_URL}/kube-controller-manager" -O /usr/local/bin/kube-controller-manager
    wget "${KUBE_URL}/kube-scheduler" -O /usr/local/bin/kube-scheduler
    wget "${KUBE_URL}/kube-proxy" -O /usr/local/bin/kube-proxy

    chmod a+x /usr/local/bin/kube*
fi
