#!/bin/bash
set -e
MINIKUBE_VERSION="0.31.0"
KUBECTL_VERSION="1.13.0"

case $OSTYPE in 
  darwin*)
    echo "Installing for OSX"
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
    curl -Lo kubectl http://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/darwin/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
    ;;
    linux*)
      echo "Installing for Linux"
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
    curl -Lo kubectl http://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
    ;;
  *) echo "Unknown ostype"
    exit 1
    ;;
esac
