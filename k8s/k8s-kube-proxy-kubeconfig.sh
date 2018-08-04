#!/bin/sh

echo "-------> start kubeconfig kube-proxy"

export KUBE_PORXY_USER=kube-proxy
export KUBE_PORXY_CONF=/etc/kubernetes/kube-proxy.kubeconfig

if [ -f ${KUBE_PORXY_CONF} ]
then
    echo "kube-proxy.kubeconfig exists, move to kube-proxy.kubeconfig.bak"
    mv ${KUBE_PORXY_CONF} ${KUBE_PORXY_CONF}.bak
fi

#-----------------创建 kube-proxy kubeconfig 文件-----------------
# 设置集群参数
kubectl config set-cluster ${K8S_CLUSTER_NAME} \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${K8S_APISERVER_URL} \
  --kubeconfig=${KUBE_PORXY_CONF}

# 设置客户端认证参数
kubectl config set-credentials ${KUBE_PORXY_USER} \
  --client-certificate=/etc/kubernetes/ssl/kube-proxy.pem \
  --client-key=/etc/kubernetes/ssl/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=${KUBE_PORXY_CONF}

# 设置上下文参数
kubectl config set-context default \
  --cluster=${K8S_CLUSTER_NAME} \
  --user=${KUBE_PORXY_USER} \
  --kubeconfig=${KUBE_PORXY_CONF}

# 设置默认上下文
kubectl config use-context default --kubeconfig=${KUBE_PORXY_CONF}


