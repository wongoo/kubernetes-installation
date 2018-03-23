#!/bin/sh



k8s/k8s-repo-install.sh
k8s/k8s-docker-config.sh
k8s/k8s-centos7-config.sh

if [ -f /usr/bin/kubeadm ]
then
    echo "kubeadm exists"
else
    k8s/k8s-docker-images-for-kubeadm.sh
    k8s/k8s-docker-images-for-pod.sh

    yum install -y kubelet kubeadm kubectl

    sed -i '/ExecStart=$/iEnvironment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
    systemctl daemon-reload
    systemctl enable kubelet.service
    systemctl stop kubelet.service

    rm -rf /etc/kubernetes/manifests/
    rm -rf /var/lib/etcd/

    kubeadm init \
      --kubernetes-version=$K8S_VER \
      --pod-network-cidr=10.254.0.0/16 \
      --apiserver-advertise-address=$K8S_MASTER_IP \
      --ignore-preflight-errors=CRI

    # ignore CRI error: unable to check if the container runtime at "/var/run/dockershim.sock" is running: exit status 1
fi


# [init] Using Kubernetes version: v1.9.3
# [init] Using Authorization modes: [Node RBAC]
# [preflight] Running pre-flight checks.
# 	[WARNING CRI]: unable to check if the container runtime at "/var/run/dockershim.sock" is running: exit status 1
# [preflight] Starting the kubelet service
# [certificates] Using the existing ca certificate and key.
# [certificates] Using the existing apiserver certificate and key.
# [certificates] Using the existing apiserver-kubelet-client certificate and key.
# [certificates] Using the existing sa key.
# [certificates] Using the existing front-proxy-ca certificate and key.
# [certificates] Using the existing front-proxy-client certificate and key.
# [certificates] Valid certificates and keys now exist in "/etc/kubernetes/pki"
# [kubeconfig] Using existing up-to-date KubeConfig file: "admin.conf"
# [kubeconfig] Using existing up-to-date KubeConfig file: "kubelet"
# [kubeconfig] Using existing up-to-date KubeConfig file: "controller-manager"
# [kubeconfig] Using existing up-to-date KubeConfig file: "scheduler"
# [controlplane] Wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/manifests/kube-apiserver.yaml"
# [controlplane] Wrote Static Pod manifest for component kube-controller-manager to "/etc/kubernetes/manifests/kube-controller-manager.yaml"
# [controlplane] Wrote Static Pod manifest for component kube-scheduler to "/etc/kubernetes/manifests/kube-scheduler.yaml"
# [etcd] Wrote Static Pod manifest for a local etcd instance to "/etc/kubernetes/manifests/etcd.yaml"
# [init] Waiting for the kubelet to boot up the control plane as Static Pods from directory "/etc/kubernetes/manifests".
# [init] This might take a minute or longer if the control plane images have to be pulled.
# [apiclient] All control plane components are healthy after 53.001876 seconds
# [uploadconfig] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
# [markmaster] Will mark node wongoolinux as master by adding a label and a taint
# [markmaster] Master wongoolinux tainted and labelled with key/value: node-role.kubernetes.io/master=""
# [bootstraptoken] Using token: b602fd.bfa40b59029f12c7
# [bootstraptoken] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
# [bootstraptoken] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
# [bootstraptoken] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
# [bootstraptoken] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
# [addons] Applied essential addon: kube-dns
# [addons] Applied essential addon: kube-proxy
#
# Your Kubernetes master has initialized successfully!
#
# To start using your cluster, you need to run the following as a regular user:
#
#   mkdir -p $HOME/.kube
#   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#   sudo chown $(id -u):$(id -g) $HOME/.kube/config
#
#
# You should now deploy a pod network to the cluster.
# Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
#   https://kubernetes.io/docs/concepts/cluster-administration/addons/
#
# You can now join any number of machines by running the following on each node
# as root:
#
#   kubeadm join --token b602fd.bfa40b59029f12c7 172.16.3.235:6443 --discovery-token-ca-cert-hash sha256:1ad1b73ae1c306c3572da4b34e685a5cb129d1159a3783a657dd5d4de0b37067


# Installing a pod network
kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml

# By default, your cluster will not schedule pods on the master for security reasons.
# If you want to be able to schedule pods on the master, e.g. for a single-machine Kubernetes cluster for development, run:
kubectl taint nodes --all node-role.kubernetes.io/master-

useradd kubernetes
mkdir -p /home/kubernetes/.kube
cp -i /etc/kubernetes/admin.conf /home/kubernetes/.kube/config
chown -R kubernetes:kubernetes /home/kubernetes/.kube

# If you want to connect to the API Server from outside the cluster you can use kubectl proxy:
kubectl proxy

curl http://localhost:8001/api/v1

kubectl get svc
