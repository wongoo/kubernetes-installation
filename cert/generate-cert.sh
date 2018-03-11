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

echo "-------> generate ca cert"
cfssl gencert -initca ca-csr.json | cfssljson -bare ca

echo "-------> generate kubernetes cert"
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes \
    kubernetes-csr.json | cfssljson -bare kubernetes

echo "-------> generate admin cert"
cfssl gencert  -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes \
    admin-csr.json | cfssljson -bare admin

echo "-------> generate kube proxy cert"
cfssl gencert  -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes \
    kube-proxy-csr.json | cfssljson -bare kube-proxy

echo "-------> check kubernetes cert"
openssl x509  -noout -text -in  kubernetes.pem
cfssl-certinfo -cert kubernetes.pem


echo "-------> move certs to /etc/kubernetes/ssl"
sudo mkdir -p /etc/kubernetes/ssl
sudo cp *.pem /etc/kubernetes/ssl


# ===========go out
cd ..