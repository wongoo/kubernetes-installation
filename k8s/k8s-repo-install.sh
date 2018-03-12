#!/bin/sh


if [ -f /etc/yum.repos.d/kubernetes.repo ]
then
    echo "/etc/yum.repos.d/kubernetes.repo exists"
else

# 安装kubernetes镜像
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
     http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

fi