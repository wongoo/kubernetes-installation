#!/bin/sh

source config/current-ip.sh

# --------------------------------------------------------

export K8S_NODE1=10.204.0.11
export K8S_NODE2=10.204.0.12
export K8S_NODE3=10.204.0.6

export K8S_MASTER_IP=10.204.0.11
export K8S_APISERVER_IP=$K8S_MASTER_IP
export K8S_MASTER_URL=https://$K8S_MASTER_IP:6443

export K8S_VER=v1.9.3
export K8S_CLUSTER_IP_RANGE=10.254.0.0/16

# --------------------------------------------------------

export V_ETCD_NODE1=${K8S_NODE1//./_}
export V_ETCD_NODE2=${K8S_NODE2//./_}
export V_ETCD_NODE3=${K8S_NODE3//./_}

export V_ETCD_VER=v3.3.2
export V_ETCD_NAME=${CURR_NODE_IP//./_}
export V_ETCD_LISTEN_CLIENT_URLS=https://$CURR_NODE_IP:2379
export V_ETCD_LISTEN_PEER_URLS=https://$CURR_NODE_IP:2380
export V_ETCD_ADVERTISE_PEER_URLS=https://$CURR_NODE_IP:2380
export V_ETCD_ADVERTISE_CLIENT_URLS=https://$CURR_NODE_IP:2379
export V_ETCD_CLUSTER_LIST=$V_ETCD_NODE1=https://$K8S_NODE1:2380,$V_ETCD_NODE2=https://$K8S_NODE2:2380,$V_ETCD_NODE3=https://$K8S_NODE3:2380

# --------------------------------------------------------

source config/k8s-token.sh

env |grep CURR_NODE_I
env |grep K8S
env |grep ETCD