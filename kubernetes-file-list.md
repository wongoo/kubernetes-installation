
# 1. master和node都需要的文件列表

## 1.1 证书文件列表：
```
# cfssl工具集
/usr/local/bin/cfssl
/usr/local/bin/cfssl-bundle
/usr/local/bin/cfssl-certinfo
/usr/local/bin/cfssljson
/usr/local/bin/cfssl-newkey
/usr/local/bin/cfssl-scan

# 用于创建CA证书
/root/ssl/ca-config.json: 用于创建admin证书

# 证书签名请求配置文件
/root/ssl/ca-csr.json:
/root/ssl/kubernetes-csr.json
/root/ssl/admin-csr.json
/root/ssl/kube-proxy-csr.json

# 生成的签名请求文件，似乎没用到
/root/ssl/ca.csr
/root/ssl/kubernetes.csr
/root/ssl/kube-proxy.csr
/root/ssl/admin.csr

# 生成的 CA 私钥,证书
/etc/kubernetes/ssl/ca-key.pem
/etc/kubernetes/ssl/ca.pem

# 生成的 k8s 私钥,证书, 创建时需要 ca-config.json、ca-key.pem、ca.pem
/etc/kubernetes/ssl/kubernetes-key.pem
/etc/kubernetes/ssl/kubernetes.pem

# 生成的 k8s proxy 私钥,证书, 创建时需要 ca-config.json、ca-key.pem、ca.pem
/etc/kubernetes/ssl/kube-proxy-key.pem
/etc/kubernetes/ssl/kube-proxy.pem

# 生成的 admin 私钥,证书, 创建时需要 ca-config.json、ca-key.pem、ca.pem
/etc/kubernetes/ssl/admin-key.pem
/etc/kubernetes/ssl/admin.pem


# master 服务使用到的证书和私钥文件
etcd：使用 ca.pem、kubernetes-key.pem、kubernetes.pem；
kube-apiserver：使用 ca.pem、kubernetes-key.pem、kubernetes.pem；
kubectl：使用 ca.pem、admin-key.pem、admin.pem；
kube-controller-manager：使用 ca.pem、ca-key.pem

# node 服务使用到的证书和私钥文件
kubelet：使用 ca.pem；
kube-proxy：使用 ca.pem、kube-proxy-key.pem、kube-proxy.pem；
```

## 1.2. kubeconfig 文件列表
```
# master
/etc/kubernetes/token.csv: TLS Bootstrapping Token, 包含128 bit token信息, 指定Bootstrapping用户名

# master & node
/etc/kubernetes/bootstrap.kubeconfig: kubelet bootstrapping kubeconfig 文件，基于TLS Bootstrapping Token和ca.pem创建，并指定apiserver地址, 写入Bootstrapping用户名
/etc/kubernetes/kube-proxy.kubeconfig: kube-proxy kubeconfig 文件，基于kube-proxy-key.pem、kube-proxy.pem和ca.pem创建，并指定apiserver地址

```

## 1.3. etcd 文件列表
```
# master & node
/usr/local/bin/etcd
/usr/local/bin/etcdctl

/usr/lib/systemd/system/etcd.service

/etc/etcd/etcd.conf
```

## 1.4. flannel网络插件及docker
NOTE: 所有的node节点都需要安装网络插件才能让所有的Pod加入到同一个局域网中.
```
/usr/bin/flanneld-start

# 环境配置文件
/etc/sysconfig/flanneld
/etc/sysconfig/docker-network
/etc/sysconfig/docker
/etc/sysconfig/docker-storage

# 服务配置
/usr/lib/systemd/system/flanneld.service
/usr/lib/systemd/system/docker.service

/run/flannel/docker
/run/flannel/subnet.env
/run/docker_opts.env

```

# 2. master节点文件列表
```
/usr/local/bin/kube-apiserver
/usr/local/bin/kube-controller-manager
/usr/local/bin/kube-scheduler
/usr/local/bin/kubectl

~/.kube/config: kubectl kubeconfig 文件, 拥有对该集群的最高权限，请妥善保管, 基于admin-key.pem、admin.pem和ca.pem创建，并指定apiserver地址

# 环境配置文件
/etc/kubernetes/config: k8s共通环境配置
/etc/kubernetes/apiserver
/etc/kubernetes/controller-manager
/etc/kubernetes/scheduler

# kubeconfig
/etc/kubernetes/bootstrap.kubeconfig
/etc/kubernetes/kube-proxy.kubeconfig

# 服务配置
/usr/lib/systemd/system/kube-apiserver.service
/usr/lib/systemd/system/kube-controller-manager.service
/usr/lib/systemd/system/kube-scheduler.service
```

# 3. node节点文件列表
```
/usr/local/bin/kube-proxy
/usr/local/bin/kubelet

# 环境配置文件
/etc/kubernetes/config
/etc/kubernetes/proxy
/etc/kubernetes/kubelet

# kubeconfig
/etc/kubernetes/kubelet.kubeconfig
/etc/kubernetes/bootstrap.kubeconfig
/etc/kubernetes/kube-proxy.kubeconfig

# 通过 CSR 请求 自动生成了 kubelet kubeconfig 文件和公私钥
/etc/kubernetes/ssl/kubelet-client.crt
/etc/kubernetes/ssl/kubelet-client.key
/etc/kubernetes/ssl/kubelet.crt
/etc/kubernetes/ssl/kubelet.key

# 服务配置
/usr/lib/systemd/system/kubelet.service
/usr/lib/systemd/system/kube-proxy.service

# 运行目录
/var/lib/kubelet/

```