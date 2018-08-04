#!/bin/sh

echo "-------> start config centos7"


# echo "-----------> disable firewalld"
# systemctl disable firewalld
# systemctl stop firewalld

# echo "-----------> disable selinux"
# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl -p /etc/sysctl.d/k8s.conf


# Kubernetes v1.8+ 要求關閉系統 Swap
swapoff -a && sysctl -w vm.swappiness=0

# 不同機器會有差異
sed '/swap.img/d' -i /etc/fstab