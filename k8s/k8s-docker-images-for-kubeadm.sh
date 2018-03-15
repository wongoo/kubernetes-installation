#!/bin/sh

# 注：如果你会科学上网，可以不做这一步
# 以下通过添加tag将房屋gcr.io的镜像转到房屋从aliyuncs下载的镜像
# aliyun docker hub: https://dev.aliyun.com/search.html?spm=5176.1972344.0.1.79a95aaaF5Nzqy

docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.9.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.9.3 gcr.io/google_containers/kube-apiserver-amd64:v1.9.3


docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.9.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.9.3 gcr.io/google_containers/kube-controller-manager-amd64:v1.9.3


docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.9.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.9.3 gcr.io/google_containers/kube-scheduler-amd64:v1.9.3

docker pull registry.cn-hangzhou.aliyuncs.com/google-containers/etcd-amd64:3.1.11
docker tag registry.cn-hangzhou.aliyuncs.com/google-containers/etcd-amd64:3.1.11 gcr.io/google_containers/etcd-amd64:3.1.11

docker images

#- There is no internet connection, so the kubelet cannot pull the following control plane images:
# gcr.io/google_containers/kube-apiserver-amd64:v1.9.3
# gcr.io/google_containers/kube-controller-manager-amd64:v1.9.3
# gcr.io/google_containers/kube-scheduler-amd64:v1.9.3
# gcr.io/google_containers/etcd-amd64:3.1.11
# gcr.io/google_containers/pause-amd64:3.0
