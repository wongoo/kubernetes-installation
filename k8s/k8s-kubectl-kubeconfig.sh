#!/bin/sh



echo "-------> start kubeconfig kubectl"

previous_dir=$(pwd)

# ================GO INTO DIR=======================
cd /etc/kubernetes
export KUBE_APISERVER="https://$K8S_APISERVER_IP:6443"



if [ -f ~/.kube/config ]
then
    echo "~/.kube/config exists, move to ~/.kube/config.bak"
    mv ~/.kube/config ~/.kube/config.bak
fi

#-----------------创建 kubectl kubeconfig 文件-----------------
# 设置集群参数
kubectl config set-cluster ${K8S_CLUSTER_NAME} \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER}

# 设置客户端认证参数
kubectl config set-credentials admin \
  --client-certificate=/etc/kubernetes/ssl/admin.pem \
  --embed-certs=true \
  --client-key=/etc/kubernetes/ssl/admin-key.pem

# 设置上下文参数
kubectl config set-context kubernetes \
  --cluster=${K8S_CLUSTER_NAME} \
  --user=admin

# 设置默认上下文
kubectl config use-context kubernetes

# 注意：~/.kube/config文件拥有对该集群的最高权限，请妥善保管。

cat ~/.kube/config



# =================GO OUT DIR======================
cd $previous_dir

