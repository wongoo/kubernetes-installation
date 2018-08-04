#!/bin/sh

export KUBE_URL="https://storage.googleapis.com/kubernetes-release/release/${K8S_VER}/bin/linux/amd64"


# -----------------------------------------------
if [ -f /usr/local/bin/kubelet ]
then
    echo "kubectl and kubelet exists"
else
    wget "${KUBE_URL}/kubelet" -O /usr/local/bin/kubelet
fi

# -----------------------------------------------
if [ -f /usr/local/bin/kube-proxy ]
then
    echo "kubectl and kube-proxy exists"
else
    wget "${KUBE_URL}/kube-proxy" -O /usr/local/bin/kube-proxy
fi

# -----------------------------------------------
chmod a+x /usr/local/bin/kube*
