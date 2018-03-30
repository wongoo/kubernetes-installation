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
    cp -r kubernetes/server/bin/{kube-proxy,kubelet,kubectl} /usr/local/bin/
    chmod a+x /usr/local/bin/kube*
fi

#-----------------分发 kubeconfig 文件-----------------
# 复制到各个node
# /etc/kubernetes/token.csv
# /etc/kubernetes/ssl/ca.pem
# /etc/kubernetes/ssl/kube-proxy.pem
# /etc/kubernetes/ssl/kube-proxy-key.pem
# /etc/kubernetes/ssl/kubenetes.pem
# /etc/kubernetes/ssl/kubenetes-key.pem


k8s-kube-proxy-kubeconfig.sh
k8s/k8s-kube-proxy-config.sh

source config/k8s-token.sh
k8s/k8s-kubelet-bootstrapping-kubeconfig.sh
k8s/k8s-docker-images-for-pod.sh

# =============================================
# error: failed to run Kubelet: cannot create certificate signing request: certificatesigningrequests.certificates.k8s.io is forbidden: User "system:anonymous" cannot create certificatesigningrequests.certificates.k8s.io at the cluster scope
# 以上错误待解决，暂时使用管理权限的kubeconfig配置
cp ~/.kube/config /etc/kubernetes/kubelet.kubeconfig

k8s/k8s-kubelet-config.sh

kubectl get componentstatuses
