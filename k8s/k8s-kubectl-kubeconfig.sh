#!/bin/sh

echo "-------> start kubectl kubeconfig for admin "

export KUBECTL_ADMIN_USER=admin
export KUBECTL_ADMIN_CONTEXT=kubernetes

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
  --server=${K8S_APISERVER_URL}

# 设置客户端认证参数
kubectl config set-credentials ${KUBECTL_ADMIN_USER} \
  --client-certificate=/etc/kubernetes/ssl/admin.pem \
  --embed-certs=true \
  --client-key=/etc/kubernetes/ssl/admin-key.pem

# 设置上下文参数
kubectl config set-context ${KUBECTL_ADMIN_CONTEXT} \
  --cluster=${K8S_CLUSTER_NAME} \
  --user=${KUBECTL_ADMIN_USER}

# 设置默认上下文
kubectl config use-context ${KUBECTL_ADMIN_CONTEXT}

echo "----> 注意：~/.kube/config文件拥有对该集群的最高权限，请妥善保管"
echo "----> ~/.kube/config:"
cat ~/.kube/config


