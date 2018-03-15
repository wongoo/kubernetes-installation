#!/bin/sh

# 注：如果你会科学上网，可以不做这一步
# 以下通过添加tag将房屋gcr.io的镜像转到房屋从aliyuncs下载的镜像
# aliyun docker hub: https://dev.aliyun.com/search.html?spm=5176.1972344.0.1.79a95aaaF5Nzqy

# gcr.io/google_containers/pause-amd64:3.0 是POD默认的容器,可以通过kubelet启动参数--pod-infra-container-image指定.
docker pull registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0
docker tag registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0 gcr.io/google_containers/pause-amd64:3.0

docker images
