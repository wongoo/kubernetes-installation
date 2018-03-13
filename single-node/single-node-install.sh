
mkdir temp
rm -rf temp/*

source single-node/single-node-env.sh

cert/generate-cert.sh

docker/docker-ce-installation.sh

etcd/etcd-install.sh

k8s/k8s-master-install.sh


