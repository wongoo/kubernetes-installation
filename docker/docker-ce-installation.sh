#!/bin/sh

if hash docker 2>/dev/null; then
    echo "docker exists"
else
    echo "-------> remove old docker"
    yum -y remove docker docker-common docker-selinux docker-engine

    echo "-------> install yum-utils"
    yum install -y yum-utils device-mapper-persistent-data lvm2

    echo "-------> install docker ce repo"
    yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo

    yum-config-manager --disable docker-ce-edge
    yum-config-manager --disable docker-ce-test
    yum makecache fast

    echo "-------> show docker versions"
    yum list docker-ce.x86_64  --showduplicates |sort -r

    echo "-------> start install docker"
    yum install -y --setopt=obsoletes=0 \
    docker-ce-17.03.2.ce-1.el7.centos \
    docker-ce-selinux-17.03.2.ce-1.el7.centos

    touch /etc/docker/daemon.json
    cat <<EOF >  /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
EOF

    sudo echo "DOCKER_OPTS=\"--registry-mirror=http://hub-mirror.c.163.com\"" >> /etc/default/docker

    echo "-------> start docker service"
    systemctl enable docker
    systemctl start docker

fi


echo "-------> show docker info"
docker info
