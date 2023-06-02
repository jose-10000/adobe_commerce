#!/bin/bash
# Deployment of Adobe Commerce 2.4.5 on Ubuntu 22.04 LTS


# Update the system
sudo apt update -y # || sudo apt upgrade -y


# Install a few prerequisite packages which let apt use packages over HTTPS
sudo apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common


###################### Install kubernetes ######################
 curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

 chmod +x ./kubectl

  sudo mv ./kubectl /usr/local/bin/kubectl


# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Add rancher-latest Helm chart repository
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable


# Update your local Helm chart repository cache
helm repo update


# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.11.0


# Install Rancher
helm repo add rancher-latest https://releases.rancher.com/server-charts/stable
kubectl create namespace cattle-system
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=ec2-54-78-167-233.eu-west-1.compute.amazonaws.com \
  --set ingress.tls.source=letsEncrypt \
  --set
    --set letsEncrypt.email=your_email_address




