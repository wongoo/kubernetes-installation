
mkdir temp
rm -rf temp/*

source single-node/single-node-env.sh

cert/generate-cert.sh

docker/docker-ce-installation.sh

etcd/etcd-install.sh


