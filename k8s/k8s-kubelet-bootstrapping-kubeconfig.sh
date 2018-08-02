#!/bin/sh



echo "-------> start kubeconfig kubelet-bootstrapping"

previous_dir=$(pwd)

# ================GO INTO DIR=======================
cd /etc/kubernetes
export KUBE_APISERVER="https://$K8S_APISERVER_IP:6443"


if [ -f bootstrap.kubeconfig ]
then
    echo "bootstrap.kubeconfig exists, move to bootstrap.kubeconfig.bak"
    mv bootstrap.kubeconfig bootstrap.kubeconfig.bak
fi

#-----------------创建 kubelet bootstrapping kubeconfig 文件-----------------
# 设置集群参数,集群名称kubernetes
kubectl config set-cluster ${K8S_CLUSTER_NAME} \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=bootstrap.kubeconfig

# 设置客户端认证参数
kubectl config set-credentials kubelet-bootstrap \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=bootstrap.kubeconfig

# 设置上下文参数
kubectl config set-context default \
  --cluster=${K8S_CLUSTER_NAME} \
  --user=kubelet-bootstrap \
  --kubeconfig=bootstrap.kubeconfig

# 设置默认上下文
kubectl config use-context default --kubeconfig=bootstrap.kubeconfig


# =================GO OUT DIR======================
cd $previous_dir

