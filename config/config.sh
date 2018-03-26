#!/bin/sh

source config/current-ip.sh

# --------------------------------------------------------
export K8S_VER=v1.9.3
echo "K8S_VER=$K8S_VER"

export K8S_CLUSTER_IP_RANGE=10.254.0.0/16
echo "K8S_CLUSTER_IP_RANGE=$K8S_CLUSTER_IP_RANGE"

export K8S_APISERVER_IP=$CURR_NODE_IP
echo "K8S_APISERVER_IP=$K8S_APISERVER_IP"

export K8S_MASTER_IP=$CURR_NODE_IP
echo "K8S_MASTER_IP=$K8S_MASTER_IP"

export K8S_MASTER_URL=https://$CURR_NODE_IP:6443
echo "K8S_MASTER_URL=$K8S_MASTER_URL"

# --------------------------------------------------------
export ETCD_VER=v3.3.2
echo "ETCD_VER=$ETCD_VER"

export ETCD_NAME=infra1
echo "ETCD_NAME=$ETCD_NAME"

export ETCD_ENDPOINTS=https://$CURR_NODE_IP:2379
echo "ETCD_ENDPOINTS=$ETCD_ENDPOINTS"

export ETCD_PEER_URLS=https://$CURR_NODE_IP:2380
echo "ETCD_PEER_URLS=$ETCD_PEER_URLS"

export ETCD_ADVERTISE_PEER_URLS=https://$CURR_NODE_IP:2380
echo "ETCD_ADVERTISE_PEER_URLS=$ETCD_ADVERTISE_PEER_URLS"

export ETCD_ADVERTISE_CLIENT_URLS=https://$CURR_NODE_IP:2379
echo "ETCD_ADVERTISE_CLIENT_URLS=$ETCD_ADVERTISE_CLIENT_URLS"

export ETCD_CLUSTER_LIST=infra1=https://$CURR_NODE_IP:2380
echo "ETCD_CLUSTER_LIST=$ETCD_CLUSTER_LIST"
# --------------------------------------------------------

source config/k8s-token.sh
