# 产生安装所需证书

if hash cfssl 2>/dev/null; then
    echo "cfssl exists"
else
    go/go-lang-install.sh

    echo "-------> start download cfssl"
    go get -u github.com/cloudflare/cfssl/cmd/...
fi

# ===========go into directory cert
cd cert/

# ===================================
if [ -f ca.pem ] && [ -f ca-key.pem ]
then
    echo "-------> ca.pem and ca-key.pem exits"
else
    echo "-------> generate ca cert"
    cfssl gencert -initca ca-csr.json | cfssljson -bare ca
fi

# ===================================
if [ -f kubernetes.pem ] && [ -f kubernetes-key.pem ]
then
    echo "-------> kubernetes.pem and kubernetes-key.pem exits"
else
    echo "-------> generate kubernetes cert"
    cp kubernetes-csr.json kubernetes-csr.json.tmp
    sed -i "s/123.123.123.123/$INSTALL_PARAM_MASTER_IP/g" kubernetes-csr.json.tmp
    cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes \
        kubernetes-csr.json.tmp | cfssljson -bare kubernetes
fi

# ===================================
if [ -f admin.pem ] && [ -f admin-key.pem ]
then
    echo "-------> admin.pem and admin-key.pem exits"
else
    echo "-------> generate admin cert"
    cfssl gencert  -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes \
        admin-csr.json | cfssljson -bare admin
fi

# ===================================
if [ -f kube-proxy.pem ] && [ -f kube-proxy-key.pem ]
then
    echo "-------> kube-proxy.pem and kube-proxy-key.pem exits"
else
    echo "-------> generate kube proxy cert"
    cfssl gencert  -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes \
        kube-proxy-csr.json | cfssljson -bare kube-proxy
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