#!/bin/bash
# Deployment of Adobe Commerce 2.4.5 on Ubuntu 22.04 LTS

# Update the system
sudo apt update -y # || sudo apt upgrade -y

# Install a few prerequisite packages which let apt use packages over HTTPS
sudo apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Add the GPG key for the official Docker repository to the system
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the Docker repository to APT sources
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package database with the Docker packages from the newly added repo
sudo apt update


# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your username to the docker group:
sudo usermod -aG docker ${USER}

# To apply the new group membership, log out of the server and back in, or type the following:
sudo su - ${USER}

# Rancher minimum installation command.
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  rancher/rancher:latest

# Rancher installation command with custom hostname.

