#!/bin/sh

echo "-------> start kubeconfig kubelet-bootstrapping"

export KUBELET_BOOTSTRAP_CONF=/etc/kubernetes/bootstrap.kubeconfig
export KUBELET_BOOTSTRAP_USER=kubelet-bootstrap

if [ -f /etc/kubernetes/bootstrap.kubeconfig ]
then
    echo "bootstrap.kubeconfig exists, move to bootstrap.kubeconfig.bak"
    mv ${KUBELET_BOOTSTRAP_CONF} ${KUBELET_BOOTSTRAP_CONF}.bak
fi

#-----------------创建 kubelet bootstrapping kubeconfig 文件-----------------
# 设置集群参数,集群名称kubernetes
kubectl config set-cluster ${K8S_CLUSTER_NAME} \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${K8S_APISERVER_URL} \
  --kubeconfig=${KUBELET_BOOTSTRAP_CONF}

# 设置客户端认证参数
kubectl config set-credentials ${KUBELET_BOOTSTRAP_USER} \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=${KUBELET_BOOTSTRAP_CONF}

# 设置上下文参数
kubectl config set-context default \
  --cluster=${K8S_CLUSTER_NAME} \
  --user=${KUBELET_BOOTSTRAP_USER} \
  --kubeconfig=${KUBELET_BOOTSTRAP_CONF}

# 设置默认上下文
kubectl config use-context default --kubeconfig=${KUBELET_BOOTSTRAP_CONF}


