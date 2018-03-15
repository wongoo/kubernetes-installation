#!/bin/sh

previous_dir=$(dir)

cd /etc/kubernetes/ssl

openssl verify -CAfile ca.pem kubernetes.pem
openssl verify -CAfile ca.pem kube-proxy.pem
openssl verify -CAfile ca.pem admin.pem

cd $previous_dir

