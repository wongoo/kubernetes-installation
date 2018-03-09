# On each of your machines, install Docker. Version v1.12 is recommended, but v1.11, v1.13 and 17.03 are known to work as well.
# Versions 17.06+ might work, but have not yet been tested and verified by the Kubernetes node team.

yum -y remove docker docker-common docker-selinux docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo

yum-config-manager --disable docker-ce-edge
yum-config-manager --disable docker-ce-test
yum makecache fast

yum list docker-ce.x86_64  --showduplicates |sort -r
yum install -y --setopt=obsoletes=0 \
    docker-ce-17.03.2.ce-1.el7.centos \
    docker-ce-selinux-17.03.2.ce-1.el7.centos

systemctl enable docker
systemctl start docker