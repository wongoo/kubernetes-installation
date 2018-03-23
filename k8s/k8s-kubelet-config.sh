#!/bin/sh



echo "-------> start config kubelet"

systemctl stop kubelet


# kubelet 启动时向 kube-apiserver 发送 TLS bootstrapping 请求，需要先将 bootstrap token 文件中的 kubelet-bootstrap 用户赋予 system:node-bootstrapper cluster 角色(role)
# 然后 kubelet 才能有权限创建认证请求(certificate signing requests)
# --user=kubelet-bootstrap 是在 /etc/kubernetes/token.csv 文件中指定的用户名，同时也写入了 /etc/kubernetes/bootstrap.kubeconfig 文件
kubectl create clusterrolebinding kubelet-bootstrap \
  --clusterrole=system:node-bootstrapper \
  --user=kubelet-bootstrap


# =============================================
cp k8s/node/kubelet.service /usr/lib/systemd/system/kubelet.service

sed -i "s/__CURR_NODE_IP__/${CURR_NODE_IP}/g" /usr/lib/systemd/system/kubelet.service

# =============================================
# error: failed to run Kubelet: cannot create certificate signing request: certificatesigningrequests.certificates.k8s.io is forbidden: User "system:anonymous" cannot create certificatesigningrequests.certificates.k8s.io at the cluster scope
# 以上错误待解决，暂时使用管理权限的kubeconfig配置
cp ~/.kube/config /etc/kubernetes/kubelet.kubeconfig

# =============================================
mkdir /var/lib/kubelet

# =============================================
systemctl daemon-reload

# 启动 kubelet 时，如果 --kubeconfig 指定的文件不存在，则使用 bootstrap kubeconfig 向 API server 请求客户端证书。
# 在批准 kubelet 的证书请求和回执时，将包含了生成的密钥和证书的 kubeconfig 文件写入由 -kubeconfig 指定的路径。
# 证书和密钥文件将被放置在由 --cert-dir 指定的目录中。

systemctl enable kubelet
systemctl start kubelet
systemctl status kubelet

# 获取CSR编号
# kubectl get csr
# NAME        AGE       REQUESTOR           CONDITION
# csr-2b308   4m        kubelet-bootstrap   Pending
# CSR_NO=$(kubectl get csr | grep Pending | awk '{print $1}')

# master 执行
# kubectl certificate approve csr-2b308
# kubectl certificate approve ${CSR_NO}
