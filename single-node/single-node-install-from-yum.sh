
mkdir temp
rm -rf temp/*

source single-node/single-node-env.sh
docker/docker-ce-installation.sh
k8s/k8s-master-install-from-yum.sh



