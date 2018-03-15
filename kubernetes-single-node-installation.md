
```
git clone https://github.com/wongoo/kubernetes-installation.git
cd kubernetes-installation
find . -regex ".*\.sh" | xargs chmod +x

source config/config.sh

single-node/single-node-install.sh


```

Reference:
- [Using kubeadm to Create a Cluster](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/)
- [Running your first containers in Kubernetes](https://github.com/kubernetes/kubernetes/blob/master/examples/simple-nginx.md)
