#!/bin/bash
# Deployment of Adobe Commerce 2.4.5 on Ubuntu 22.04 LTS

# Update the system
sudo apt update -y # || sudo apt upgrade -y

# Install a few prerequisite packages which let apt use packages over HTTPS
sudo apt -y install apt-transport-https ca-certificates curl gnupg

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
sudo apt update -y


# Install Docker
sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your username to the docker group:
sudo usermod -aG docker ${USER}



# Rancher minimum installation command.
sudo docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  rancher/rancher:stable




# Go to https://<Rancher-Server-IP> and login with default password
# For the first time, it will ask to put the password and then it will ask to create a new password.
# Ussing SSH, login to the server and run the following command to get the password. Then copy the password and paste it to the Rancher login page.

# CONTAINERID=$(docker ps | grep "rancher/rancher" | awk '{print $1}' | xargs)  # This will give you the container id and put it to the variable CONTAINERID
# sudo docker logs $CONTAINERID 2>&1 | grep "Bootstrap Password"


# Add bitnami repo to Rancher
  # Menu > Cluster Management > Advanced > Repositories > Create
  # Name: bitnami
  # URL: https://charts.bitnami.com/bitnami



# Add AWS Credentials to Rancher, you need to create an IAM user with the following permissions:
  
  # Menu > Cluster Management > Cloud Credentials > Create > Amazon
  # Name: AWS
  # Access Key ID: <AWS Access Key ID>
  # Secret Key ID: <AWS Secret Key ID>
  # Default Region: <AWS Region>
  # Click on Create

# Generate Templates


