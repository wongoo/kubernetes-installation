
export CURR_NODE_IP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
echo "current ip: $CURR_NODE_IP"

export INSTALL_PARAM_APISERVER_IP=$CURR_NODE_IP
export INSTALL_PARAM_MASTER_IP=$CURR_NODE_IP
export INSTALL_PARAM_ETCD_CLUSTER_LIST="infra1=https://$CURR_NODE_IP:2380"

export INSTALL_K8S_VERSION=v1.9.3


