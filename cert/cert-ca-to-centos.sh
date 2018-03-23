#!/bin/sh

# -----------CentOS 查看根证书-------------------------------
# 确认/etc/pki/tls/certs/ca-bundle.crt文件中， 是否存在以下内容:
# DigiCert Global Root CA
# Serial Number:  08:3b:e0:56:90:42:46:b1:a1:75:6a:c9:59:91:c7:4a
# Baltimore CyberTrust Root
# Serial Number: 0x20000b9

#
grep "kubernet" /etc/pki/tls/certs/ca-bundle.crt
# 确保 ca-bundle.crt 中的证书和ca证书一致


# -----------CentOS 安装根证书-------------------------------
# 安装根证书管理包软件:
yum install ca-certificates

# 打开根证书动态配置开关:
update-ca-trust force-enable

# 将DigiCert的根证书文件复制到:
cp /etc/kubernetes/ssl/ca.pem /etc/pki/ca-trust/source/anchors/k8s-ca.crt

# 安装根证书:
update-ca-trust extract
