
mkdir temp
rm -rf temp/*

source single-node/single-node-env.sh

docker/docker-ce-installation.sh

cert/cert-generate.sh

cert/cert-ca-to-trusted.sh

etcd/etcd-install-from-binary.sh

k8s/k8s-master-install-from-binary.sh



