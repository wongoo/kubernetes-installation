#!/bin/sh

k8s/k8s-centos7-config.sh

k8s/master/kube-master-download-binary.sh

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

