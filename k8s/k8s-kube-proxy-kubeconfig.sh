#!/bin/sh

echo "-------> start kubeconfig kube-proxy"

previous_dir=$(pwd)

# ================GO INTO DIR=======================
cd /etc/kubernetes
export KUBE_APISERVER="https://$INSTALL_PARAM_APISERVER_IP:6443"



if [ -f kube-proxy.kubeconfig ]
then
    echo "kube-proxy.kubeconfig exists"
else

#-----------------创建 kube-proxy kubeconfig 文件-----------------
# 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=kube-proxy.kubeconfig
# 设置客户端认证参数
kubectl config set-credentials kube-proxy \
  --client-certificate=/etc/kubernetes/ssl/kube-proxy.pem \
  --client-key=/etc/kubernetes/ssl/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig
# 设置上下文参数
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig
# 设置默认上下文
kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

fi


# =================GO OUT DIR======================
cd $previous_dir

