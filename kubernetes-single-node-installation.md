
execute the commands one by one manually:
```
git clone https://github.com/wongoo/kubernetes-installation.git

cd kubernetes-installation

find . -regex ".*\.sh" | xargs chmod +x

mkdir temp
rm -rf temp/*

source config/config.sh

docker/docker-ce-installation.sh

cert/cert-generate.sh

cert/cert-ca-to-trusted.sh

etcd/etcd-install-from-binary.sh

k8s/k8s-master-install-from-binary.sh
```

Reference:
- [Using kubeadm to Create a Cluster](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/)
- [Running your first containers in Kubernetes](https://github.com/kubernetes/kubernetes/blob/master/examples/simple-nginx.md)
