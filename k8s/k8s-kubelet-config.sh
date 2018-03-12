#!/bin/sh

echo "-------> start config kubelet"


# --user=kubelet-bootstrap 是在 /etc/kubernetes/token.csv 文件中指定的用户名，同时也写入了 /etc/kubernetes/bootstrap.kubeconfig 文件
kubectl create clusterrolebinding kubelet-bootstrap \
  --clusterrole=system:node-bootstrapper \
  --user=kubelet-bootstrap

cp k8s/node/kubelet.service /usr/lib/systemd/system/kubelet.service
cp k8s/node/kubelet.conf /etc/kubernetes/kubelet.conf
sed -i "s/123.123.123.123/$INSTALL_PARAM_MASTER_IP/g" /etc/kubernetes/kubelet.conf
sed -i "s/111.111.111.111/$CURR_NODE_IP/g" /etc/kubernetes/kubelet.conf


systemctl daemon-reload

systemctl enable kubelet
systemctl start kubelet
systemctl status kubelet

# 获取CSR编号
# kubectl get csr
# NAME        AGE       REQUESTOR           CONDITION
# csr-2b308   4m        kubelet-bootstrap   Pending
CSR_NO=$(kubectl get csr | grep Pending | awk '{print $1}')

# master 执行
# kubectl certificate approve csr-2b308
kubectl certificate approve ${CSR_NO}

