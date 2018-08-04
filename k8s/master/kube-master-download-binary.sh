#!/bin/sh

export KUBE_URL="https://storage.googleapis.com/kubernetes-release/release/${K8S_VER}/bin/linux/amd64"

# -----------------------------------------------
if [ -f /usr/local/bin/kubectl ]
then
    echo "kubectl and kubectl exists"
else
    wget "${KUBE_URL}/kubectl" -O /usr/local/bin/kubectl
fi

# -----------------------------------------------
if [ -f /usr/local/bin/kubelet ]
then
    echo "kubectl and kubelet exists"
else
    wget "${KUBE_URL}/kubelet" -O /usr/local/bin/kubelet
fi

# -----------------------------------------------
if [ -f /usr/local/bin/kube-apiserver ]
then
    echo "kubectl and kube-apiserver exists"
else
    wget "${KUBE_URL}/kube-apiserver" -O /usr/local/bin/kube-apiserver
fi

# -----------------------------------------------
if [ -f /usr/local/bin/kube-scheduler ]
then
    echo "kubectl and kube-scheduler exists"
else
    wget "${KUBE_URL}/kube-scheduler" -O /usr/local/bin/kube-scheduler
fi

# -----------------------------------------------
if [ -f /usr/local/bin/kube-controller-manager ]
then
    echo "kubectl and kube-controller-manager exists"
else
    wget "${KUBE_URL}/kube-controller-manager" -O /usr/local/bin/kube-controller-manager
fi

# -----------------------------------------------
chmod a+x /usr/local/bin/kube*
