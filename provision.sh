#!/bin/bash
set -ex
MINIKUBE_VERSION="0.13.1"
KUBECTL_VERSION="1.3.0"

case $OSTYPE in 
  darwin*)
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
    curl -Lo kubectl http://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/darwin/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
    ;;
    linux*)
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
    curl -Lo kubectl http://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
    ;;
  *) echo "Unknown ostype"
    exit 1
    ;;
esac
