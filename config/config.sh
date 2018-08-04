#!/bin/sh

source config/current-ip.sh

# --------------------------------------------------------
# v1.11.1 release note: https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.11.md#v1111
# --------------
# - As a reminder, etcd2 as a backend is deprecated and support will be removed in Kubernetes 1.13. Please ensure that your clusters are upgraded to etcd3 as soon as possible.
# - Default etcd server version is v3.2.18 compared with v3.1.12 in v1.10 (#61198)
# - The Go version is go1.10.2, as compared to go1.9.3 in v1.10. (#63412)
# - Influxdb is unchanged from v1.10: v1.3.3 (#53319)
# - The validated docker versions are the same as for v1.10: 1.11.2 to 1.13.1 and 17.03.x (ref)


# --------------------------------------------------------
# Custom Configuration
# --------------------------------------------------------
export K8S_VER=v1.11.1
export ETCD_VER=v3.2.18

export K8S_NODE1=10.204.0.11
export K8S_NODE2=10.204.0.12
export K8S_NODE3=10.204.0.6

export K8S_MASTER_IP=10.204.0.11
export K8S_MASTER_URL=https://$K8S_MASTER_IP:6443

export K8S_APISERVER_IP=$K8S_MASTER_IP
export K8S_APISERVER_URL="https://$K8S_APISERVER_IP:6443"

export K8S_CLUSTER_NAME=kubernetes
export K8S_CLUSTER_IP_RANGE=10.254.0.0/16

# --------------------------------------------------------
# NOT MODIFY THE FOLLOWING
# --------------------------------------------------------

export V_ETCD_NODE1=${K8S_NODE1//./_}
export V_ETCD_NODE2=${K8S_NODE2//./_}
export V_ETCD_NODE3=${K8S_NODE3//./_}

export V_ETCD_NAME=${CURR_NODE_IP//./_}
export V_ETCD_LISTEN_CLIENT_URLS=https://$CURR_NODE_IP:2379
export V_ETCD_LISTEN_PEER_URLS=https://$CURR_NODE_IP:2380
export V_ETCD_ADVERTISE_PEER_URLS=https://$CURR_NODE_IP:2380
export V_ETCD_ADVERTISE_CLIENT_URLS=https://$CURR_NODE_IP:2379
export V_ETCD_CLUSTER_LIST=$V_ETCD_NODE1=https://$K8S_NODE1:2380,$V_ETCD_NODE2=https://$K8S_NODE2:2380,$V_ETCD_NODE3=https://$K8S_NODE3:2380

# --------------------------------------------------------

source config/k8s-token.sh

env |grep CURR_NODE_IP
env |grep K8S
env |grep ETCD