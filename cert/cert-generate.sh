#!/bin/sh
# ------------------------
# 产生安装所需证书



# ------------------------
# install cfssl tool
# ------------------------

if hash cfssl 2>/dev/null; then
    echo "cfssl exists"
else
    go/go-lang-install.sh

    echo "-------> start download cfssl"
    # yum install gcc
    # ---> go needed
    # go get -u github.com/cloudflare/cfssl/cmd/...

    export CFSSL_URL="https://pkg.cfssl.org/R1.2"
    wget "${CFSSL_URL}/cfssl_linux-amd64" -O /usr/local/bin/cfssl
    wget "${CFSSL_URL}/cfssljson_linux-amd64" -O /usr/local/bin/cfssljson
    wget "${CFSSL_URL}/cfssl-certinfo_linux-amd64" -O /usr/local/bin/cfssl-certinfo

    chmod +x /usr/local/bin/cfssl*
fi

# ------------------------
# go into directory cert
# ------------------------
cd cert/
echo "current dir:$(pwd)"

# ------------------------
# generate ca-key.pem
# ------------------------
if [ -f ca.pem ] && [ -f ca-key.pem ]
then
    echo "-------> ca.pem and ca-key.pem exits"
else
    echo "-------> generate ca cert"
    cfssl gencert -initca pki/ca-csr.json | cfssljson -bare ca
fi

# ------------------------
# generate kubernetes-key.pem
# ------------------------
if [ -f kubernetes.pem ] && [ -f kubernetes-key.pem ]
then
    echo "-------> kubernetes.pem and kubernetes-key.pem exits"
else
    echo "-------> generate kubernetes cert"
    rm -f kubernetes-csr.json.tmp
    cp  pki/kubernetes-csr.json pki/kubernetes-csr.json.tmp
    sed -i s/__K8S_NODE1__/${K8S_NODE1}/g kubernetes-csr.json.tmp
    sed -i s/__K8S_NODE2__/${K8S_NODE2}/g kubernetes-csr.json.tmp
    sed -i s/__K8S_NODE3__/${K8S_NODE3}/g kubernetes-csr.json.tmp

    cfssl gencert -ca=ca.pem \
        -ca-key=ca-key.pem \
        -config=pki/ca-config.json \
        -profile=kubernetes \
        pki/kubernetes-csr.json.tmp | cfssljson -bare kubernetes
fi


# ------------------------
# generate admin-key.pem
# ------------------------
if [ -f admin.pem ] && [ -f admin-key.pem ]
then
    echo "-------> admin.pem and admin-key.pem exits"
else
    echo "-------> generate admin cert"
    cfssl gencert  -ca=ca.pem \
        -ca-key=ca-key.pem \
        -config=pki/ca-config.json \
        -profile=kubernetes \
        pki/admin-csr.json | cfssljson -bare admin
fi

# ------------------------
# generate kube-proxy-key.pem
# ------------------------
if [ -f kube-proxy.pem ] && [ -f kube-proxy-key.pem ]
then
    echo "-------> kube-proxy.pem and kube-proxy-key.pem exits"
else
    echo "-------> generate kube proxy cert"
    cfssl gencert  -ca=ca.pem \
        -ca-key=ca-key.pem \
        -config=pki/ca-config.json \
        -profile=kubernetes \
        pki/kube-proxy-csr.json | cfssljson -bare kube-proxy
fi


# ===================================
echo "-------> check kubernetes cert"
openssl x509  -noout -text -in  kubernetes.pem
cfssl-certinfo -cert kubernetes.pem

# ===================================
echo "-------> move certs to /etc/kubernetes/ssl"
sudo mkdir -p /etc/kubernetes/ssl
sudo cp *.pem /etc/kubernetes/ssl

# ===========go out
cd ..
echo "current dir:$(pwd)"