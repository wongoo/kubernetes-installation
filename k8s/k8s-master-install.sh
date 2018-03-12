#!/bin/sh

# k8s/k8s-repo-install.sh
k8s/k8s-docker-config.sh
k8s/k8s-centos7-config.sh

setenforce 0

if [ -f /usr/local/bin/kubectl ] && [ -f /usr/local/bin/kube-apiserver ]
then
    echo "kubectl and kube-apiserver exists"
else
    wget https://dl.k8s.io/${INSTALL_K8S_VERSION}/kubernetes-server-linux-amd64.tar.gz
    tar -xzvf kubernetes-server-linux-amd64.tar.gz
    cp -r kubernetes-server-linux-amd64/server/bin/{kube-apiserver,kube-controller-manager,kube-scheduler,kubectl,kube-proxy,kubelet} /usr/local/bin/
    chmod a+x /usr/local/bin/kube*

fi

k8s/k8s-token.sh
k8s/k8s-kubelet-bootstrapping-kubeconfig.sh
k8s/k8s-kube-proxy-kubeconfig.sh
k8s/k8s-kubectl-kubeconfig.sh


#-----------------分发 kubeconfig 文件-----------------
# 复制到各个node
# cp bootstrap.kubeconfig kube-proxy.kubeconfig /etc/kubernetes/


# =================================
cp k8s/master/kube-base.conf /etc/kubernetes/kube-base.conf
sed -i "s/123.123.123.123/$INSTALL_PARAM_MASTER_IP/g" /etc/kubernetes/kube-base.conf

k8s/k8s-apiserver-config.sh
k8s/k8s-controller-manager-config.sh
k8s/k8s-scheduler-config.sh

kubectl get componentstatuses

k8s/k8s-kubelet-config.sh
k8s/k8s-kube-proxy-config.sh

kubectl get componentstatuses

