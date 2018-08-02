#!/bin/sh

echo "-------> start docker"

# If the Docker cgroup driver and the kubelet config don’t match,
# change the kubelet config to match the Docker cgroup driver. The flag you need to change is --cgroup-driver.
# If it’s already set, you can update like so:

K8S_NODE_CGROUP_DRIVER=$(cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf|grep  cgroup-driver | grep -v grep | awk '{match($0,"cgroup-driver=([a-z]+)",a)}END{print a[1]}')
DOCKER_CGROUP_DRIVER=$(docker info | grep -i cgroup|awk '{match($0,"Cgroup Driver: (.+)",a)}END{print a[1]}')

echo "K8S_NODE_CGROUP_DRIVER=$K8S_NODE_CGROUP_DRIVER"
echo "DOCKER_CGROUP_DRIVER=$DOCKER_CGROUP_DRIVER"

if [ "$DOCKER_CGROUP_DRIVER" != "$K8S_NODE_CGROUP_DRIVER" ]
then
    echo "-----------> set kubelet cgroup-driver=$DOCKER_CGROUP_DRIVER"
    sed -i "s/cgroup-driver=$K8S_NODE_CGROUP_DRIVER/cgroup-driver=$DOCKER_CGROUP_DRIVER/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
    systemctl daemon-reload
fi

echo "cgroup-driver=$DOCKER_CGROUP_DRIVER"
