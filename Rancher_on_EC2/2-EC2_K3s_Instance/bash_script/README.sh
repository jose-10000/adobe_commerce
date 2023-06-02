#!/bin/bash
# Deployment of K3S on Debian 11

# 1. Make a mysql database for k3s, https://ranchermanager.docs.rancher.com/v2.5/how-to-guides/new-user-guides/infrastructure-setup/mysql-database-in-amazon-rds
## and save the next link mysql://username:password@tcp(hostname:3306)/database-name


# 2. Create a new EC2 instance with Debian 11 with the following user data
##t2.micro
## Debian 11 (ami-0a9d27a9f4f5c0efc)
## 8 GB SSD
## Security group: Rancher
## public IP
## Public Subnet
## IAM role: Rancher


# 2.1 Create a Nginx Load Balancer, https://ranchermanager.docs.rancher.com/v2.5/how-to-guides/new-user-guides/infrastructure-setup/nginx-load-balancer 
sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx





# 3. SSH into the instance
# 4. Run the following commands



# Update the system
sudo apt update -y # || sudo apt upgrade -y