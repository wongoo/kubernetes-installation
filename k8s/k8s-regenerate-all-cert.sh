#!/bin/sh

cert/clean-cert.sh

cert/generate-cert.sh

k8s/k8s-token.sh

k8s/k8s-kubelet-bootstrapping-kubeconfig.sh

k8s/k8s-kube-proxy-kubeconfig.sh

k8s/k8s-kubectl-kubeconfig.sh


