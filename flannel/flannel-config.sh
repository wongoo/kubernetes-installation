#!/bin/sh

#执行下面的命令为docker分配IP地址段。
etcdctl --endpoints=$ETCD_ENDPOINTS \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  mkdir /kube-centos/network

etcdctl --endpoints=$ETCD_ENDPOINTS \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  rm /kube-centos/network/config

etcdctl --endpoints=$ETCD_ENDPOINTS \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  mk /kube-centos/network/config '{"Network":"10.254.0.0/16","SubnetLen":24,"Backend":{"Type":"vxlan"}}'


echo "-------> start config flanneld"

# =========================================================
yum -y install flannel

systemctl stop flanneld

# =========================================================
mv /usr/lib/systemd/system/flanneld.service /usr/lib/systemd/system/flanneld.service.orignal
mv /etc/sysconfig/flanneld /etc/sysconfig/flanneld.orignal

# =========================================================
cp flannel/flanneld.service /usr/lib/systemd/system/flanneld.service
cp flannel/flanneld /etc/sysconfig/flanneld

sed -i "s#__ETCD_ENDPOINTS__#$ETCD_ENDPOINTS#g" /etc/sysconfig/flanneld

# =========================================================
systemctl daemon-reload

systemctl enable flanneld
systemctl start flanneld
systemctl status flanneld

# =========================================================
cat /run/flannel/subnet.env
cat /run/docker_opts.env

# =========================================================
if grep -Fxq "flannel" /usr/lib/systemd/system/docker.service
then
    echo "/usr/lib/systemd/system/docker.service contains flannel config"
else

sed -i '/ExecStart=/i \
EnvironmentFile=-/run/flannel/docker \
EnvironmentFile=-/run/docker_opts.env \
EnvironmentFile=-/run/flannel/subnet.env \
EnvironmentFile=-/etc/sysconfig/docker \
EnvironmentFile=-/etc/sysconfig/docker-storage \
EnvironmentFile=-/etc/sysconfig/docker-network \
EnvironmentFile=-/run/docker_opts.env' /usr/lib/systemd/system/docker.service

fi

