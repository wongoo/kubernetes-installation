GO_VERSION=1.10

if hash go 2>/dev/null; then
    echo "go lang exists"
else
    echo "-------> download go"
    curl -O https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
    echo "-------> install go"
    sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz

    echo "-------> create /etc/go"
    sudo mkdir /etc/go

    echo "-------> config go"
cat > /etc/go/profile <<EOF
export GOROOT=/usr/local/go
export GOPATH=\$GOROOT/repo
export GOBIN=\$GOROOT/bin
export PATH=\$GOBIN:\$PATH
EOF

    echo "-------> go env"
echo >> /etc/profile <<EOF

source /etc/go/profile
EOF

    echo "-------> log go env"
    source /etc/go/profile

    echo "-------> test go"
    echo "GOROOT=$GOROOT"
    echo "GOPATH=$GOPATH"
    echo "GOBIN=$GOBIN"
    echo "PATH=$PATH"

fi
