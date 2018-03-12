#!/bin/sh

echo "-------> start generate token"

if [ -f /etc/kubernetes/token.csv ]
then
    echo "/etc/kubernetes/token.csv exists"
    export BOOTSTRAP_TOKEN=$(cat /etc/kubernetes/token.csv | awk -F ',' '{print $1}')
else
    export BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
    cat > /etc/kubernetes/token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF

fi

echo "BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN"


