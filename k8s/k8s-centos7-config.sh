#!/bin/sh


echo "-------> start config centos7"

if [ -f /etc/sysctl.d/k8s.conf ]
then
    echo "/etc/sysctl.d/k8s.conf exists"
else

# RHEL/CentOS 7 have reported issues with traffic being routed incorrectly due to iptables being bypassed
cat <<EOF >  /etc/sysctl.d/k8s.conf
# 不开启 IPv6，因此注释掉
# net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
# 配置生效
sysctl --system

fi

